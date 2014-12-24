//
//  ProfileViewController.m
//  icreated
//
//  Created by Artem Lobanov on 18/12/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "ProfileViewController.h"
#import "UsersViewController.h"
#import "SWRevealViewController.h"

@interface ProfileViewController ()

@property UIImageView *avatarImage;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UILabel *titleViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 40)];
    titleViewLabel.text = NSLocalizedString(@"Profile", "");
    titleViewLabel.textAlignment = NSTextAlignmentCenter;
    titleViewLabel.font = [UIFont fontWithName:@"FontAwesome" size:25.0];
    titleViewLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleViewLabel;
    
    // Default property value is always 0/nil in Obj-C,
    // so if parent view controller didn't specify it, init should be sended
    // otherwise shouldn't.
    if (!self.menuFlag) {
        [self initMenu];
    }
    
    [self initAvatar];
    
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 110, 160, 50)];
    usernameLabel.numberOfLines = 2;
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (username != nil) usernameLabel.text = username;
    [self.view addSubview:usernameLabel];
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

- (void)initAvatar {
    self.avatarImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sampleAvatar.jpeg"]];
    self.avatarImage.frame = CGRectMake(20, 80, 120, 120);
    self.avatarImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImage.layer.borderWidth = 2.0f;
    
    CALayer* containerLayer = [CALayer layer];
    containerLayer.shadowColor = [UIColor blackColor].CGColor;
    containerLayer.shadowRadius = 2.f;
    containerLayer.shadowOffset = CGSizeMake(0.f, 0.f);
    containerLayer.shadowOpacity = 1.f;
    
    self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.width / 2.0;
    self.avatarImage.layer.masksToBounds = YES;
    
    [containerLayer addSublayer:self.avatarImage.layer];
    
    [self.view.layer addSublayer:containerLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[UsersViewController class]]) {
        UsersViewController *profileVC = (UsersViewController *)(segue.destinationViewController);
        profileVC.menuFlag = TRUE;
    }
}

@end
