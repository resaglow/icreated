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
    
//    NSTimer* timer = [NSTimer timerWithTimeInterval:10.0 target:self selector:@selector(refreshMap) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    [self refreshMap];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[EventAnnotation class]]) {
        return nil; // To use standard annotation view
        // For example, for user location annotation
    }
    else {
        NSString *identifier = @"eventAnnotation";
        MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:identifier];
        }
        else {
            annotationView.annotation = annotation;
        }
        
        annotationView.canShowCallout = YES;
        annotationView.image = [self eventPinWithSize:CGSizeMake(38, 38)];
        
        return annotationView;
    }
}

- (UIImage *)eventPinWithSize:(CGSize)size {
    NSString *pinSymbol = @"\uf0a7";
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

- (void)refreshMap {
    NSLog(@"Refreshing map");
    
    [EventUpdater getEventsWithCompletionHandler:^(void) {
        NSMutableArray *updatedEvents = [EventUpdater updatedEventsArray];
        
        for (NSInteger i = 0; i < updatedEvents.count; i++) {
            NSDictionary *eventDict = [updatedEvents objectAtIndex:i];
            
            EventAnnotation *curAnnotation = [[EventAnnotation alloc] init];
            
            CLLocationCoordinate2D curCoordinate;
            curCoordinate.latitude = [NSDecimalNumber decimalNumberWithString:
                                      [eventDict objectForKey:@"Latitude"]].doubleValue;
            curCoordinate.longitude = [NSDecimalNumber decimalNumberWithString:
                                       [eventDict objectForKey:@"Longitude"]].doubleValue;
            
            if (!(curCoordinate.latitude > -90 && curCoordinate.latitude < 90 &&
                  curCoordinate.longitude > -180 && curCoordinate.longitude < 180)) {
                NSLog(@"BUG: Coordinates out of the range, setting standard values");
                
                curCoordinate.longitude = 0;
                curCoordinate.latitude = 0;
            }
            else {
                NSLog(@"Good coordinates");
                NSLog(@"Latitude = %f", curCoordinate.latitude);
                NSLog(@"Longitude = %f", curCoordinate.longitude);
            }
            
            curAnnotation.coordinate = curCoordinate;
            curAnnotation.title = [eventDict objectForKey:@"Description"];
            curAnnotation.subtitle = [eventDict objectForKey:@"EventDate"];
            
            
            [self.mapView addAnnotation:curAnnotation];
            [self.curAnnotationArray addObject:curAnnotation];
        }
    }];
}




@end







