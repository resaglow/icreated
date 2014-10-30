//
//  ViewController.m
//  icreated
//
//  Created by Artem Lobanov on 17/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) UIViewController *currentViewController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addEventButton;

@end


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuButton.target = self.revealViewController;
    self.menuButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    UIViewController *vc = [self viewControllerForSegmentIndex:self.typeSegmentedControl.selectedSegmentIndex];
    [self addChildViewController:vc];
    vc.view.frame = self.contentView.bounds;
    [self.contentView addSubview:vc.view];
    self.currentViewController = vc;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\uf044"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:nil];
    
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIFont fontWithName:@"FontAwesome" size:26.0], NSFontAttributeName,
                                                                      nil]
                                       forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem.title = @"\uf0c9";
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(20, 0, -20, 0)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [UIFont fontWithName:@"FontAwesome" size:26.0], NSFontAttributeName,
                                                                    nil]
                                                          forState:UIControlStateNormal];
}


- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    UIViewController *vc = [self viewControllerForSegmentIndex:sender.selectedSegmentIndex];
    [self addChildViewController:vc];
    
    [self transitionFromViewController:self.currentViewController
                      toViewController:vc
                              duration:0.5
                               options:0
                            animations:^{
                                [self.currentViewController.view removeFromSuperview];
                                vc.view.frame = self.contentView.bounds;
                                [self.contentView addSubview:vc.view];
                            }
                            completion:^(BOOL finished) {
                                [vc didMoveToParentViewController:self];
                                [self.currentViewController removeFromParentViewController];
                                self.currentViewController = vc;
                            }];
    
    self.navigationController.title = vc.title;
    
    self.navigationItem.title = vc.title;
}


- (UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
    UIViewController *vc;
    
    switch (index) {
        case 0:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsStandController"];
            break;
        case 1:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapController"];
            break;
    }
    
    return vc;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
