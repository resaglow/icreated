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


- (NSFetchedResultsController *)fetchedResultsController {
    return [super getFetchedResultsControllerWithEntity:@"User" sortKey:@"userName"];
}

- (void)getUserInfoWithSuccess:(RestKitSuccessHandler)successHandler
                       failure:(RestKitFailureHandler)failureHandler  {
    [self getTokenWithSuccess:^(NSString *tokenToSend) {
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:tokenToSend];
    } failure:^{
        NSLog(@"Getting users without token, cannot do this due to server");
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
    path = [path stringByReplacingOccurrencesOfString:@":id" withString:@"26"/*[NSString stringWithFormat:@"%ld", (long)userId]*/];
    // [end] Configure path
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path parameters:nil
                                              success:successHandler failure:failureHandler];
}


@end
