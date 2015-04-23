//
//  MapEventCalloutDataSource.h
//  icreated
//
//  Created by Artem Lobanov on 20/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import "MapEventDataSource.h"

@protocol MapEventCalloutDataSourceDelegate <NSObject>
@property (nonatomic, strong) EventAnnotation *curAnnotation;
@end


@interface MapEventCalloutDataSource : MapEventDataSource

@property (nonatomic, strong) CalloutMapView *calloutMapView;
@property (nonatomic, strong) SMCalloutView *calloutView;
@property (nonatomic, strong) UITextView *calloutTextView;
@property (nonatomic, strong) UILabel *calloutTimeText;
@property (nonatomic, strong) UILabel *calloutPeopleCount;
@property UIViewController<MapEventCalloutDataSourceDelegate> *delegate;
- (id)initWithMapView:(CalloutMapView *)mapView;

@end

@interface CalloutMapView : MKMapView
@property (nonatomic, strong) SMCalloutView *calloutView;
@end


@interface MKMapView (UIGestureRecognizer)
// this tells the compiler that MKMapView actually implements this method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
@end