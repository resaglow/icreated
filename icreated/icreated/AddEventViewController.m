//
//  AddEventViewController.m
//  icreated
//
//  Created by Artem Lobanov on 21/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "AddEventViewController.h"
#import "AddEventViewController+GestureHandlers.h"
#import "AddEventViewController+EventSender.h"
#import "AddEventViewController+PinPicker.h"
#import "AddEventViewController+DatePicker.h"
#import "AddEventViewController+PhotoPicker.h"
#import "MainViewController.h"

@interface UIActionSheet (NonFirstResponder)
@end

@implementation UIActionSheet (NonFirstResponder)
- (BOOL)canBecomeFirstResponder
{
    return NO;
}
@end


@implementation AddEventViewController

- (void)resign {
    [self.textView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textView setDelegate:self];
    
    self.menuButton.target = self.revealViewController;
    self.menuButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.revealViewController setDelegate:self];
    
    self.menuButton.title = @"\uf0c9";
    [self.menuButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"FontAwesome" size:kFABarButtonFontSize], NSFontAttributeName, nil]
                                   forState:UIControlStateNormal];
    
    self.addButton.title = @"\uf14a";
    [self.addButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"FontAwesome" size:kFABarButtonFontSize], NSFontAttributeName, nil]
                                  forState:UIControlStateNormal];
    self.addButton.target = self;
    self.addButton.action = @selector(sendEvent);
    
    
    UILabel *titleViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 40)];
    titleViewLabel.text = NSLocalizedString(@"New event", @"");
    titleViewLabel.textAlignment = NSTextAlignmentCenter;
    titleViewLabel.font = [UIFont fontWithName:@"FontAwesome" size:25.0];
    titleViewLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleViewLabel;
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.eventDate = nil;
    self.annotation = nil;
    
    self.takeController = [FDTakeController new];
    [self.takeController setDelegate:self];
    
    self.photos = [NSMutableArray array];
    [self.photosView setDataSource:self];
    [self.photosView setDelegate:self];
    self.photosView.bounces = YES;
    self.photosView.alwaysBounceHorizontal = YES;
    
    self.accessoryViewEnabledSubFlag = YES;
    self.accessoryViewEnabledFlag = YES;
    
    self.scrollViewHeight.constant = self.view.bounds.size.height - BAR_HEIGHT - self.accessoryView.bounds.size.height;
    self.innerViewHeight.constant = self.view.bounds.size.height - BAR_HEIGHT - self.accessoryView.bounds.size.height;
    
    [self initView];
    [self initAccessoryView];
    [self initSwipes];
}

- (void)initView {
    self.bottomConstraint.priority = 800;
    
    for (NSLayoutConstraint *height in self.heights) {
        height.constant = 0.0f;
    }
    self.photosViewHeight.constant = 0.0f;
    
    self.bottomConstraint.constant = 0.0f;
    
    self.firstFreeViewIndex = 0;
}

- (void)initAccessoryView {
    self.accessoryButtons = [NSMutableArray array];
    self.accessoryButtonSymbols = @[kFACategory, kFAPin, kFATime, kFAPhoto, kFALock];
    
    if (ACCESSORY_BUTTONS_COUNT > self.accessoryButtonSymbols.count) {
        NSLog(@"ERROR: TOO FEW BUTTON SYMBOLS)");
        return;
    }
    
    
    CGFloat buttonWidth = (self.accessoryView.bounds.size.width - (CGFloat)(ACCESSORY_BUTTONS_COUNT + 1) * ACCESSORY_PADDING) / (CGFloat)ACCESSORY_BUTTONS_COUNT;
    CGFloat buttonHeight = self.accessoryView.bounds.size.height - 2 * ACCESSORY_PADDING;
    
    for (NSInteger i = 0; i < ACCESSORY_BUTTONS_COUNT; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(ACCESSORY_PADDING + i * (buttonWidth + ACCESSORY_PADDING), ACCESSORY_PADDING, buttonWidth, buttonHeight);
        
        [button.titleLabel setFont:[UIFont fontWithName:@"FontAwesome" size:buttonHeight / 1.5]];
        NSString *buttonTitle = self.accessoryButtonSymbols[i];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [self.accessoryButtons addObject:button];
    }
    
    [self.accessoryButtons[DetailItemIndexPlace] addTarget:self action:@selector(pushPinPickerViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.accessoryButtons[DetailItemIndexTime] addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.accessoryButtons[DetailItemIndexPhotos] addTarget:self action:@selector(showPhotoPicker) forControlEvents:UIControlEventTouchUpInside];
    
    for (NSInteger i = 0; i < self.accessoryButtons.count; i++) {
        [self.accessoryView addSubview:self.accessoryButtons[i]];
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (UIView *)inputAccessoryView {
    if (self.accessoryViewEnabledFlag) return self.accessoryView;
    else return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.accessoryViewEnabledSubFlag = YES;
    self.accessoryViewEnabledFlag = YES;
    
    
    self.scrollViewHeight.constant = self.view.bounds.size.height - BAR_HEIGHT - self.accessoryView.bounds.size.height;
    self.innerViewHeight.constant = self.view.bounds.size.height - BAR_HEIGHT - self.accessoryView.bounds.size.height;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // For AccessoryView showing after photo selection
    [self becomeFirstResponder]; // For iOS 7.1
    [self reloadInputViews]; // For iOS 8
    
    // Observe keyboard hide and show notifications to resize the text view appropriately
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    NSLog(@"AddEvent keyboardWillShow, height = %f", keyboardSize.height);
    
    if (keyboardSize.height == self.accessoryView.bounds.size.height) {
        NSLog(@"Well, actually it's keyboardWillHide");
        [self keyboardWillHide:notification];
    }
    else {
        if (keyboardSize.height == 260 && self.firstFreeViewIndex > 0) {
            self.textViewHeight.priority = 950;
        }
        
        self.scrollViewHeight.constant = self.view.bounds.size.height - BAR_HEIGHT - keyboardSize.height;
        self.innerViewHeight.constant = self.view.bounds.size.height - BAR_HEIGHT - keyboardSize.height + NORMAL_VIEW_HEIGHT * self.firstFreeViewIndex;
        [UIView animateWithDuration:0.27f
                         animations:^{
                             [self.view layoutIfNeeded];
                         }
                         completion:nil];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    NSLog(@"AddEvent keyboardWillHide, height = %f", keyboardSize.height);
    
    self.textViewHeight.priority = 750;
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.scrollViewHeight.constant = self.view.bounds.size.height - BAR_HEIGHT - self.accessoryView.bounds.size.height;
        self.innerViewHeight.constant = self.view.bounds.size.height - BAR_HEIGHT - self.accessoryView.bounds.size.height;
        
        [self.view layoutIfNeeded];
    } completion:nil];
    
    if (!self.accessoryViewEnabledSubFlag) {
        self.accessoryViewEnabledFlag = NO;
        [self.textView resignFirstResponder];
    }
}

- (void)dismiss {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController *mainVC = (MainViewController *)[storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
    [self.navigationController pushViewController:mainVC animated:YES];
}

@end
