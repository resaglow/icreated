//
//  MainScreenTests.h
//  icreated
//
//  Created by Artem Lobanov on 07/05/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#ifndef icreated_MainScreenTests_h
#define icreated_MainScreenTests_h

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MainViewController+NewsStand.h"
#import <RKISO8601DateFormatter.h>

@interface MainScreenTests : XCTestCase
@property (strong, nonatomic) MainViewController *mainViewController;
@property (strong, nonatomic) UIStoryboard *storyboard;
@property id event;
@property (nonatomic, strong) id fakeUserDefaults;
@end

@protocol EventInterface <NSObject>
@property (nonatomic, retain) id date;
@property (nonatomic, retain) id desc;
@end

#endif
