//
//  TableDataSourceTests.m
//  icreated
//
//  Created by Artem Lobanov on 20/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "TableDataSource.h"

@interface TableDataSourceTests : XCTestCase

@property (nonatomic, strong) TableDataSource *tableDataSource;
@property (nonatomic, strong) id tableView;
@property (nonatomic, strong) id fetchedResultsController;
@property (nonatomic, strong) NSString *defaultIdentifier;

@end

@implementation TableDataSourceTests

- (void)setUp {
    [super setUp];
    self.tableView = [OCMockObject mockForClass:[UITableView class]];
    self.fetchedResultsController = [OCMockObject mockForClass:[NSFetchedResultsController class]];
    [[self.tableView expect] setDataSource:OCMOCK_ANY];
    [[self.tableView expect] setDelegate:OCMOCK_ANY];
    [[self.fetchedResultsController expect] setDelegate:OCMOCK_ANY];
    [[[self.fetchedResultsController stub] andReturnValue:@YES] performFetch:[OCMArg anyObjectRef]];
    self.defaultIdentifier = @"testEventCell";
    self.tableDataSource =
    [[TableDataSource alloc] initWithTableView:self.tableView withFetchedResultsController:self.fetchedResultsController
                                reuseIdenifier:self.defaultIdentifier];
}

- (void)tearDown {
    self.tableView = nil;
    self.fetchedResultsController = nil;
    self.defaultIdentifier = nil;
    self.tableDataSource = nil;
    [super tearDown];
}

- (void)testInitializer {
    // Given
    NSString *reusableId = @"testEventCell";
    TableDataSource *dataSource;
    UITableView *tableView = [UITableView new];
    id fetchedResultsController = OCMClassMock([NSFetchedResultsController class]);
    __block id FRCDelegate = nil;
    [[fetchedResultsController stub] setDelegate:[OCMArg checkWithBlock:^BOOL(id obj) {
        FRCDelegate = obj;
        return YES;
    }]];
    [[[fetchedResultsController stub] andReturnValue:@YES] performFetch:[OCMArg anyObjectRef]];
    
    // When
    dataSource = [[TableDataSource alloc] initWithTableView:tableView withFetchedResultsController:fetchedResultsController
                                             reuseIdenifier:reusableId];
    
    // Then
    XCTAssertEqualObjects(reusableId, dataSource.reuseIdentifier, @"TableDataSource's reuseIdentifier not initialized correctly");
    XCTAssertEqualObjects(tableView, dataSource.tableView, @"TableDataSource's tableView not initialized correctly");
    XCTAssertEqualObjects(fetchedResultsController, dataSource.fetchedResultsController, @"TableDataSource's FRC not initialized correctly");
    XCTAssertEqualObjects(dataSource, dataSource.tableView.dataSource, @"TableDataSource's dataSource not initialized correctly");
}

- (void)testTableViewNumberOfSections {
    NSArray *sections = @[@1, @2, @3];

    [[[self.fetchedResultsController stub] andReturn:sections] sections];

    XCTAssertEqual([self.tableDataSource numberOfSectionsInTableView:self.tableView], sections.count,
                   @"Wrong num of sections");
}



- (void)testTableViewNumberOfRows {
    id mockedSection = [OCMockObject mockForProtocol:@protocol(NSFetchedResultsSectionInfo)];
    NSUInteger numberOfObjects = 10;
    [[[mockedSection stub] andReturnValue:OCMOCK_VALUE(numberOfObjects)] numberOfObjects];
    NSArray *sections = @[mockedSection];

    [[[self.fetchedResultsController stub] andReturn:sections] sections];

    XCTAssertEqual([self.tableDataSource tableView:self.tableView
                                                numberOfRowsInSection:0],
                   numberOfObjects,
                   @"Should return the correct number of rows");
}

- (void)testItemAtIndexPath {
    id cell = @"CellValue";
    id returnedCell;
    NSIndexPath *myIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    id delegate = [OCMockObject mockForProtocol:@protocol(TableDataSourceDelegate)];
    id myObject = @"FOO";
    self.tableDataSource.delegate = delegate;
    [[[self.fetchedResultsController stub] andReturn:myObject] objectAtIndexPath:myIndexPath];
    [[[self.tableView stub] andReturn:cell] dequeueReusableCellWithIdentifier:self.defaultIdentifier
                                                                 forIndexPath:myIndexPath];
    [[delegate expect] configureCell:cell withObject:myObject];

    returnedCell = [self.tableDataSource tableView:self.tableView cellForRowAtIndexPath:myIndexPath];

    XCTAssertEqual(returnedCell, @"CellValue", @"Should return an equal cell");
    [delegate verify];
}


@end