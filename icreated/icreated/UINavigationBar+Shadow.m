//
//  UINavigationBar+Shadow.m
//  icreated
//
//  Created by Artem Lobanov on 03/05/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import "UINavigationBar+Shadow.h"

@implementation UINavigationBar (Shadow)

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 1;
    self.layer.shadowOffset = CGSizeMake(0,2);
    CGRect shadowPath = CGRectMake(self.layer.bounds.origin.x - 10, self.layer.bounds.size.height - 6, self.layer.bounds.size.width + 20, 5);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowPath].CGPath;
    self.layer.shouldRasterize = YES;
    self.translucent = NO;
}

@end
