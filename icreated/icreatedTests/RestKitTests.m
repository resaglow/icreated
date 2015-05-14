//
//  RestKitTests.m
//  icreated
//
//  Created by Artem Lobanov on 13/05/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>
#import <ISO8601DateFormatterValueTransformer.h>
#import "RestKitInitializer.h"
#import "Event.h"
#import "RestKitInitializer+eventMapping.h"

@interface RestKitTests : XCTestCase
@property (nonatomic, strong) RKEntityMapping *eventMapping;
@property (nonatomic, strong) RKEntityMapping *userMapping;
@property (nonatomic, strong) RKManagedObjectStore *managedObjectStore;
@property (nonatomic, strong) NSNumber *fixtureEventId;
@property (nonatomic, strong) NSDate *fixtureEventDate;
@property (nonatomic, strong) NSString *fixtureUserName;
@end

@implementation RestKitTests

- (void)setUp {
    [super setUp];
    
    NSBundle *testTargetBundle = [NSBundle bundleWithIdentifier:@"pispbsu.icreatedTests"];
    [RKTestFixture setFixtureBundle:testTargetBundle];

    self.managedObjectStore = [RKTestFactory managedObjectStore];
    
    self.eventMapping = [RKEntityMapping mappingForEntityForName:@"Event" inManagedObjectStore:self.managedObjectStore];
    [self.eventMapping addAttributeMappingsFromDictionary:@{@"EventId": @"eventId",
                                                        @"Description": @"desc",
                                                          @"EventDate": @"date",
                                                           @"Latitude": @"latitude",
                                                          @"Longitude": @"longitude"}];
    self.eventMapping.identificationAttributes = @[@"eventId"];
    
    self.fixtureEventId = @1101;
    
    RKISO8601DateFormatter *formatter = [RKISO8601DateFormatter new];
    formatter.includeTime = YES, formatter.timeZone = nil;
    self.fixtureEventDate = [formatter dateFromString:@"2015-05-11 16:38:05Z"];
    
    
    self.userMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:self.managedObjectStore];
    [self.userMapping addAttributeMappingsFromDictionary:@{/*@"UserId": @"userId",*/
                                                           @"UserName": @"userName"/*,
                                                              @"Photo": @"photo"*/}];
    self.userMapping.identificationAttributes = @[@"userName"];
    
    self.fixtureUserName = @"sample10";
}

- (void)tearDown {
    self.eventMapping = nil;
    self.userMapping = nil;
    self.managedObjectStore = nil;
    [super tearDown];
}

#pragma mark - Event RestKit tests

- (void)testMappingOfEventWithValue {
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"eventFixture.json"];
    
    RKMappingTest *test = [RKMappingTest testForMapping:self.eventMapping
                                           sourceObject:parsedJSON destinationObject:nil];
    
    test.managedObjectContext = self.managedObjectStore.persistentStoreManagedObjectContext;
    
    
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"EventId"
                                                                     destinationKeyPath:@"eventId"
                                                                                  value:self.fixtureEventId]];
    XCTAssertTrue([test evaluate], @"RestKiting");
}


- (void)testMappingOfEventToExplicitObject {
    NSManagedObject *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                           inManagedObjectContext:self.managedObjectStore.persistentStoreManagedObjectContext];
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"eventFixture.json"];
    RKMappingTest *test = [RKMappingTest testForMapping:self.eventMapping sourceObject:parsedJSON destinationObject:event];
    
    test.managedObjectContext = self.managedObjectStore.persistentStoreManagedObjectContext;
    
    // Check the value as well as the keyPaths
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"EventId"
                                                                     destinationKeyPath:@"eventId"
                                                                                  value:self.fixtureEventId]];
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"EventDate"
                                                                     destinationKeyPath:@"date"
                                                                                  value:self.fixtureEventDate]];
    XCTAssertTrue([test evaluate]);
}

- (void)testEventIdentification {
    NSNumber *testEventId = @1234;
    
    NSDictionary *articleRepresentation = @{ @"EventId": testEventId, @"Description": @"Test event description" };
    RKMappingTest *mappingTest = [RKMappingTest testForMapping:self.eventMapping sourceObject:articleRepresentation destinationObject:nil];
    
    // Configure Core Data
    mappingTest.managedObjectContext = self.managedObjectStore.persistentStoreManagedObjectContext;
    
    // Create an object to match our criteria
    NSManagedObject *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                           inManagedObjectContext:self.managedObjectStore.persistentStoreManagedObjectContext];
    [event setValue:testEventId forKey:@"eventId"];
    
    // Let the test perform the mapping
    [mappingTest performMapping];
    
    XCTAssertEqualObjects(event, mappingTest.destinationObject, @"Expected to match the Event, but did not");
}

#pragma mark - User RestKit tests

- (void)testMappingOfUserWithValue {
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"userFixture.json"];
    RKMappingTest *test = [RKMappingTest testForMapping:self.userMapping
                                           sourceObject:parsedJSON destinationObject:nil];
    test.managedObjectContext = self.managedObjectStore.persistentStoreManagedObjectContext;
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"UserName"
                                                                     destinationKeyPath:@"userName"
                                                                                  value:self.fixtureUserName]];
    XCTAssertTrue([test evaluate], @"RestKiting");
}

- (void)testUserIdentification {
    NSString *testUserName = @"testUserName";
    
    NSDictionary *articleRepresentation = @{ @"UserId": @111, @"UserName": testUserName };
    RKMappingTest *mappingTest = [RKMappingTest testForMapping:self.userMapping sourceObject:articleRepresentation destinationObject:nil];

    mappingTest.managedObjectContext = self.managedObjectStore.persistentStoreManagedObjectContext;

    NSManagedObject *event = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                           inManagedObjectContext:self.managedObjectStore.persistentStoreManagedObjectContext];
    [event setValue:testUserName forKey:@"userName"];
    
    [mappingTest performMapping];
    
    XCTAssertEqualObjects(event, mappingTest.destinationObject, @"Expected to match the User, but did not");
}

@end
