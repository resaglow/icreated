//
//  EventUpdater.h
//  icreated
//
//  Created by Artem Lobanov on 21/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import "Updater.h"
#import <UIKit/UIKit.h>

@interface EventUpdater : Updater

@property (readonly, nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)getEventsWithSuccess:(RestKitSuccessHandler)successHandler failure:(RestKitFailureHandler)failureHandler;

@end
