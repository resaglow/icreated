//
//  AddEventViewController+GestureHandlers.m
//  icreated
//
//  Created by Artem Lobanov on 05/12/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "AddEventViewController+GestureHandlers.h"

@implementation AddEventViewController (GestureHandlers)

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position {
    if (position == FrontViewPositionRight) {
        [self resignFirstResponder];
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position {
    if (position == FrontViewPositionLeft) {
        [self becomeFirstResponder];
    }
    
    BOOL interaction = revealController.frontViewPosition == FrontViewPositionRight ? FALSE : TRUE;
    self.textView.userInteractionEnabled = interaction;
    self.accessoryView.userInteractionEnabled = interaction;
    self.photosView.userInteractionEnabled = interaction;
    for (UIView *subView in self.view.subviews) {
        subView.userInteractionEnabled = interaction;
    }
}

- (void)revealControllerPanGestureEnded:(SWRevealViewController *)revealController {
    if (revealController.frontViewPosition == FrontViewPositionLeft) {
        [self becomeFirstResponder];
    }
}

- (BOOL)revealControllerPanGestureShouldBegin:(SWRevealViewController *)revealController {
    UIPanGestureRecognizer *gestureRecognizer = revealController.panGestureRecognizer;
    
    CGFloat offset = 7; // Hack for correct recognizing while fastly dragging photosView
    CGPoint loc = [gestureRecognizer locationInView:self.photosView];
    CGPoint trans = [gestureRecognizer translationInView:self.photosView];
    CGPoint startPoint = CGPointMake(loc.x - trans.x, loc.y - trans.y + offset);
    
    if (CGRectContainsPoint(self.photosView.bounds, startPoint)) {
        //        NSLog(@"Touch in photos");
        return NO;
    }
    //    else {
    //        NSLog(@"%@, %@",
    //              NSStringFromCGRect(self.photosView.bounds),
    //              NSStringFromCGPoint([gestureRecognizer locationInView:self.photosView]));
    //    }
    
    UIView *recognizerView = gestureRecognizer.view;
    CGPoint translation = [gestureRecognizer translationInView:recognizerView];
    
    //    NSLog(@"Translation.x = %f", translation.x);
    
    if (translation.x <= 0 && revealController.frontViewPosition != FrontViewPositionRight) {
        return NO;
    }
    
    [self.textView resignFirstResponder];
    [self resignFirstResponder];
    
    return YES;
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        [self.textView becomeFirstResponder];
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        [self.textView resignFirstResponder];
    }
}

- (void)initSwipes {
    UISwipeGestureRecognizer *swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUpGestureRecognizer];
    
    UISwipeGestureRecognizer *swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownGestureRecognizer];
    
    UISwipeGestureRecognizer *swipeUpAccessoryGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeUpAccessoryGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.accessoryView addGestureRecognizer:swipeUpAccessoryGestureRecognizer];
    
    UISwipeGestureRecognizer *swipeDownAccessoryGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeDownAccessoryGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.accessoryView addGestureRecognizer:swipeDownAccessoryGestureRecognizer];
}


@end
