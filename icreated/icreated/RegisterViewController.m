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
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *response;

@end


@implementation RegisterViewController


- (IBAction)sendRegister:(id)sender {
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:
                                                     @"http://customer87-001-site1.myasp.net/api/Account/Register"]];
    
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.loginTextField.text, @"UserName",
                                    self.passwordTextField.text, @"Password",
                                    self.passwordTextField.text, @"ConfirmPassword",
                                    nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [theRequest setHTTPBody:jsonData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest
                                                                  delegate:self];
    self.connection = connection;
    
    [connection start];
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    if (response.statusCode == 200) {
        NSLog(@"OK!");
    }
    else if (response.statusCode == 400) {
        NSLog(@"Not OK!");
    }
    else {
        NSLog(@"Very not OK!");
    }
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@" , error);
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Finished loading");
}


@end














