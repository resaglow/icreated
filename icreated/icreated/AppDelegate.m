//
//  AppDelegate.m
//  icreated
//
//  Created by Artem Lobanov on 17/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "AppDelegate.h"
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>
#import "Event.h"
#import "UserUpdater.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initUIOptions];
    [self initRestKit];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - UI Options method

- (void)initUIOptions {
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:192.0f / 255.0f
                                                                  green:57.0f / 255.0f
                                                                   blue:43.0f / 255.0f
                                                                  alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}
                                                   forState:UIControlStateSelected];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                              NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0f]}
                                                   forState:UIControlStateNormal];
    
    [[UISegmentedControl appearance] setBackgroundColor:[UIColor redColor]];
    
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:192.0f / 255.0f
                                                                  green:57.0f / 255.0f
                                                                   blue:43.0f / 255.0f
                                                                  alpha:1]];
    
}

#pragma mark - RestKit initialization

- (void)initRestKit {
    // Initialize RestKit
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
    
    
    
    // Setting up event mapping
    RKEntityMapping *eventMapping = [RKEntityMapping mappingForEntityForName:@"Event" inManagedObjectStore:managedObjectStore];
    [eventMapping addAttributeMappingsFromDictionary:@{@"EventId": @"eventId",
                                                       @"Description": @"desc",
                                                       @"EventDate": @"date",
                                                       @"Latitude": @"latitude",
                                                       @"Longitude": @"longitude"}];
    eventMapping.identificationAttributes = @[@"eventId"];
    
    RKResponseDescriptor *eventResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:eventMapping method:RKRequestMethodAny
                                            pathPattern:@"/api/Events" keyPath:nil
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:eventResponseDescriptor];
    
    
    // Setting up user & self mapping
    RKEntityMapping *userMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:managedObjectStore];
    [userMapping addAttributeMappingsFromDictionary:@{/*@"UserId": @"userId",*/
                                                      @"UserName": @"userName"/*,
                                                      @"Photo": @"photo"*/}];
    userMapping.identificationAttributes = @[@"userName"];
    
    RKResponseDescriptor *userResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userMapping method:RKRequestMethodAny
                                            pathPattern:@"/api/Friends/List/:id/:type" keyPath:nil
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKResponseDescriptor *selfResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userMapping method:RKRequestMethodAny
                                            pathPattern:@"/api/Account/UserInfo" keyPath:nil
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:userResponseDescriptor];
    [[RKObjectManager sharedManager] addResponseDescriptor:selfResponseDescriptor];
    
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
}


@end
