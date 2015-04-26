//
//  Updater.m
//  icreated
//
//  Created by Artem Lobanov on 21/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import "Updater.h"

@implementation Updater

static NSFetchedResultsController *fetchedResultsController;

- (NSFetchedResultsController *)getFetchedResultsControllerWithEntity:(NSString *)entityName
                                                            /*batchSize:(NSInteger)batchSize*/
                                                              sortKey:(NSString *)sortKey
                                                            /*predicate:(NSPredicate *)predicate*/ {
    if (fetchedResultsController && fetchedResultsController.fetchRequest.entityName == entityName) {
        return fetchedResultsController;
    }
                                                                
    NSManagedObjectContext *managedObjectContext = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                   managedObjectContext:managedObjectContext
                                                                     sectionNameKeyPath:nil
                                                                              cacheName:@"Master"];
    
    return fetchedResultsController;
}

- (void)getTokenWithSuccess:(void (^)(NSString *))successHandler failure:(void (^)(void))failureHandler {
    // Standard authRequired code
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token == nil) {
        NSLog(@"WAT: Users request while logged out");
        if (failureHandler) failureHandler();
    }
    successHandler([@"Bearer " stringByAppendingString:token]);
}

@end
