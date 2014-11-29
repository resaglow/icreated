//
//  Photo.h
//  icreated
//
//  Created by Artem Lobanov on 30/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Friend;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) Friend *user;

@end
