//
//  MapEventDataSource.h
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
#import "Event.h"

@class CalloutMapView;

@interface MapEventDataSource : NSObject <MKMapViewDelegate, SMCalloutViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property NSTimer *timer;
@property UIViewController *delegate;
@property EventUpdater *eventUpdater;
- (void)refreshMap;
- (void)startTimer;
- (void)stopTimer;
- (id)initWithMapView:(MKMapView *)mapView;
@end