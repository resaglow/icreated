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

static NSArray *eventsArray;

+ (NSArray *)eventsArray
{
    if (!eventsArray)
        eventsArray = [[NSArray alloc] init];
    
    return eventsArray;
}


- (void)getEventsWithCompletionHandler:(void (^)(void))handler {
    NSLog(@"Smth");
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      @"http://customer87-001-site1.myasp.net/api/Events"]];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
//    NSString *bearer = @"Bearer";
//    NSString *token = [bearer stringByAppendingString:[defaults objectForKey:@"token"]];
//    [theRequest addValue:token forHTTPHeaderField:@"Authorization"];
    
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error != nil) {
             return;
         }
         else {
             NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
             NSString *docDirectory = [paths objectAtIndex:0];
             NSString *dataFilePath = [docDirectory stringByAppendingPathComponent:@"tempdata"];
             
             NSLog(@"Logging to file %@", dataFilePath);
             
             [data writeToFile:dataFilePath atomically:YES];
             
             NSError *error = nil;
             NSArray *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
             eventsArray = (NSMutableArray *)res;
             
             for (id event in res) {
                 NSDictionary *dictEvent = (NSDictionary *)event;
                 
                 for (id key in dictEvent) {
                     id value = [dictEvent objectForKey:key];
                     
                     NSString *keyAsString = (NSString *)key;
                     NSString *valueAsString = (NSString *)value;
                     
                     NSLog(@"key: %@", keyAsString);
                     NSLog(@"value: %@", valueAsString);
                 }
             }
         }
         handler();
         
     }];
}

@end
