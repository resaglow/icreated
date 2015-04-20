//
//  MapDataSource.h
//  icreated
//
//  Created by Artem Lobanov on 19/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SMCalloutView.h"
#import "EventAnnotation.h"
#import "EventDetailViewController.h"
#import "EventUpdater.h"

@class CustomMapView;

@interface MapDataSource : NSObject <MKMapViewDelegate, SMCalloutViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) CustomMapView *mapView;
@property NSTimer *timer;
@property UIViewController *delegate;
- (void)refreshMap;
- (void)startTimer;
- (void)stopTimer;
- (id)initWithMapView:(MKMapView *)mapView;
@end


@interface CustomMapView : MKMapView
@property (nonatomic, strong) SMCalloutView *calloutView;
@end


@interface MKMapView (UIGestureRecognizer)
// this tells the compiler that MKMapView actually implements this method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
@end