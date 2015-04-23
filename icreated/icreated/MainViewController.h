//
//  MainViewController.h
//  icreated
//
//  Created by Artem Lobanov on 17/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapEventCalloutDataSource.h"
#import "TableRefreshDataSource.h"
#import "EventUpdater.h"
#import "UserUpdater.h"

@interface MainViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addEventButton;

@property (strong, nonatomic) IBOutlet UITableView *newsStand;
@property (nonatomic, strong) TableRefreshDataSource *newsStandDataSource;

@property (strong, nonatomic) CalloutMapView *mapView;
@property (strong, nonatomic) MapEventCalloutDataSource *mapCalloutDataSource;
@property (strong, nonatomic) EventAnnotation *curAnnotation;

@property (strong, nonatomic) EventUpdater *eventUpdater;

@end

