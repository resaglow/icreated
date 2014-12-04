//
//  PinPickerViewController.h
//  icreated
//
//  Created by Artem Lobanov on 28/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "EventAnnotation.h"

@protocol sendDataProtocol <NSObject>

-(void)getData:(EventAnnotation *)annotation;

@end

@interface PinPickerViewController : UIViewController

@property(nonatomic,assign) id delegate;

@end
