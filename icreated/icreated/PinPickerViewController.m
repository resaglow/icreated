//
//  PinPickerViewController.m
//  icreated
//
//  Created by Artem Lobanov on 28/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "PinPickerViewController.h"

@interface PinPickerViewController () <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *map;
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
    self.navigationItem.rightBarButtonItem.title = @"\uf045";
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(sendAnnotation);
    self.rightBarButton = self.navigationItem.rightBarButtonItem;
    
    NSMutableArray *rightBarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
    [rightBarButtons removeObject:self.rightBarButton];
    [self.navigationItem setRightBarButtonItems:rightBarButtons animated:NO];
    
    self.map = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [self.map setDelegate:self];
    [self.map setShowsUserLocation:YES];
    [self.view addSubview:self.map];
    
    UILongPressGestureRecognizer *dropPin = [[UILongPressGestureRecognizer alloc] init];
    [dropPin addTarget:self action:@selector(handleLongPress:)];
    dropPin.minimumPressDuration = 0.2;
    [self.map addGestureRecognizer:dropPin];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    
    NSMutableArray *rightBarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
    if (![rightBarButtons containsObject:self.rightBarButton]) {
        [rightBarButtons addObject:self.rightBarButton];
        [self.navigationItem setRightBarButtonItems:rightBarButtons animated:YES];
    }
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    if (self.curAnnotation) {
        [self.map removeAnnotation:self.curAnnotation];
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.map];
    CLLocationCoordinate2D curCoordinate = [self.map convertPoint:touchPoint toCoordinateFromView:self.map];
    
    EventAnnotation *annotation = [[EventAnnotation alloc] init];
    annotation.coordinate = curCoordinate;
    
    self.curAnnotation = annotation;
    
    [self.map addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[EventAnnotation class]]) {
        NSString *identifier = @"eventAnnotation";
        MKPinAnnotationView* annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:identifier];
        }
        else {
            annotationView.annotation = annotation;
        }
        
        annotationView.image = [self eventPinWithSize:CGSizeMake(38, 38)];
        
        return annotationView;
    }
    
    return nil;
}

- (UIImage *)eventPinWithSize:(CGSize)size {
    NSString *pinSymbol = @"\uf041";
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [pinSymbol drawInRect:CGRectMake(0, 0, size.width, size.height)
           withAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],
                            NSFontAttributeName:[UIFont fontWithName:@"FontAwesome"
                                                                size:size.height]}];
    // It's supposed that height == width
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)sendAnnotation {
    [self.delegate getData:self.curAnnotation];
    [self dismiss];
}

- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
