//
//  MapEventDataSource.m
//  icreated
//
//  Created by Artem Lobanov on 19/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#define kMapRefreshInterval 10.0

#import "MapEventDataSource.h"

@implementation MapEventDataSource

- (id)initWithMapView:(MKMapView *)mapView {
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

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    for (aV in views) {
        // Don't pin drop if annotation is user location
        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        // Check if current annotation is inside visible map rect, else go to next one
        MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }
        
        CGRect endFrame = aV.frame;
        
        // Move annotation out of view
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - self.delegate.view.frame.size.height, aV.frame.size.width, aV.frame.size.height);
        
        // Animate drop
        [UIView animateWithDuration:0.5 delay:0.04 * [views indexOfObject:aV] options:UIViewAnimationOptionCurveLinear animations:^{
            aV.frame = endFrame;
            // Animate squash
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    aV.transform = CGAffineTransformMake(1.0, 0, 0, 0.8, 0, aV.frame.size.height * 0.1);
                    
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                        aV.transform = CGAffineTransformIdentity;
                    }];
                }];
            }
        }];
    }
}

- (void)refreshMap {
    NSLog(@"Request to refresh map");
    [self.eventUpdater getEventsWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//        NSLog(@"Refreshing map");
        NSError *err = nil;
        if (err) {
            NSLog(@"Error fetching events to refresh a map");
        }

        NSArray *events = mappingResult.array;
        for (NSInteger i = 0; i < events.count; i++) {
            NSIndexPath *indexPath = [[NSIndexPath alloc] init];
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            Event *curEvent = events[i];
            
            EventAnnotation *curAnnotation = [[EventAnnotation alloc] init];
            
            BOOL oldAnnot = NO;
            for (id elem in self.mapView.annotations) {
                if ([elem isKindOfClass:[MKUserLocation class]]) continue;
                EventAnnotation *annotation = (EventAnnotation *)elem;
                if (annotation.eventId == curEvent.eventId) {
                    oldAnnot = YES;
                    break;
                }
            }
            if (oldAnnot) continue;
            
            curAnnotation.eventId = curEvent.eventId;
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
        
//    NSLog(@"Map refresh done");
    } failure:^void(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error getting events for map: %@", error);
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
