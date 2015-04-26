//
//  UserUpdater.m
//  icreated
//
//  Created by Artem Lobanov on 23/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import "UserUpdater.h"

@implementation UserUpdater

static User *_curUser;

+ (User *)curUser {
    return _curUser;
}

+ (void)setCurUser:(User *)user {
    _curUser = user;
}

+ (void)initCurUserRemoteWithSuccess:(RestKitSuccessHandler)successHandler
                             failure:(RestKitFailureHandler)failureHandler {
    UserUpdater *updater = [[UserUpdater alloc] init];
    [updater getUserInfoWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (mappingResult && mappingResult.array.count > 0) {
            [UserUpdater setCurUser:(User *)mappingResult.array[0]];
            successHandler(operation, mappingResult);
        }
        else {
            NSLog(@"Bug: can't map remote curUser");
        }
        
    } failure:failureHandler];
}

+ (void)initCurUserLocal {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSManagedObjectContext *managedObjectContext = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    if ([userDefaults objectForKey:@"token"]) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"User"
                                            inManagedObjectContext:managedObjectContext]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"userName like %@", [userDefaults objectForKey:@"userName"]]];
        NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
        if (result && result.count > 0) {
            [self setCurUser:(User *)result[0]];
        }
        else {
            NSLog(@"Bug: Setting curUser while it's not in the local store");
        }
    }
    else {
        NSLog(@"Bug: setting curUser while not having token");
    }
}


- (NSFetchedResultsController *)getFetchedResultsControllerWithUserType:(UserType)userType {
    NSString *curUserName = [UserUpdater curUser].userName;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"(ANY followers.userName like %@) AND (ANY following.userName like %@)", curUserName, curUserName];
    
    return [super getFetchedResultsControllerWithEntity:@"User"
                                                sortKey:@"userName"
                                              predicate:predicate];
}

- (void)getUserInfoWithSuccess:(RestKitSuccessHandler)successHandler
                       failure:(RestKitFailureHandler)failureHandler  {
    [self getTokenWithSuccess:^(NSString *tokenToSend) {
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:tokenToSend];
    } failure:^{
        NSLog(@"Getting userInfo without token, cannot do this due to server");
    }];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/Account/UserInfo" parameters:nil
                                              success:successHandler failure:failureHandler];
}

- (void)getUsersOfType:(UserType)userType byUserId:(NSInteger)userId
           WithSuccess:(RestKitSuccessHandler)successHandler
               failure:(RestKitFailureHandler)failureHandler {
    [self getTokenWithSuccess:^(NSString *tokenToSend) {
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:tokenToSend];
    } failure:^{
        NSLog(@"Getting users without token, cannot do this due to server");
    }];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    // [start] Configure path
    NSString *path = nil;
    switch (userType) {
        case UserTypeFriends:
            path = @"/api/Friends/List/:id/m";
            break;
        
        case UserTypeFollowing:
            path = @"/api/Friends/List/:id/s"; // subscribed to == following
            break;
            
        case UserTypeFollowers:
            path = @"/api/Friends/List/:id/f";
            break;
            
        default:
            NSLog(@"WAAAT O_O");
            return;
    }
    // HOW TO GET CURRENT USER ID??
    path = [path stringByReplacingOccurrencesOfString:@":id" withString:@"26"/*[NSString stringWithFormat:@"%ld", (long)userId]*/];
    // [end] Configure path
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path parameters:nil
                                              success:successHandler failure:failureHandler];
}


@end
