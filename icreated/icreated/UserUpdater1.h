//
//  UserUpdater1.h
//  icreated
//
//  Created by Artem Lobanov on 23/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import "Updater.h"

typedef NS_ENUM(NSUInteger, UserType) {
    UserTypeFriends,
    UserTypeFollowing,
    UserTypeFollowers
};

@interface UserUpdater1 : Updater

//+ (void)getUserInfoWithSucess:(void (^)(void))handler;
//
//+ (void)getUsersOfType:(UserType)userType byUserId:(NSInteger)userId completionhandler:(void (^)(void))handler;

- (void)getUserInfoWithCompletionhandler:(void (^)(void))handler;

- (void)getUsersOfType:(UserType)userType byUserId:(NSInteger)userId
           WithSuccess:(RestKitSuccessHandler)successHandler
               failure:(RestKitFailureHandler)failureHandler;


@end
