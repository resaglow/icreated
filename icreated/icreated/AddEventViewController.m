//
//  AddEventViewController.m
//  icreated
//
//  Created by Artem Lobanov on 21/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#define BAR_HEIGHT 64.0f

#define VIEW_PADDING 5.0f
#define NORMAL_VIEW_HEIGHT 40.0f

#define ACCESSORY_BUTTONS_COUNT 5
#define ACCESSORY_PADDING 1

#define DATEPICKER_MINUTE_INTERVAL 5

#import "ActionSheetDatePicker.h"
#import "FDTakeController.h"
#import "AddEventViewController.h"
#import <QuartzCore/QuartzCore.h> // Maybe needed for borders

@interface AddEventViewController () <UITextViewDelegate, FDTakeDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *innerViewHeight;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;

@property (retain) IBOutletCollection(UIView) NSArray *views;
@property (retain) IBOutletCollection(NSLayoutConstraint) NSArray *heights;
@property NSInteger firstFreeViewIndex;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (nonatomic, weak) IBOutlet UIView *accessoryView;
@property NSMutableArray *accessoryButtons;
@property NSArray *accessoryButtonSymbols;

@property FDTakeController *takeController;

@property BOOL accessoryViewEnabledFlag;
@property BOOL accessoryViewEnabledSubFlag;

@end

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


- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (UIView *)inputAccessoryView {
    NSLog(@"NEEDED ACCESSORY VIEW");
    if (self.accessoryViewEnabledFlag) return self.accessoryView;
    else return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
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
    
    // observe keyboard hide and show notifications to resize the text view appropriately
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

-(void)timeWasSelected:(NSDate *)selectedTime element:(id)element {
    UIButton *timeButton = self.accessoryButtons[2];
    [timeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm zzz"];
    NSString *stringFromDate = [formatter stringFromDate:selectedTime];
    
    UIView *viewToLoad = self.views[0]; // First view for the time
    NSLayoutConstraint *viewToLoadHeight = self.heights[0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_PADDING,
                                                               VIEW_PADDING,
                                                               viewToLoad.frame.size.width - 2 * VIEW_PADDING,
                                                               NORMAL_VIEW_HEIGHT - 2 * VIEW_PADDING)];
    [label setText:stringFromDate];
    
    [[viewToLoad subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [viewToLoad addSubview:label];
    
    if (viewToLoadHeight.constant == 0) {
        self.firstFreeViewIndex++;
        viewToLoadHeight.constant = NORMAL_VIEW_HEIGHT; // Show current view
        viewToLoad.layer.borderWidth = 2.0f;
        viewToLoad.layer.borderColor = [[UIColor redColor] CGColor];
    }
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
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
    
    [self.accessoryButtons[2] addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.accessoryButtons[3] addTarget:self action:@selector(showPhotoPicker) forControlEvents:UIControlEventTouchUpInside];
    
    for (NSInteger i = 0; i < self.accessoryButtons.count; i++) {
        [self.accessoryView addSubview:self.accessoryButtons[i]];
    }
}

- (void)showDatePicker {
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Выберите время"
                                                                      datePickerMode:UIDatePickerModeTime
                                                                        selectedDate:[NSDate date]
                                                                              target:self
                                                                              action:@selector(timeWasSelected:element:)
                                                                              origin:self.view];
    datePicker.minuteInterval = DATEPICKER_MINUTE_INTERVAL;
    [datePicker showActionSheetPicker];
}

- (void)showPhotoPicker {
    [self.takeController takePhotoOrChooseFromLibrary];
    self.accessoryViewEnabledSubFlag = NO;
}

// FDTakeDelegate method
- (void)takeController:(FDTakeController *)controller didCancelAfterAttempting:(BOOL)madeAttempt {
    self.accessoryViewEnabledSubFlag = YES;
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
