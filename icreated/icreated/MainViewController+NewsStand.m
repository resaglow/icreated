//
//  MainViewController+NewsStand.m
//  icreated
//
//  Created by Artem Lobanov on 29/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "MainViewController+NewsStand.h"
#import "NSDate+RFC1123.h"
#import "SORelativeDateTransformer.h"
#import "Event.h"

@implementation MainViewController (NewsStand)

- (void)initNewsStand {
    self.newsStandDataSource =
        [[TableRefreshDataSource alloc] initWithTableView:self.newsStand
                                 fetchedResultsController:self.eventUpdater.fetchedResultsController
                                           reuseIdenifier:@"eventCell"];
    self.newsStandDataSource.delegate = self;
    
}

- (void)configureCell:(UITableViewCell *)cell withObject:(id)object {
    Event *event = (Event *)object;
    
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:1];
    label.text = event.desc;
    
    label = (UILabel *)[cell viewWithTag:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    label.text = [[SORelativeDateTransformer registeredTransformer] transformedValue:event.date];
    label.text = [event.date RFC1123String];
    
//    CLPlacemark* placemark;
//    label = (UILabel *)[cell viewWithTag:3];
//    if (event.place) {
//        placemark = [NSKeyedUnarchiver unarchiveObjectWithData:event.place];
////        NSLog(@"Placemark is: %@", placemark);
//        if (placemark.country) {
//            label.text = placemark.country;
//            NSLog(@"Country is: %@", placemark.country);
//        }
//        else {
//            label.text = @"<unknown>";
//            NSLog(@"Unknown country, placemark.country = nil");
//        }
//    }
//    else {
//        label.text = @"<nil>";
//        NSLog(@"event.place not set, probably placemark was = nil while updating");
//    }
}

- (void)refreshingMethod:(void (^)(void))handler {
    RestKitSuccessHandler successHandler = ^void(RKObjectRequestOperation *operation,
                                                 RKMappingResult *mappingResult) { handler(); };
    RestKitFailureHandler failureHandler = ^void(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error getting events: %@", error);
        [self.newsStandDataSource.refreshControl endRefreshing];
    };
    [self.eventUpdater getEventsWithSuccess:successHandler failure:failureHandler];
}


@end
