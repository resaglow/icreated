//
//  LoginViewController.m
//  icreated
//
//  Created by Artem Lobanov on 17/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "MenuViewController.h"
#import "LoginViewController.h"
#import "SWRevealViewController.h"
#import <RestKit/RestKit.h>
#import "UserUpdater.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *responseData;

@end


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIBarButtonItem initMenuWithController:self];
    
    UILabel *titleViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 40)];
    titleViewLabel.text = @"Login";
    titleViewLabel.textAlignment = NSTextAlignmentCenter;
    titleViewLabel.font = [UIFont fontWithName:@"FontAwesome" size:kFAStandardFontSize];
    titleViewLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleViewLabel;
    
    self.responseData = [NSMutableData data];
}

- (IBAction)sendLogin:(id)sender {
    [self.connection cancel];
    
    AFHTTPClient *httpClient = [RKObjectManager sharedManager].HTTPClient;
    [httpClient cancelAllHTTPOperationsWithMethod:nil path:@"/Token"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSDictionary *parameters = @{@"username": self.usernameTextField.text,
                                 @"password": self.passwordTextField.text,
                                 @"grant_type": @"password"};
    
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [httpClient postPath:@"/Token" parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSLog(@"Logged in successfully");
                     
                     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                     [userDefaults setObject:[responseObject objectForKey:@"access_token"] forKey:@"token"];
                     [userDefaults synchronize];
                     
                     // Getting userId
                     UserUpdater *updater = [[UserUpdater alloc] init];
                     [updater getUserInfoWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                         [UserUpdater setCurUser:(User *)mappingResult.array[0]];
                         [self moveToMainScreen];
                     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                         NSLog(@"XOXOXO");
                         [self moveToMainScreen];
                     }];
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"Failed logging in:(");
                     self.errorLabel.text = @"Maybe(!) username and/or password are not correct";
                 }];
}

- (void)moveToMainScreen {
    MenuViewController *menuVC = (MenuViewController *)self.revealViewController.rearViewController;
    [menuVC reloadMenu];
    
    [self performSegueWithIdentifier:@"loginSuccessful" sender:self];
}

@end
