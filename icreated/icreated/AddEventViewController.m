//
//  AddEventViewController.m
//  icreated
//
//  Created by Artem Lobanov on 21/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "AddEventViewController.h"
#import "AddEventViewController+AddPin.h"
#import "AddEventViewController+DatePicker.h"
#import <QuartzCore/QuartzCore.h> // Maybe needed for borders

@interface UIActionSheet (NonFirstResponder)
@end

@implementation UIActionSheet (NonFirstResponder)
- (BOOL)canBecomeFirstResponder
{
    return NO;
}
@end


@implementation AddEventViewController

- (void)viewDidLoad {
    self.menuButton.target = self.revealViewController;
    self.menuButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.menuButton.title = @"\uf0c9";
    [self.menuButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIFont fontWithName:@"FontAwesome" size:26.0], NSFontAttributeName, nil]
                                   forState:UIControlStateNormal];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.takeController = [FDTakeController new];
    [self.takeController setDelegate:self];
    
    self.accessoryViewEnabledSubFlag = YES;
    self.accessoryViewEnabledFlag = YES;
    
    self.scrollViewHeight.constant = self.view.bounds.size.height - BAR_HEIGHT - self.accessoryView.bounds.size.height;
    self.innerViewHeight.constant = self.view.bounds.size.height - BAR_HEIGHT - self.accessoryView.bounds.size.height;
    
    [self initView];
    [self initAccessoryView];
}

- (void)initView {
    self.bottomConstraint.priority = 800;
    
    for (NSLayoutConstraint *height in self.heights) {
        height.constant = 0;
    }
    
    self.bottomConstraint.constant = 0.0f;
    
    self.firstFreeViewIndex = 0;
}

- (void)initAccessoryView {
    self.accessoryButtons = [NSMutableArray array];
    self.accessoryButtonSymbols = @[@"\uf02b", @"\uf041", @"\uf017", @"\uf030", @"\uf13e"];
    
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
    
    [self.accessoryButtons[1] addTarget:self action:@selector(pushAddPinViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.accessoryButtons[2] addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.accessoryButtons[3] addTarget:self action:@selector(showPhotoPicker) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    // Костыль, чтобы accessoryView точно появился, без него в паре исключительных случаев не появляется
    [self becomeFirstResponder];
    
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
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)showPhotoPicker {
    [self.takeController takePhotoOrChooseFromLibrary];
    self.accessoryViewEnabledSubFlag = NO;
}

// FDTakeDelegate method
- (void)takeController:(FDTakeController *)controller didCancelAfterAttempting:(BOOL)madeAttempt {
    self.accessoryViewEnabledSubFlag = YES;
}

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info {
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if (keyboardSize.height == 260 && self.firstFreeViewIndex > 0) {
        self.textViewHeight.priority = 950;
    }
    
    NSLog(@"%f, %f, %f", self.view.bounds.size.height, BAR_HEIGHT, keyboardSize.height);
    self.scrollViewHeight.constant = self.view.bounds.size.height - BAR_HEIGHT - keyboardSize.height;
    self.innerViewHeight.constant = self.view.bounds.size.height - BAR_HEIGHT - keyboardSize.height + NORMAL_VIEW_HEIGHT * self.firstFreeViewIndex;
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
    
    NSLog(@"AddEvent keyboardWillShow, height = %f", keyboardSize.height);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.textViewHeight.priority = 750;
    if (keyboardSize.height < 260.0f) {
        self.scrollViewHeight.constant = self.view.bounds.size.height - BAR_HEIGHT;
        self.innerViewHeight.constant = self.view.bounds.size.height - BAR_HEIGHT;
    }
    else {
        [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.scrollViewHeight.constant = self.view.bounds.size.height - BAR_HEIGHT - self.accessoryView.bounds.size.height;
            self.innerViewHeight.constant = self.view.bounds.size.height - BAR_HEIGHT - self.accessoryView.bounds.size.height;
            
            [self.view layoutIfNeeded];
        } completion:nil];
    }
    
    if (!self.accessoryViewEnabledSubFlag) {
        self.accessoryViewEnabledFlag = NO;
        [self.textView resignFirstResponder];
    }
    
    NSLog(@"AddEvent keyboardWillHide, height = %f", keyboardSize.height);
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
}

@end
