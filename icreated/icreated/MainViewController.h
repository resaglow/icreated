//
//  MainViewController.h
//  icreated
//
//  Created by Artem Lobanov on 17/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SMCalloutView.h"
#import "EventAnnotation.h"
#import "EventUpdater.h"

@interface CustomMapView : MKMapView
@property (nonatomic, strong) SMCalloutView *calloutView;
@end

@interface MainViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addEventButton;

@property (strong, nonatomic) IBOutlet UITableView *newsStand;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) CustomMapView *map;
@property (nonatomic, retain) EventAnnotation *customAnnotation;
@property (nonatomic, strong) SMCalloutView *calloutView;
@property (nonatomic, strong) UITextView *calloutTextView;
@property (nonatomic, strong) UILabel *calloutTimeText;
@property (nonatomic, strong) UILabel *calloutPeopleCount;

@property NSTimer *timer;

@end

