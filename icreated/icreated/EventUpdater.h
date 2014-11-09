//
//  EventUpdater.h
//  icreated
//
//  Created by Artem Lobanov on 20/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Event.h"


@interface EventUpdater : NSObject  <NSURLConnectionDataDelegate>

+ (void) setManagedObjectContext:(NSManagedObjectContext *)context;

//+ (NSMutableArray *)updatedEventsArray;

+ (NSFetchedResultsController *)fetchedResultsController;

+ (void)getEventsWithCompletionHandler:(void (^)(void))handler;



@end
