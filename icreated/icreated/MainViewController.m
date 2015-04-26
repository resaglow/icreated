//
//  MainViewController.m
//  icreated
//
//  Created by Artem Lobanov on 17/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "MainViewController.h"
#import "MainViewController+Map.h"
#import "MainViewController+NewsStand.h"
#import "SWRevealViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@end


@implementation MainViewController

- (void)setAddEventButtonVisibily:(BOOL)visibily {
    NSMutableArray *rightBarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
    
    if (visibily) {
        if (![rightBarButtons containsObject:self.addEventButton]) {
            [rightBarButtons addObject:self.addEventButton];
            [self.navigationItem setRightBarButtonItems:rightBarButtons animated:YES];
        }
    }
    else {
        [rightBarButtons removeObject:self.addEventButton];
        [self.navigationItem setRightBarButtonItems:rightBarButtons animated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initButtons];
    self.eventUpdater = [[EventUpdater alloc] init];
    [self initNewsStand];
    [self initMap];
    
    self.mapView.hidden = YES;
}

- (void)initButtons {
    self.menuButton.title = kFAMenu;
    [self.menuButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIFont fontWithName:@"FontAwesome" size:kFABarButtonFontSize], NSFontAttributeName, nil]
                                   forState:UIControlStateNormal];
    
    self.menuButton.target = self.revealViewController;
    self.menuButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.addEventButton.title = kFAAddEvent;
    [self.addEventButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIFont fontWithName:@"FontAwesome" size:kFABarButtonFontSize], NSFontAttributeName, nil]
                                       forState:UIControlStateNormal];
    
    [self setAddEventButtonVisibily:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
}

- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self.view bringSubviewToFront:self.newsStand];
        self.mapView.hidden = YES;
        [self.mapCalloutDataSource stopTimer];
    }
    else if (sender.selectedSegmentIndex == 1) {
        self.mapView.hidden = NO;
        [self.view bringSubviewToFront:self.mapView];
        [self.mapCalloutDataSource startTimer];
        [self.mapCalloutDataSource refreshMap];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end