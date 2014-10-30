//
//  EventUpdater.m
//  icreated
//
//  Created by Artem Lobanov on 20/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "EventUpdater.h"

@interface EventUpdater ()

@end

@implementation EventUpdater

static NSMutableArray *updatedEventsArray;

+ (NSMutableArray *)updatedEventsArray
{
    if (!updatedEventsArray)
        updatedEventsArray = [[NSMutableArray alloc] init];
    
    return updatedEventsArray;
}


+ (void)getEventsWithCompletionHandler:(void (^)(void))handler {
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      @"http://customer87-001-site1.myasp.net/api/Events"]];
    
    // Standard authRequired code
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//    if (token == nil) {
//        handler();
//        return;
//    }
//    
//    NSString *tokenToSend = [@"Bearer " stringByAppendingString:token];
//    [theRequest addValue:tokenToSend forHTTPHeaderField:@"Authorization"];
    
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if (error != nil) {
            NSLog(@"Connection fault, error = %@", error);
            handler();
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            NSLog(@"Server fault, status code = %ld", (long)httpResponse.statusCode);
            handler();
            return;
        }
        
        NSError *error2 = nil;
        updatedEventsArray = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:data
                                                                               options:NSJSONReadingMutableLeaves
                                                                                 error:&error2];
            
        // Somehow "костыль" because of dead server response
        // Приходит, когда сервер упал, но все равно присылает 200
        if ([updatedEventsArray isEqual: @{ @"Message": @"An error has occurred." }]) {
            NSLog(@"Server fault, however 200 status code (Message : An error has occurred)");
            updatedEventsArray = (NSMutableArray *)@[];
        }
        else {
            NSLog(@"Events update OK");
        }
        
        NSLog(@"About to handle");
        handler();
            
        // Write updatedEventsArray into a DB
        
        
    }];
}

@end
