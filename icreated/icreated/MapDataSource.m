//
//  MapDataSource.m
//  icreated
//
//  Created by Artem Lobanov on 19/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#define kMapRefreshInterval 10.0

#import "MapDataSource.h"

@implementation MapDataSource

- (id)initWithMapView:(CustomMapView *)mapView {
    self.mapView = mapView;
    [self.mapView setDelegate:self];
    
    self.timer = [NSTimer timerWithTimeInterval:kMapRefreshInterval
                                         target:self
                                       selector:@selector(refreshMap)
                                       userInfo:nil
                                        repeats:YES];
    
    [self refreshMap];
    
    return self;
}

- (void)startTimer {
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [self.timer invalidate];
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
        
        annotationView.image = [self eventPinWithSize:CGSizeMake(kFAPinSide, kFAPinSide)];
        
        return annotationView;
    }
    
    return nil;
}

- (UIImage *)eventPinWithSize:(CGSize)size {
    NSString *pinSymbol = kFAPin;
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
    NSLog(@"Request to refresh map");
    [EventUpdater getEventsWithCompletionHandler:^(void) {
        //        NSLog(@"Refreshing map");
        [[EventUpdater fetchedResultsController] performFetch:nil];
        
        for (NSInteger i = 0; i < [[[[EventUpdater fetchedResultsController] sections] objectAtIndex:0] numberOfObjects]; i++) {
            NSIndexPath *indexPath = [[NSIndexPath alloc] init];
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            Event *curEvent = [[EventUpdater fetchedResultsController] objectAtIndexPath:indexPath];
            
            EventAnnotation *curAnnotation = [[EventAnnotation alloc] init];
            
            curAnnotation.title = curEvent.desc;
            curAnnotation.date = curEvent.date;
            
            //            NSLog(@"%@, %@, %@", curEvent.desc, curEvent.date, curEvent.latitude);
            
            CLLocationCoordinate2D curCoordinate;
            curCoordinate.latitude = curEvent.latitude.doubleValue;
            curCoordinate.longitude = curEvent.longitude.doubleValue;
            curAnnotation.coordinate = curCoordinate;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mapView addAnnotation:curAnnotation];
            });
        }
        
        //        NSLog(@"Map refresh done");
    }];
}


#pragma mark - SMCalloutView delegate methods

- (NSTimeInterval)calloutView:(SMCalloutView *)calloutView delayForRepositionWithSize:(CGSize)offset {
    
    // When the callout is being asked to present in a way where it or its target will be partially offscreen, it asks us
    // if we'd like to reposition our surface first so the callout is completely visible. Here we scroll the map into view,
    // but it takes some math because we have to deal in lon/lat instead of the given offset in pixels.
    
    CLLocationCoordinate2D coordinate = self.mapView.centerCoordinate;
    
    // where's the center coordinate in terms of our view?
    CGPoint center = [self.mapView convertCoordinate:coordinate toPointToView:self.delegate.view];
    
    // move it by the requested offset
    center.x -= offset.width;
    center.y -= offset.height;
    
    // and translate it back into map coordinates
    coordinate = [self.mapView convertPoint:center toCoordinateFromView:self.delegate.view];
    
    // move the map!
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
    // tell the callout to wait for a while while we scroll (we assume the scroll delay for MKMapView matches UIScrollView)
    return kSMCalloutViewRepositionDelayForUIScrollView;
}

@end

#pragma mark - CustomMapView

@implementation CustomMapView

// override UIGestureRecognizer's delegate method so we can prevent MKMapView's recognizer from firing
// when we interact with UIControl subclasses inside our callout view.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UITextView class]] ||
        [touch.view isKindOfClass:[UILabel class]]) {
        return NO;
    }
    else {
        return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
    }
}

// Allow touches to be sent to our calloutview.
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint ourPoint = [self.calloutView convertPoint:point fromView:self];
    UIView *calloutMaybe = [self.calloutView hitTest:ourPoint
                                           withEvent:event];
    if (calloutMaybe) return calloutMaybe;
    
    return [super hitTest:point withEvent:event];
}

@end
