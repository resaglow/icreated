//
//  AddEventViewController+DatePicker.m
//  icreated
//
//  Created by Artem Lobanov on 29/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "AddEventViewController+DatePicker.h"

@implementation AddEventViewController (DatePicker)

- (void)showDatePicker {
    self.datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Выберите время"
                                                    datePickerMode:UIDatePickerModeTime
                                                      selectedDate:[NSDate date]
                                                            target:self
                                                            action:@selector(timeWasSelected:element:)
                                                            origin:self.view];
    
    self.datePicker.minuteInterval = DATEPICKER_MINUTE_INTERVAL;
    [self.datePicker showActionSheetPicker];
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
        viewToLoad.layer.borderWidth = 2.0f;
        viewToLoad.layer.borderColor = [[UIColor redColor] CGColor];
        viewToLoad.layer.cornerRadius = 5.0f;
        viewToLoadHeight.constant = NORMAL_VIEW_HEIGHT; // Show current view
    }
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

@end
