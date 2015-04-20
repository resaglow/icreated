//
//  MainViewController.h
//  icreated
//
//  Created by Artem Lobanov on 17/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapCalloutDataSource.h"
#import "TableRefreshDataSource.h"

@interface MainViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addEventButton;

@property (strong, nonatomic) IBOutlet UITableView *newsStand;
@property (nonatomic, strong) TableRefreshDataSource *newsStandDataSource;

@property (strong, nonatomic) CustomMapView *mapView;
@property (strong, nonatomic) MapCalloutDataSource *mapCalloutDataSource;
@property (strong, nonatomic) EventAnnotation *curAnnotation;

@end

