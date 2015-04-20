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
    self.mapDataSource = [[MapDataSource alloc] initWithMapView:self.mapView calloutFlag:YES];
    UIButton *contentView = (UIButton *)self.mapDataSource.calloutView.contentView;
    [contentView addTarget:self action:@selector(pushDetailViewController) forControlEvents:UIControlEventTouchUpInside];
    self.mapDataSource.delegate = self;
    [self.view addSubview:self.mapView];
}

- (void)pushDetailViewController {
    [self performSegueWithIdentifier:@"detailScreenSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[EventDetailViewController class]]) {
        EventDetailViewController *detailVC = (EventDetailViewController *)segue.destinationViewController;
        detailVC.textViewText = self.curAnnotation.title;
    }
}

@end