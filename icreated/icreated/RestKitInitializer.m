//
//  RestKitInitializer.m
//  icreated
//
//  Created by Artem Lobanov on 14/05/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import "RestKitInitializer.h"
#import "Event.h"
#import "UserUpdater.h"
#import <ISO8601DateFormatterValueTransformer/RKISO8601DateFormatter.h>

@implementation RestKitInitializer

BOOL initFlag;

- (instancetype)initUniqueInstance {
    return [super init];
}

+ (instancetype)initializer {
    static id _initializer = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _initializer = [[super alloc] initUniqueInstance];
    });
    return _initializer;
}


- (void)initRestKit {
    if (initFlag) {
        return;
    }
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kServerUrl]];
    
    // Initialize managed object model from bundle
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    // Initialize managed object store
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    // Complete Core Data stack initialization
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"icreatedDB.sqlite"];
    NSString *seedPath = [[NSBundle mainBundle] pathForResource:@"icreatedSeedDB" ofType:@"sqlite"];
    NSError *error;
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath
                                                                     fromSeedDatabaseAtPath:seedPath
                                                                          withConfiguration:nil options:nil error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc]
                                             initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
    
    // Setting up user & self mapping
    self.userMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:managedObjectStore];
    [self.userMapping addAttributeMappingsFromDictionary:@{/*@"UserId": @"userId",*/
                                                           @"UserName": @"userName"/*,
                                                              @"Photo": @"photo"*/}];
    self.userMapping.identificationAttributes = @[@"userName"];
    
    RKResponseDescriptor *userResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:self.userMapping method:RKRequestMethodAny
                                            pathPattern:@"/api/Friends/List/:id/:type" keyPath:nil
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKResponseDescriptor *selfResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:self.userMapping method:RKRequestMethodAny
                                            pathPattern:@"/api/Account/UserInfo" keyPath:nil
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:userResponseDescriptor];
    [[RKObjectManager sharedManager] addResponseDescriptor:selfResponseDescriptor];
    
    // Setting up event mapping
    self.eventMapping = [RKEntityMapping mappingForEntityForName:@"Event" inManagedObjectStore:managedObjectStore];
    [self.eventMapping addAttributeMappingsFromDictionary:@{@"EventId": @"eventId",
                                                        @"Description": @"desc",
                                                          @"EventDate": @"date",
                                                           @"Latitude": @"latitude",
                                                          @"Longitude": @"longitude"}];
    self.eventMapping.identificationAttributes = @[@"eventId"];
    
    RKResponseDescriptor *eventResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:self.eventMapping method:RKRequestMethodAny
                                            pathPattern:@"/api/Events" keyPath:nil
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:eventResponseDescriptor];
    
    // To perform local orphaned object cleanup
    [objectManager addFetchRequestBlock:^NSFetchRequest *(NSURL *url) {
        RKPathMatcher *pathMatcherEvent = [RKPathMatcher pathMatcherWithPattern:@"/api/Events"];
        BOOL matchEvent = [pathMatcherEvent matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:nil];
        // TODO Orphaned objects for friends and self
        //        RKPathMatcher *pathMatcherFriends = [RKPathMatcher pathMatcherWithPattern:@"/api/Friends/List/:id/:type"];
        //        BOOL matchFriends = [pathMatcherFriends matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:nil];
        //        RKPathMatcher *pathMatcherSelf = [RKPathMatcher pathMatcherWithPattern:@"/api/Account/UserInfo"];
        //        BOOL matchSelf = [pathMatcherSelf matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:nil];
        if (matchEvent) {
            NSLog(@"Pattern matched events");
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
            return fetchRequest;
        }
        //        else if (matchFriends) {
        //            NSLog(@"Pattern matched friends");
        //            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        //            return fetchRequest;
        //        }
        //        else if (matchSelf) {
        //            NSLog(@"Pattern matched self");
        //            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CenterViewItem"];
        //            return fetchRequest;
        //        }
        return nil;
    }];
    
    [UserUpdater initCurUserLocal];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    initFlag = YES;
}

@end
