//
//  MainViewController+Map.h
//  icreated
//
//  Created by Artem Lobanov on 29/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController (Map) <MapCalloutDataSourceDelegate>

- (void)initMap;

@end