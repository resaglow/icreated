//
//  RegisterViewController.m
//  icreated
//
//  Created by Artem Lobanov on 17/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *responseData;

@end


@implementation RegisterViewController

- (void)viewDidLoad {
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
    // For cancelling the connection, if it's already established
    // I.e., button double-tapping case
    [self.connection cancel];
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      @"http://nbixman-001-site1.myasp.net/api/Account/Register"]];
    
    [theRequest setHTTPMethod:@"POST"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.loginTextField.text, @"UserName",
                                    self.passwordTextField.text, @"Password",
                                    self.passwordTextField.text, @"ConfirmPassword",
                                    nil];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    [theRequest setHTTPBody:jsonData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest
                                                                  delegate:self];
    self.connection = connection;
    [connection start];
    // Not really clear, why these assignments are necessary
    // Still, it's working this way, so let it be for now
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    self.errorLabel.text = @"";
    if (response.statusCode == 200) {
        NSLog(@"Register OK!");
        [self performSegueWithIdentifier:@"registerSuccessful" sender:self];
    }
    else {
        if (response.statusCode == 400) {
            NSLog(@"Register not OK!");
            self.errorLabel.text = @"Username is already taken.";
            // There can't be another error type (password confirmation not correct)
            // because password is only typed by user once
        }
        else {
            NSLog(@"Register very not OK!, status code = %ld", (long)response.statusCode);
            self.errorLabel.text = @"Unknown error.";
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection error: %@" , error);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Register finished loading");
}


@end














