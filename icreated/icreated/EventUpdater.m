//
//  EventUpdater.m
//  icreated
//
//  Created by Artem Lobanov on 20/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "EventUpdater.h"

@interface EventUpdater ()

@property (retain, nonatomic) NSURLConnection *connection;

@end

@implementation EventUpdater

- (void)sendGetEvents {
    [self.connection cancel];
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      @"http://customer87-001-site1.myasp.net/api/Events"]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest
                                                                  delegate:self];
    self.connection = connection;
    [connection start];
}

@end
