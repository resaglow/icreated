//
//  UserUpdater.h
//  icreated
//
//  Created by Artem Lobanov on 19/12/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"

typedef NS_ENUM(NSUInteger, UserType) {
    UserTypeFriends,
    UserTypeFollowing,
    UserTypeFollowers
};

@interface UserUpdater : NSObject

+ (void)getUserInfoWithCompletionhandler:(void (^)(void))handler;

+ (void)getUsersOfType:(UserType)userType byUserId:(NSInteger)userId completionhandler:(void (^)(void))handler;

@end
