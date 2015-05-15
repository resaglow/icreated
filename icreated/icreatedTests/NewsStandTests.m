//
//  NewsStandTests.m
//  icreated
//
//  Created by Artem Lobanov on 07/05/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import "MainScreenTests.h"

@interface NewsStandTests : MainScreenTests

@end

@implementation NewsStandTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSaveButtonInitializedTest {
    XCTAssertNotNil(self.mainViewController.newsStandDataSource, @"Data source is not initialized");
}

//- (void)testConfigureCellTest {
//    UITableViewCell *cell = [self.mainViewController.newsStand dequeueReusableCellWithIdentifier:@"eventCell"];
//    
//    [self.mainViewController configureCell:cell withObject:self.event];
//    
//    UILabel *eventDescriptionLabel = (UILabel *)[cell viewWithTag:1];
//    UILabel *eventDateLabel = (UILabel *)[cell viewWithTag:2];
//    XCTAssertEqualObjects(eventDescriptionLabel.text, [self.event desc], @"Description string not set correctly for the event cell");
//    
//    RKISO8601DateFormatter *formatter = [RKISO8601DateFormatter new];
//    formatter.includeTime = YES, formatter.timeZone = nil;
//    NSString *dateString = [formatter stringFromDate:[self.event date]];
//    XCTAssertEqualObjects(eventDateLabel.text, dateString, @"Date string not set correctly for the event cell");
//}

@end
