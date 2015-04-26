//
//  EventUpdater.m
//  icreated
//
//  Created by Artem Lobanov on 21/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import "EventUpdater.h"

@implementation EventUpdater

- (NSFetchedResultsController *)fetchedResultsController {
    return [super getFetchedResultsControllerWithEntity:@"Event"
                                                sortKey:@"eventId"
                                              predicate:nil];
}

- (void)getEventsWithSuccess:(RestKitSuccessHandler)successHandler failure:(RestKitFailureHandler)failureHandler {
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/Events" parameters:nil
                                              success:successHandler failure:failureHandler];
}

@end
