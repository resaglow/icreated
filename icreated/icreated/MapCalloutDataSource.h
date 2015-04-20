//
//  MapCalloutDataSource.h
//  icreated
//
//  Created by Artem Lobanov on 20/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import "MapDataSource.h"

@protocol MapCalloutDataSourceDelegate <NSObject>
@property (nonatomic, strong) EventAnnotation *curAnnotation;
@end


@interface MapCalloutDataSource : MapDataSource

@property (nonatomic, strong) SMCalloutView *calloutView;
@property (nonatomic, strong) UITextView *calloutTextView;
@property (nonatomic, strong) UILabel *calloutTimeText;
@property (nonatomic, strong) UILabel *calloutPeopleCount;
@property UIViewController<MapCalloutDataSourceDelegate> *delegate;
- (id)initWithMapView:(MKMapView *)mapView;

@end
