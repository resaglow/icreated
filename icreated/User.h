//
//  User.h
//  icreated
//
//  Created by Artem Lobanov on 02/05/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Photo, User;

@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) Photo *avatar;
@property (nonatomic, retain) NSSet *followers;
@property (nonatomic, retain) NSSet *following;
@property (nonatomic, retain) NSSet *createdEvents;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFollowersObject:(User *)value;
- (void)removeFollowersObject:(User *)value;
- (void)addFollowers:(NSSet *)values;
- (void)removeFollowers:(NSSet *)values;

- (void)addFollowingObject:(User *)value;
- (void)removeFollowingObject:(User *)value;
- (void)addFollowing:(NSSet *)values;
- (void)removeFollowing:(NSSet *)values;

- (void)addCreatedEventsObject:(Event *)value;
- (void)removeCreatedEventsObject:(Event *)value;
- (void)addCreatedEvents:(NSSet *)values;
- (void)removeCreatedEvents:(NSSet *)values;

@end
