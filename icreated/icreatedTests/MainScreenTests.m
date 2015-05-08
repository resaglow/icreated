//
//  MainScreenTests.m
//  icreated
//
//  Created by Artem Lobanov on 18/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import "MainScreenTests.h"

@implementation MainScreenTests

- (void)setUp {
    [super setUp];
    self.fakeUserDefaults = [OCMockObject partialMockForObject:[NSUserDefaults standardUserDefaults]];
    id fud = [OCMockObject mockForClass:[NSUserDefaults class]];
    [[[fud stub] andReturn:self.fakeUserDefaults] standardUserDefaults];
    self.storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
    [self.mainViewController view];
    
    self.event = [OCMockObject mockForProtocol:@protocol(EventInterface)];
    [[[self.event stub] andReturn:[NSDate date]] date];
    [[[self.event stub] andReturn:@"Sample test event"] desc];
}

- (void)tearDown {
    self.mainViewController = nil;
    self.fakeUserDefaults = nil;
    [super tearDown];
}

- (void)testLoggedOutAddEventButton {
    [[[self.fakeUserDefaults stub] andReturn:nil] objectForKey:@"token"];
    
    self.mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
    [self.mainViewController view];
    
    XCTAssertFalse([[self.mainViewController.navigationItem.rightBarButtonItems mutableCopy]
                    containsObject:self.mainViewController.addEventButton]);
}

- (void)testLoggedInAddEventButton {
    [[[self.fakeUserDefaults stub] andReturn:@"ololo testToken"] objectForKey:@"token"];
    
    self.mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
    [self.mainViewController view];
    
    XCTAssertTrue([[self.mainViewController.navigationItem.rightBarButtonItems mutableCopy]
                   containsObject:self.mainViewController.addEventButton]);
}

@end
