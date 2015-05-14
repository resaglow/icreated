//
//  MapTests.m
//  icreated
//
//  Created by Artem Lobanov on 07/05/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MainScreenTests.h"


@interface MainViewController ()
- (void)pushDetailViewController;
@end

@interface MapTests : MainScreenTests
@end

@implementation MapTests

static MapTests *sharedInstance;

- (void)setUp {
    [super setUp];
    sharedInstance = self;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitializer {
    XCTAssertEqual(self.mainViewController.mapCalloutDataSource.mapView, self.mainViewController.mapView);
    XCTAssertEqual(self.mainViewController.mapCalloutDataSource.delegate, self.mainViewController);
    XCTAssertEqual(self.mainViewController.mapCalloutDataSource.eventUpdater, self.mainViewController.eventUpdater);
    XCTAssertEqual(NO, NO, @"lol");
}

- (void)testEventDetailButton {
    UIButton *calloutButton = (UIButton *)self.mainViewController.mapCalloutDataSource.calloutView.contentView;
    id mainVCMock = [OCMockObject partialMockForObject:self.mainViewController];
    [[mainVCMock expect] pushDetailViewController];
    
    [calloutButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    [mainVCMock verify];
}

@end