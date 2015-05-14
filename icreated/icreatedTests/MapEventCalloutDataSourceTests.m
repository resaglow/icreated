//
//  MapEventCalloutDataSourceTests.m
//  icreated
//
//  Created by Artem Lobanov on 13/05/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MapEventCalloutDataSource.h"

@interface MapEventCalloutDataSourceTests : XCTestCase @end

@interface MapEventCalloutDataSource ()
- (void)initCalloutView;
@end

@implementation MapEventCalloutDataSourceTests

- (void)testInitializer {
    CalloutMapView *mapView = [CalloutMapView new];
    MapEventCalloutDataSource *dataSource = [MapEventCalloutDataSource alloc];
    id dataSourceMock = [OCMockObject partialMockForObject:dataSource];
    [[[dataSourceMock expect] andForwardToRealObject] initCalloutView];
    
    dataSource = [dataSource initWithMapView:mapView];
    
    XCTAssertNotNil(dataSource.calloutMapView, @"calloutMapView nil");
    XCTAssertNotNil(dataSource.calloutView, @"calloutView nil, initCalloutView missing?");
    XCTAssertEqualObjects(dataSource.calloutMapView.calloutView, dataSource.calloutView, @"calloutMapView's calloutView incorrectly set");
    [dataSourceMock verify];
}

@end
