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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuButton.title = @"\uf0c9";
    [self.menuButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIFont fontWithName:@"FontAwesome" size:26.0], NSFontAttributeName, nil]
                                                                              forState:UIControlStateNormal];
    
    self.menuButton.target = self.revealViewController;
    self.menuButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.addEventButton.title = @"\uf044";
    [self.addEventButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIFont fontWithName:@"FontAwesome" size:26.0], NSFontAttributeName, nil]
                                                                                  forState:UIControlStateNormal];
    
    [self viewDidLoadNewsStand];
    [self viewDidLoadMap];
    
    self.map.hidden = YES;
    
}

- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self.view bringSubviewToFront:self.newsStand];
    }
    else if (sender.selectedSegmentIndex == 1) {
        self.map.hidden = NO;
        [self.view bringSubviewToFront:self.map];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end