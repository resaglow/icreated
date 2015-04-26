//
//  UserUpdater.h
//  icreated
//
//  Created by Artem Lobanov on 23/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import "Updater.h"
#import "User.h"

typedef NS_ENUM(NSUInteger, UserType) {
    UserTypeFriends,
    UserTypeFollowing,
    UserTypeFollowers
};

@interface UserUpdater : Updater

- (NSFetchedResultsController *)getFetchedResultsControllerWithUserType:(UserType)userType;

- (void)getUserInfoWithSuccess:(RestKitSuccessHandler)successHandler
                       failure:(RestKitFailureHandler)failureHandler;

- (void)getUsersOfType:(UserType)userType byUserId:(NSInteger)userId
           WithSuccess:(RestKitSuccessHandler)successHandler
               failure:(RestKitFailureHandler)failureHandler;

+ (User *)curUser;
+ (void)setCurUser:(User *)user;
+ (void)initCurUser;

@end
