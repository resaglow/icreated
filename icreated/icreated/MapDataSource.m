//
//  MapDataSource.m
//  icreated
//
//  Created by Artem Lobanov on 19/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#define kMapRefreshInterval 10.0

// Callout configs
#define kCalloutStandardInfoWidth 60
#define kCalloutStandardInfoHeight 20
#define kCalloutStandardIconSide 20

#define kCalloutTextHeight 60

#define kCalloutWidth 180
#define kCalloutHeight 80

#import "MapDataSource.h"
#import "NSDate+RFC1123.h"

@implementation MapDataSource

- (id)initWithMapView:(CustomMapView *)mapView calloutFlag:(BOOL)calloutFlag {
    self.calloutsFlag = calloutFlag;
    self.mapView = mapView;
    [self.mapView setDelegate:self];
    
    if (calloutFlag) {
        [self initCalloutView];
        self.mapView.calloutView = self.calloutView;
    }
    
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

- (void)initCalloutView {
    self.calloutView = [SMCalloutView platformCalloutView];
    self.calloutView.delegate = self;
    
    UIFont *fontAwesome = [UIFont fontWithName:@"FontAwesome" size:kFAStandardFontSize];
    UIFont *smallFont = [UIFont systemFontOfSize:kFASmallFontSize];
    
    
    UILabel *category = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCalloutStandardIconSide, kCalloutStandardIconSide)];
    
    UIButton *people = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    people.frame = CGRectMake(kCalloutStandardIconSide, 0, kCalloutStandardInfoWidth + kCalloutStandardIconSide, kCalloutStandardIconSide);
    self.calloutPeopleCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCalloutStandardInfoWidth, kCalloutStandardInfoHeight)];
    self.calloutPeopleCount.font = smallFont;
    UILabel *peopleIcon = [[UILabel alloc] initWithFrame:CGRectMake(kCalloutStandardInfoWidth, 0, kCalloutStandardIconSide, kCalloutStandardIconSide)];
    peopleIcon.font = fontAwesome;
    peopleIcon.text = kFAPeople;
    [people addSubview:self.calloutPeopleCount];
    [people addSubview:peopleIcon];
    
    UIButton *time = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    time.frame = CGRectMake(2 * kCalloutStandardIconSide + kCalloutStandardInfoWidth, 0, kCalloutStandardInfoWidth + kCalloutStandardIconSide, kCalloutStandardIconSide);
    self.calloutTimeText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCalloutStandardInfoWidth, kCalloutStandardInfoHeight)];
    self.calloutTimeText.font = smallFont;
    UILabel *timeIcon = [[UILabel alloc] initWithFrame:CGRectMake(kCalloutStandardInfoWidth, 0, kCalloutStandardIconSide, kCalloutStandardIconSide)];
    timeIcon.font = fontAwesome;
    timeIcon.text = kFATime;
    [time addSubview:self.calloutTimeText];
    [time addSubview:timeIcon];
    
    UIButton *higherView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    higherView.frame = CGRectMake(0, 0, kCalloutWidth, kCalloutStandardInfoHeight);
    [higherView addSubview:category];
    [higherView addSubview:people];
    [higherView addSubview:time];
    
    self.calloutTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, kCalloutStandardInfoHeight, kCalloutWidth, kCalloutTextHeight)];
    self.calloutTextView.backgroundColor = [UIColor clearColor];
    self.calloutTextView.editable = NO;
    
    UIView *contentView = [UIButton new];
    contentView.frame = CGRectMake(0, 0, kCalloutWidth, kCalloutHeight);
    [contentView addSubview:self.calloutTextView];
    [contentView addSubview:higherView];
    
    self.calloutView.contentView = contentView;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if (self.calloutsFlag) {
        EventAnnotation *annotation = (EventAnnotation *)view.annotation;
        self.calloutTextView.text = annotation.title;
        self.calloutTimeText.text = [annotation.date RFC1123String];
        
        CGFloat fixedWidth = self.calloutTextView.frame.size.width;
        CGSize newSize = [self.calloutTextView sizeThatFits:CGSizeMake(fixedWidth, CGFLOAT_MAX)];
        
        CGRect newFrame = self.calloutTextView.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        
        if (newFrame.size.height <= 80.0f) {
            CGFloat textViewsHeightDiff = self.calloutTextView.frame.size.height - newFrame.size.height;
            self.calloutTextView.frame = newFrame;
            self.calloutView.contentView.frame = CGRectMake(0,
                                                            0,
                                                            self.calloutView.contentView.frame.size.width,
                                                            self.calloutView.contentView.frame.size.height - textViewsHeightDiff);
        }
        
        self.calloutView.calloutOffset = view.calloutOffset;
        
        [self.calloutView presentCalloutFromRect:view.bounds inView:view constrainedToView:self.delegate.view animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (self.calloutsFlag) {
        [self.calloutView dismissCalloutAnimated:YES];
    }
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
        NSLog(@"%@", [touch.view class]);
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
