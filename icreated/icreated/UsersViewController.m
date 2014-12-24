//
//  UsersViewController.m
//  icreated
//
//  Created by Artem Lobanov on 18/12/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "UsersViewController.h"
#import "ProfileViewController.h"
#import "SWRevealViewController.h"
#import "UserUpdater.h"

@interface UsersViewController () {
    UserType userType;
}

@property UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *UsersStand;

@end

@implementation UsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userType = UserTypeFriends;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Default property value is always 0/nil in Obj-C,
    // so if parent view controller didn't specify it, init should be sended
    // otherwise shouldn't.
    if (!self.menuFlag) {
        [self initMenu];
    }
    
    [self initSegmentedControl];
}


- (void)initMenu {
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"\uf0c9";
    [barButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"FontAwesome" size:26.0], NSFontAttributeName, nil]
                             forState:UIControlStateNormal];
    barButton.tintColor = [UIColor whiteColor];
    barButton.target = self.revealViewController;
    barButton.action = @selector(revealToggle:);
    self.navigationItem.leftBarButtonItem = barButton;
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)initSegmentedControl {
    self.segmentedControl = [[UISegmentedControl alloc]
                             initWithItems:@[@"Friends", @"Following", @"Followers"]];
    self.segmentedControl.frame = CGRectMake(0, 0, 240, 31);
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self
                              action:@selector(segmentChanged:)
                    forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentedControl;
}

- (void)segmentChanged:(UISegmentedControl *)sender {
    userType = self.segmentedControl.selectedSegmentIndex;
    [self.UsersStand reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [UserUpdater getUserInfoWithCompletionhandler:nil];
    [UserUpdater getUsersOfType:UserTypeFriends byUserId:0 completionhandler:nil];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    switch (userType) {
    //        case 0:
    //            return [;
    //        case 1:
    //            return
    //    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"userCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[ProfileViewController class]]) {
        ProfileViewController *profileVC = (ProfileViewController *)(segue.destinationViewController);
        profileVC.menuFlag = TRUE;
    }
}

@end
