//
//  PinPickerViewController.m
//  icreated
//
//  Created by Artem Lobanov on 28/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#define kMinimumPressDuration 0.2

#import "PinPickerViewController.h"
#import "MapDataSource.h"


@interface PinPickerViewController () <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *map;
@property (strong, nonatomic) MapDataSource *dataSource;

@property EventAnnotation *curAnnotation;
@property UIBarButtonItem *rightBarButton;

@end


@implementation PinPickerViewController

- (void)viewDidLoad {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.leftBarButtonItem.title = @"Cancel";
    self.navigationItem.leftBarButtonItem.target = self;
    self.navigationItem.leftBarButtonItem.action = @selector(dismiss);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.rightBarButtonItem.title = kFAOK;
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(sendAnnotation);
    self.rightBarButton = self.navigationItem.rightBarButtonItem;
    
    NSMutableArray *rightBarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
    [rightBarButtons removeObject:self.rightBarButton];
    [self.navigationItem setRightBarButtonItems:rightBarButtons animated:NO];
    
    self.map = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [self.map setShowsUserLocation:YES];
    self.dataSource = [[MapDataSource alloc] initWithMapView:self.map calloutFlag:NO];
    [self.view addSubview:self.map];
    
    UILongPressGestureRecognizer *dropPin = [[UILongPressGestureRecognizer alloc] init];
    [dropPin addTarget:self action:@selector(handleLongPress:)];
    dropPin.minimumPressDuration = kMinimumPressDuration;
    [self.map addGestureRecognizer:dropPin];
}


- (double)distanceBetween:(CLLocationCoordinate2D)from and:(CLLocationCoordinate2D)to  {
    CLLocation *userloc = [[CLLocation alloc] initWithLatitude:from.latitude longitude:from.longitude];
    CLLocation *dest = [[CLLocation alloc] initWithLatitude:to.latitude longitude:to.longitude];
    
    return [userloc distanceFromLocation:dest];
}


- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.map];
    CLLocationCoordinate2D curCoordinate = [self.map convertPoint:touchPoint toCoordinateFromView:self.map];
    if ([self distanceBetween:curCoordinate and:self.curAnnotation.coordinate] < 100) {
        [self.map removeAnnotation:self.curAnnotation];
        NSMutableArray *rightBarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
        [rightBarButtons removeObject:self.rightBarButton];
        [self.navigationItem setRightBarButtonItems:rightBarButtons animated:NO];
        return;
    }
    
    NSMutableArray *rightBarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
    if (![rightBarButtons containsObject:self.rightBarButton]) {
        [rightBarButtons addObject:self.rightBarButton];
        [self.navigationItem setRightBarButtonItems:rightBarButtons animated:YES];
    }
    
    if (self.curAnnotation) {
        [self.map removeAnnotation:self.curAnnotation];
    }
    
    EventAnnotation *annotation = [[EventAnnotation alloc] init];
    annotation.coordinate = curCoordinate;
    
    self.curAnnotation = annotation;
    
    [self.map addAnnotation:annotation];
}

- (void)sendAnnotation {
    [self.delegate getData:self.curAnnotation];
    [self dismiss];
}

- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
