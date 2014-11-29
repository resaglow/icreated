//
//  MainViewController+Map.h
//  icreated
//
//  Created by Artem Lobanov on 29/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController (Map) <MKMapViewDelegate, UIGestureRecognizerDelegate, SMCalloutViewDelegate>

- (void)viewDidLoadMap;

@end

@interface MKMapView (UIGestureRecognizer)

// this tells the compiler that MKMapView actually implements this method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

@end