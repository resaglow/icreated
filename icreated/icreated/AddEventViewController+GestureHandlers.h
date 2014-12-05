//
//  AddEventViewController+GestureHandlers.h
//  icreated
//
//  Created by Artem Lobanov on 05/12/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "AddEventViewController.h"

@interface AddEventViewController (GestureHandlers)

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position;
- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position;
- (void)revealControllerPanGestureEnded:(SWRevealViewController *)revealController;
- (BOOL)revealControllerPanGestureShouldBegin:(SWRevealViewController *)revealController;
- (void)handleSwipe:(UISwipeGestureRecognizer *)sender;
- (void)initSwipes;

@end
