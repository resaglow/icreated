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
#import "EventUpdater.h"

@protocol MapDataSourceDelegate <NSObject>
@end


@class CustomMapView;

@interface MapDataSource : NSObject <MKMapViewDelegate, SMCalloutViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) CustomMapView *mapView;
@property (nonatomic, retain) EventAnnotation *customAnnotation;
@property (nonatomic, strong) SMCalloutView *calloutView;
@property (nonatomic, strong) UITextView *calloutTextView;
@property (nonatomic, strong) UILabel *calloutTimeText;
@property (nonatomic, strong) UILabel *calloutPeopleCount;
@property NSTimer *timer;
@property UIViewController <MapDataSourceDelegate> *delegate;
- (void)refreshMap;
- (void)startTimer;
- (void)stopTimer;
- (id)initWithMapView:(MKMapView *)map;
@end


@interface CustomMapView : MKMapView
@property (nonatomic, strong) SMCalloutView *calloutView;
@end


@interface MKMapView (UIGestureRecognizer)
// this tells the compiler that MKMapView actually implements this method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
@end