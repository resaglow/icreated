//
//  MapTests.m
//  icreated
//
//  Created by Artem Lobanov on 07/05/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Specta.h>
#import "MainScreenTests.h"

@interface MapTests : MainScreenTests @end

@implementation MapTests

- (void)setUp {
    [super setUp];
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

//- (void)testEventDetailFromMap {
//    UIButton *calloutButton = (UIButton *)self.mainViewController.mapCalloutDataSource.calloutView.contentView;
//    [calloutButton sendActionsForControlEvents:UIControlEventTouchUpInside];
//}

//SpecBegin(EventDetail) {




@end
