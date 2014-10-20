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


- (IBAction)sendRegister:(id)sender {
    // Для отмены соединения, если оно уже установлено
    // Например, при повторном нажатии кнопки
    [self.connection cancel];
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      @"http://customer87-001-site1.myasp.net/api/Account/Register"]];
    
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.loginTextField.text, @"UserName",
                                    self.passwordTextField.text, @"Password",
                                    self.passwordTextField.text, @"ConfirmPassword",
                                    nil];
    
    // error нужна, но в данном случае не используется
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
    // Не очень понятно, зачем эти присвоения и т.д., но работает стабильно,
    // так что пусть будет так
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    if (response.statusCode == 200) {
        NSLog(@"Register OK!");
        [self performSegueWithIdentifier:@"registerSuccessful" sender:self];
    }
    else {
        if (response.statusCode == 400) {
            NSLog(@"Register not OK!");
            self.errorLabel.text = @"Username is already taken.";
            // Другого вида ошибки у нас быть не может,
            // т.к. подтверждения пароля от пользователя не требуется
        }
        else {
            NSLog(@"Register very not OK!");
            self.errorLabel.text = @"Unknown error.";
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection error: %@" , error);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Finished loading");
}


@end














