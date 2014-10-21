//
//  MapViewController.h
//  icreated
//
//  Created by Artem Lobanov on 17/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "EventAnnotation.h"
#import "EventUpdater.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

- (void)refreshMap;

@end
