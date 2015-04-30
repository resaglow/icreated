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
                                                    datePickerMode:UIDatePickerModeDateAndTime
                                                      selectedDate:[NSDate date]
                                                            target:self
                                                            action:@selector(timeWasSelected:element:)
                                                            origin:self.view];
    
    self.datePicker.minuteInterval = DATEPICKER_MINUTE_INTERVAL;
    self.datePicker.minimumDate = [NSDate date];
    [self.datePicker showActionSheetPicker];
}

- (void)timeWasSelected:(NSDate *)selectedTime element:(id)element {
    self.eventDate = selectedTime;
    
    UIButton *timeButton = self.accessoryButtons[DetailItemIndexTime];
    [timeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    NSString *stringFromDate = [[SORelativeDateTransformer registeredTransformer] transformedValue:selectedTime];
    
    UIView *viewToLoad = self.views[DetailItemIndexTime]; // First view for the time
    NSLayoutConstraint *viewToLoadHeight = self.heights[DetailItemIndexTime];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_PADDING,
                                                               VIEW_PADDING,
                                                               viewToLoad.frame.size.width - 2 * VIEW_PADDING,
                                                               NORMAL_VIEW_HEIGHT - 2 * VIEW_PADDING)];
    [label setText:stringFromDate];
    [label setTextColor:[UIColor redColor]];
    [label setFont:[UIFont systemFontOfSize:kFontSizeBigger]];
    
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
