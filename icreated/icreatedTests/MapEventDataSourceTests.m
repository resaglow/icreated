//
//  MapEventDataSourceTests.m
//  icreated
//
//  Created by Artem Lobanov on 09/05/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import <RestKit/RestKit.h>
//#import <RestKit/Testing.h>
#import <OCMock/OCMock.h>
#import "MapEventDataSource.h"


@interface MapEventDataSourceTests : XCTestCase
@property (nonatomic, strong) MapEventDataSource *dataSource;
@end

@implementation MapEventDataSourceTests

- (void)testInitializer {
    MKMapView *mapView = [MKMapView new];
    
    self.dataSource = [[MapEventDataSource alloc] initWithMapView:mapView];
    
    XCTAssertEqualObjects(self.dataSource.mapView, mapView, @"mapView not set correctly");
    XCTAssertEqualObjects(self.dataSource.mapView.delegate, self.dataSource, @"mapView not set correctly");
    XCTAssertNotNil(self.dataSource.timer);
}


- (void)testRefreshMapCalled {
    MKMapView *mapView = [MKMapView new];
    self.dataSource = [MapEventDataSource alloc];
    id dataSourceMockk = [OCMockObject partialMockForObject:self.dataSource];
    [[dataSourceMockk expect] refreshMap];
    [[dataSourceMockk expect] refreshMap];
    
    self.dataSource = [self.dataSource initWithMapView:mapView];
    
    [self.dataSource startTimer];
    NSDate *runUntil = [NSDate dateWithTimeIntervalSinceNow:11.0];
    [[NSRunLoop currentRunLoop] runUntilDate:runUntil];
 
    [dataSourceMockk verify];
}

@end
