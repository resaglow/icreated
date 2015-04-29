//
//  NewsStandTests.m
//  icreated
//
//  Created by Artem Lobanov on 18/04/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MainViewController+NewsStand.h"
#import <RKISO8601DateFormatter.h>

@interface NewsStandTests : XCTestCase
@property (strong, nonatomic) MainViewController *mainViewController;
@property (strong, nonatomic) UIStoryboard *storyboard;
@property id event;
@end

@protocol EventInterface <NSObject>
@property (nonatomic, retain) id date;
@property (nonatomic, retain) id desc;
@end


@implementation NewsStandTests

- (void)setUp {
    [super setUp];
    self.storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
    [self.mainViewController view];
    
    self.event = [OCMockObject mockForProtocol:@protocol(EventInterface)];
    [[[self.event stub] andReturn:[NSDate date]] date];
    [[[self.event stub] andReturn:@"Sample test event"] desc];
}

- (void)tearDown {
    self.mainViewController = nil;
    [super tearDown];
}

- (void)testSaveButtonInitializedTest {
    XCTAssertNotNil(self.mainViewController.newsStandDataSource, @"Data source is not initialized");
}

- (void)testConfigureCellTest {
    UITableViewCell *cell = [self.mainViewController.newsStand dequeueReusableCellWithIdentifier:@"eventCell"];
    
    [self.mainViewController configureCell:cell withObject:self.event];
    
    UILabel *eventDescriptionLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *eventDateLabel = (UILabel *)[cell viewWithTag:2];
    XCTAssertEqualObjects(eventDescriptionLabel.text, [self.event desc], @"Description string not set correctly for the event cell");
    
    RKISO8601DateFormatter *formatter = [RKISO8601DateFormatter new];
    formatter.includeTime = YES, formatter.timeZone = nil;
    NSString *dateString = [formatter stringFromDate:[self.event date]];
    XCTAssertEqualObjects(eventDateLabel.text, dateString, @"Date string not set correctly for the event cell");
}



@end
