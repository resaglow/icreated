//
//  AddPinViewController.m
//  icreated
//
//  Created by Artem Lobanov on 28/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "AddPinViewController.h"

@interface AddPinViewController () <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *map;
@property CLLocationCoordinate2D curCoordinate;

@end


@implementation AddPinViewController

- (void)viewDidLoad {
    self.map = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [self.map setDelegate:self];
    [self.map setShowsUserLocation:YES];
    [self.view addSubview:self.map];
    
    UILongPressGestureRecognizer *dropPin = [[UILongPressGestureRecognizer alloc] init];
    [dropPin addTarget:self action:@selector(handleLongPress:)];
    dropPin.minimumPressDuration = 0.5;
    [self.map addGestureRecognizer:dropPin];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.map];
    self.curCoordinate = [self.map convertPoint:touchPoint toCoordinateFromView:self.map];
    
    EventAnnotation *annotation = [[EventAnnotation alloc] init];
    
    [self.map addAnnotation:annotation];
}

@end
