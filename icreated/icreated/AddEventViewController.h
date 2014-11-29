//
//  AddEventViewController.h
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

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "ActionSheetDatePicker.h"
#import "FDTakeController.h"
#import "AddPinViewController.h"

@interface AddEventViewController : UIViewController <UITextViewDelegate, FDTakeDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *innerViewHeight;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;

@property (retain) IBOutletCollection(UIView) NSArray *views;
@property (retain) IBOutletCollection(NSLayoutConstraint) NSArray *heights;
@property NSInteger firstFreeViewIndex;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property BOOL accessoryViewEnabledFlag;
@property BOOL accessoryViewEnabledSubFlag;

@property (nonatomic, weak) IBOutlet UIView *accessoryView;
@property NSMutableArray *accessoryButtons;
@property NSArray *accessoryButtonSymbols;

@property PinPickerViewController *pinPickerViewController;
@property ActionSheetDatePicker *datePicker;
@property FDTakeController *takeController;

@end
