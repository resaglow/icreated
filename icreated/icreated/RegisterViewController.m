//
//  RegisterViewController.m
//  icreated
//
//  Created by Artem Lobanov on 17/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "RegisterViewController.h"
#import <RestKit/RestKit.h>

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *responseData;

@end


@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitle];
}

- (void)initTitle {
    UILabel *titleView = [UILabel new];
    
    titleView.text = @"Register";
    titleView.textColor = [UIColor whiteColor];
    titleView.font = [UIFont systemFontOfSize:25.f];
    
    CGRect desiredFrame = [titleView.text boundingRectWithSize:CGSizeMake(self.view.bounds.size.width, 0)
                                                       options:NSStringDrawingTruncatesLastVisibleLine
                                                    attributes:@{NSFontAttributeName:titleView.font}
                                                       context:nil];
    
    titleView.frame = CGRectMake(0, 0, desiredFrame.size.width, desiredFrame.size.height);
    
    self.navigationItem.titleView = titleView;
}


- (IBAction)sendRegister:(id)sender {
    NSString *path = @"api/Account/Register";
    AFHTTPClient *httpClient = [RKObjectManager sharedManager].HTTPClient;
    [httpClient cancelAllHTTPOperationsWithMethod:nil path:path];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSDictionary *parameters = @{@"UserName": self.loginTextField.text,
                                 @"Password": self.passwordTextField.text,
                                 @"ConfirmPassword": self.passwordTextField.text};
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:nil];
    
    [httpClient postPath:path parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSLog(@"Register OK!");
                     [self performSegueWithIdentifier:@"registerSuccessful" sender:self];
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     if (operation.response.statusCode == 200) { // maybe bug in AFNetworking, empty dict is cosidered a failure
                         NSLog(@"Register OK!");
                         [self performSegueWithIdentifier:@"registerSuccessful" sender:self];
                     }
                     else if (operation.response.statusCode == 400) {
                         NSLog(@"Register not OK!");
                         self.errorLabel.text = @"Username is already taken.";
                         // There can't be another error type (password confirmation not correct)
                         // because password is only typed by user once
                     }
                     else {
                         NSLog(@"Register very not OK!, status code = %ld", (long)operation.response.statusCode);
                         NSLog(@"Error: %@", error.description);
                         self.errorLabel.text = @"Unknown error.";
                     }
                 }];
    
}

@end














