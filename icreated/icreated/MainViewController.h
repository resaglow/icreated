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

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
    MKAnnotationView *_selectedAnnotationView;
    EventAnnotation *_customAnnotation;
}


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addEventButton;

@property (nonatomic, retain) MKAnnotationView *selectedAnnotationView;

- (void)refreshMap;

@end

