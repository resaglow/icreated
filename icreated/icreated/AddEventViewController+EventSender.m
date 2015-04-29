//
//  AddEventViewController+EventSender.m
//  icreated
//
//  Created by Artem Lobanov on 04/12/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "AddEventViewController+EventSender.h"
#import <RestKit/RestKit.h>
#import <ISO8601DateFormatterValueTransformer/RKISO8601DateFormatter.h>
#import "Updater.h"

@implementation AddEventViewController (EventSender)


- (void)sendEvent {
    NSLog(@"Sending...");
    
    if (!self.annotation || !self.eventDate) {
        NSLog(@"Not enough info for event adding");
        return;
    }
    
    NSString *path = @"/api/Events";
    AFHTTPClient *httpClient = [RKObjectManager sharedManager].HTTPClient;
    [httpClient cancelAllHTTPOperationsWithMethod:nil path:path];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    Updater *updater = [[Updater alloc] init];
    [updater getTokenWithSuccess:^(NSString *tokenToSend) {
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:tokenToSend];
    } failure:^{ NSLog(@"Adding event without token is forbidden"); }];
    
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    RKISO8601DateFormatter *formatter = [RKISO8601DateFormatter new];
    formatter.includeTime = YES, formatter.timeZone = nil;
    NSString *dateString = [formatter stringFromDate:self.eventDate];
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [[NSNumber numberWithDouble:self.annotation.coordinate.latitude] stringValue], @"Latitude",
                                    [[NSNumber numberWithDouble:self.annotation.coordinate.longitude] stringValue], @"Longitude",
                                    self.textView.text, @"Description",
                                    dateString, @"EventDate",
                                    nil];
    
    [httpClient postPath:path parameters:jsonDictionary
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSLog(@"Event added, OK");
                     [self dismiss];
                     
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     if (operation.response.statusCode == 200) {
                         NSLog(@"Event added, OK");
                         [self dismiss];
                     }
                     else {
                         NSLog(@"Failed adding event:(");
                         NSLog(@"Error adding: %@", error.description);
                     }
                 }];
}

@end
