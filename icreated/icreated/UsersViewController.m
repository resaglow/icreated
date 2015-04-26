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
#import "UIBarButtonItem+Menu.h"

@interface UsersViewController () {
    UserType userType;
}

@property UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *usersStand;
@property (nonatomic, strong) UserUpdater *userUpdater;
@property (nonatomic, strong) TableRefreshDataSource *userStandDataSource;
@end

@implementation UsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userType = UserTypeFriends;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back?"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil action:nil];
    // Default property value is always 0/nil in Obj-C (nil in this case),
    // so if parent view controller didn't specify it, init should be sended
    // otherwise shouldn't.
    if (!self.menuFlag) [UIBarButtonItem initMenuWithController:self];
    [self initSegmentedControl];
    
    self.userUpdater = [[UserUpdater alloc] init];
    self.userStandDataSource =
    [[TableRefreshDataSource alloc] initWithTableView:self.usersStand
                             fetchedResultsController:self.userUpdater.fetchedResultsController
                                       reuseIdenifier:@"userCell"];
    self.userStandDataSource.delegate = self;
}

- (void)configureCell:(UITableViewCell *)cell withObject:(id)object {
    User *user = (User *)object;
    cell.textLabel.text = user.userName;
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
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.destinationViewController isKindOfClass:[ProfileViewController class]]) {
//        ProfileViewController *profileVC = (ProfileViewController *)(segue.destinationViewController);
//        profileVC.menuFlag = TRUE;
//    }
//}

- (void)refreshingMethod:(void (^)(void))handler {
    [self.userUpdater getUsersOfType:UserTypeFriends byUserId:[[UserUpdater curUser].userId integerValue]
     // Было бы модно (UserTypeFriends)(self.segmentedControl.selectedSegmentIndex)
     WithSuccess:^void(RKObjectRequestOperation *operation,
                       RKMappingResult *mappingResult) {
         NSArray *users = mappingResult.array;
         for (id element in users) {
             User *user = (User *)element;
             if ([UserUpdater curUser]) {
                 [[user mutableSetValueForKey:@"followers"] addObject:[UserUpdater curUser]];
                 [[user mutableSetValueForKey:@"following"] addObject:[UserUpdater curUser]];
                 
                 if (![[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext save:nil]) {
                     NSLog(@"Unable to save MOC while updating friends");
                     return;
                 }
                 else {
                     NSLog(@"SOOOOO FAR SO GOOOD!");
                     handler();
                 }
             }
             else {
                 NSLog(@"WAT, looking for friends without current user");
                 return;
             }
         }
     }
     failure:^void(RKObjectRequestOperation *operation, NSError *error) {
         NSLog(@"Error getting users: %@", error);
     }];

}

@end
