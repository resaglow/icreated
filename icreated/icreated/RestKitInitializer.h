//
//  RestKitInitializer.h
//  icreated
//
//  Created by Artem Lobanov on 14/05/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>

@interface RestKitInitializer : NSObject

@property (nonatomic, strong) RKEntityMapping *eventMapping;
@property (nonatomic, strong) RKEntityMapping *userMapping;

+ (instancetype)initializer;
- (void)initRestKit;

+ (instancetype) alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
- (instancetype) init __attribute__((unavailable("init not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
