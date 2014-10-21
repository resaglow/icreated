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

static NSMutableArray *eventsArray;

+ (NSMutableArray *)eventsArray
{
    if (!eventsArray)
        eventsArray = [[NSMutableArray alloc] init];
    
    return eventsArray;
}


+ (void)getEventsWithCompletionHandler:(void (^)(void))handler {
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      @"http://customer87-001-site1.myasp.net/api/Events"]];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token == nil) {
        handler();
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
             return;
         }
         else {
             NSError *error = nil;
             eventsArray = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:data
                                                                             options:NSJSONReadingMutableLeaves
                                                                               error:&error];
         }
         
         handler();
     }];
}

@end
