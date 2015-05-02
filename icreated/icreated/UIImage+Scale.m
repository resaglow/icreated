//
//  UIImage+Scale.m
//  icreated
//
//  Created by Artem Lobanov on 02/05/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)

- (UIImage *)scaleToWidth:(CGFloat)width
{
    UIImage *scaledImage = self;
    if (self.size.width != width) {
        CGFloat height = floorf(self.size.height * width / self.size.width);
        CGSize size = CGSizeMake(width, height);
        
        // Create an image context
        UIGraphicsBeginImageContext(size);
        
        // Draw the scaled image
        [self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
        
        // Create a new image from context
        scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // Pop the current context from the stack
        UIGraphicsEndImageContext();
    }
    // Return the new scaled image
    return scaledImage;
}

- (UIImage *)scaleToHeight:(CGFloat)height
{
    CGFloat width = floorf(self.size.width * height / self.size.height);
    return [self scaleToWidth:width];
}

@end
