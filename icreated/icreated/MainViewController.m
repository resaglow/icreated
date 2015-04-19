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
    
    self.menuButton.title = @"\uf0c9";
    [self.menuButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIFont fontWithName:@"FontAwesome" size:30.0], NSFontAttributeName, nil]
                                                                              forState:UIControlStateNormal];
    
    self.menuButton.target = self.revealViewController;
    self.menuButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.addEventButton.title = @"\uf044";
    [self.addEventButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIFont fontWithName:@"FontAwesome" size:30.0], NSFontAttributeName, nil]
                                                                                  forState:UIControlStateNormal];
    
    [self setAddEventButtonVisibily:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginFlag"]];
    
    
    [self viewDidLoadNewsStand];
    [self viewDidLoadMap];
    
    self.mapView.hidden = YES;
}

- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self.mapDataSource stopTimer];
        [self.view bringSubviewToFront:self.newsStand];
    }
    else if (sender.selectedSegmentIndex == 1) {
        self.mapView.hidden = NO;
        [self.mapDataSource startTimer];
        [self.view bringSubviewToFront:self.mapView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end