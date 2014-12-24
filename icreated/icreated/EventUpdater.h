//
//  EventUpdater.h
//  icreated
//
//  Created by Artem Lobanov on 20/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "AppDelegate.h"
#import "Event.h"

@interface EventUpdater : NSObject <NSURLConnectionDataDelegate>

+ (void) setManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)fetchedResultsController;

+ (void)getEventsWithCompletionHandler:(void (^)(void))handler;

@end
