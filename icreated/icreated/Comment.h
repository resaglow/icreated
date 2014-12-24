//
//  Comment.h
//  icreated
//
//  Created by Artem Lobanov on 18/12/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) Event *event;

@end
