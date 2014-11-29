//
//  AddEventViewController+PinPicker.m
//  icreated
//
//  Created by Artem Lobanov on 29/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "AddEventViewController+PinPicker.h"

@implementation AddEventViewController (PinPicker)

- (void)pushPinPickerViewController {
    self.pinPickerViewController = [[PinPickerViewController alloc] init];
    
    [self.navigationController pushViewController:self.pinPickerViewController animated:YES];
}

@end
