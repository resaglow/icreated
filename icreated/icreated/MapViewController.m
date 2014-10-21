//
//  MapViewController.m
//  icreated
//
//  Created by Artem Lobanov on 17/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property NSMutableArray *curAnnotationArray;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mapView setShowsUserLocation:YES];
    
    NSTimer* timer = [NSTimer timerWithTimeInterval:15.0 target:self selector:@selector(refreshMap) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    [self refreshMap];
}

- (void)refreshMap {
    NSLog(@"Refreshing map");
    
    [EventUpdater getEventsWithCompletionHandler:^(void) {
        NSMutableArray *updatedEvents = [EventUpdater eventsArray];
        NSMutableArray *updatedAnnotations = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < updatedEvents.count; i++) {
            NSDictionary *eventDict = updatedEvents[i];
            
            EventAnnotation *curAnnotation = [[EventAnnotation alloc] init];
            
            CLLocationCoordinate2D curCoordinate;
            curCoordinate.latitude = [NSDecimalNumber decimalNumberWithString:
                                      [eventDict objectForKey:@"Latitude"]].doubleValue;
            curCoordinate.longitude = [NSDecimalNumber decimalNumberWithString:
                                       [eventDict objectForKey:@"Longitude"]].doubleValue;
            
            curAnnotation.coordinate = curCoordinate;
            curAnnotation.title = [eventDict objectForKey:@"Description"];
            curAnnotation.subtitle = [eventDict objectForKey:@"EventDate"];
            
            if ([self.curAnnotationArray indexOfObject:curAnnotation] != NSNotFound) {
                [self.mapView addAnnotation:curAnnotation];
            }
            [updatedAnnotations addObject:curAnnotation];
        }
        
        for (id annotation in self.curAnnotationArray) {
            NSUInteger annotationIndex = [updatedAnnotations indexOfObject:annotation];
            if (annotationIndex != NSNotFound) {
                [self.mapView removeAnnotation:annotation];
            }
        }
        
        self.curAnnotationArray = updatedAnnotations;
    }];
}




@end







