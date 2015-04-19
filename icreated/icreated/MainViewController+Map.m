//
//  MainViewController+Map.m
//  icreated
//
//  Created by Artem Lobanov on 29/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "MainViewController+Map.h"

@implementation MainViewController (Map)

- (void)viewDidLoadMap {
    self.mapView = [[CustomMapView alloc] initWithFrame:self.view.bounds];
    [self.mapView setShowsUserLocation:YES];
    self.mapDataSource = [[MapDataSource alloc] initWithMapView:self.mapView];
    self.mapDataSource.delegate = self;
    [self.view addSubview:self.mapView];
}

@end