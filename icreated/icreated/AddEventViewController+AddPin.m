//
//  AddEventViewController+AddPin.m
//  icreated
//
//  Created by Artem Lobanov on 29/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "AddEventViewController+AddPin.h"

@implementation AddEventViewController (AddPin)

- (void)pushAddPinViewController {
    self.addPinViewController = [[AddPinViewController alloc] init];
    
    [self.navigationController pushViewController:self.addPinViewController animated:YES];
}

@end
