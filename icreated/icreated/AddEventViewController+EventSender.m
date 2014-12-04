//
//  AddEventViewController+EventSender.m
//  icreated
//
//  Created by Artem Lobanov on 04/12/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "AddEventViewController+EventSender.h"

@implementation AddEventViewController (EventSender)


- (void)sendEvent {
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      @"http://nbixman-site1.myasp.net/api/AddEvent"]];
    
    // Standard authRequired code
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token == nil) {
        NSLog(@"Cant get token");
        return;
    }

    NSString *tokenToSend = [@"Bearer " stringByAppendingString:token];
    [theRequest addValue:tokenToSend forHTTPHeaderField:@"Authorization"];
    
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error != nil) {
             NSLog(@"BUG: Connection fault, error = %@", error);
             return;
         }
         
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         if (httpResponse.statusCode != 200) {
             NSLog(@"BUG: Server fault, status code = %ld", (long)httpResponse.statusCode);
             return;
         }
         
         
         NSError *error2 = nil;
         NSMutableArray *jsonData = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:data
                                                                                      options:NSJSONReadingMutableLeaves
                                                                                        error:&error2];
         
         // Somehow "костыль" because of dead server response
         // Приходит, когда сервер упал, но все равно присылает 200
         if ([jsonData isEqual: @{ @"Message": @"An error has occurred." }]) {
             NSLog(@"BUG: Server fault, however 200 status code (Message : An error has occurred)");
             jsonData = (NSMutableArray *)@[];
         }
         else {
             NSLog(@"Events update OK");
         }
     }];
}

@end
