//
//  LoginViewController.m
//  icreated
//
//  Created by Artem Lobanov on 17/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "LoginViewController.h"
#import "SWRevealViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *responseData;

@end


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"\uf0c9";
    barButton.tintColor = [UIColor whiteColor];
    barButton.target = self.revealViewController;
    barButton.action = @selector(revealToggle:);
    
    self.navigationItem.leftBarButtonItem = barButton;
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.responseData = [NSMutableData data];
}


- (IBAction)sendLogin:(id)sender {
    [self.connection cancel];
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      @"http://nbixman-001-site1.myasp.net/Token"]];
    
    [theRequest setHTTPMethod:@"POST"];
    [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString *postData = [NSString stringWithFormat:
                          @"grant_type=password&username=%@&password=%@",
                          self.loginTextField.text,
                          self.passwordTextField.text];    
    
    [theRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest
                                                                  delegate:self];
    self.connection = connection;
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection error: %@" , error);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Login finished loading");
    
    NSError *error = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&error];
        
    NSString *token = [res objectForKey:@"access_token"];
    
    if (token == nil) {
        NSLog(@"Login failed");
        self.errorLabel.text = @"Username and/or password are not correct";
    }
    else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:token forKey:@"token"];
        
        NSLog(@"Logged in successfully");
    
        [self performSegueWithIdentifier:@"loginSuccessful" sender:self];
    }
}


@end
