//
//  UIImage+Scale.h
//  icreated
//
//  Created by Artem Lobanov on 02/05/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

- (UIImage *)scaleToWidth:(CGFloat)width;
- (UIImage *)scaleToHeight:(CGFloat)height;

@end
