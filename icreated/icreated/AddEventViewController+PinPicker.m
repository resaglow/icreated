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
    [self.pinPickerViewController setDelegate:self];
    
    // This is where you wrap the view up nicely in a navigation controller
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:self.pinPickerViewController];
    
    // You can even set the style of stuff before you show it
//    navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    // And now you want to present the view in a modal fashion
    [self presentViewController:navigationController animated:YES completion:nil];
    
//    [self.navigationController presentViewController:self.pinPickerViewController animated:YES completion:nil];
    
}

- (void)getData:(EventAnnotation *)annotation {
    self.annotation = annotation;
}



@end
