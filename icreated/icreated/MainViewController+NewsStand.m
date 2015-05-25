//
//  MainViewController+NewsStand.m
//  icreated
//
//  Created by Artem Lobanov on 29/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "MainViewController+NewsStand.h"
#import <ISO8601DateFormatterValueTransformer/RKISO8601DateFormatter.h>
#import <SORelativeDateTransformer.h>
#import "Event.h"

@implementation MainViewController (NewsStand)

- (void)initNewsStand {
    self.newsStand.contentInset = UIEdgeInsetsMake(4, 0, 4, 0);
    self.newsStandDataSource =
        [[TableRefreshDataSource alloc] initWithTableView:self.newsStand
                                 fetchedResultsController:self.eventUpdater.fetchedResultsController
                                           reuseIdenifier:@"eventCell"];
    self.newsStandDataSource.delegate = self;
}

- (void)configureCell:(UITableViewCell *)cell withObject:(id)object {
    Event *event = (Event *)object;
    
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:kDateTimeLabelTag];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    label.text = [[SORelativeDateTransformer registeredTransformer] transformedValue:event.date];
    RKISO8601DateFormatter *formatter = [RKISO8601DateFormatter new];
    formatter.includeTime = YES, formatter.timeZone = nil;
    label.text = [formatter stringFromDate:event.date];
    
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
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:kImageViewTag];
    UIImage *scaledImage = [imageView.image scaleToWidth:imageView.frame.size.width];
//    UIImage *scaledImage = [imageView.image scaleToHeight:imageView.frame.size.height];
    imageView.image = scaledImage;
}

- (void)refreshingMethod:(void (^)(void))handler {
    [self.eventUpdater getEventsWithSuccess:^void(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) { handler(); }
                                    failure:^void(RKObjectRequestOperation *operation, NSError *error) {
                                        NSLog(@"Error getting events: %@", error);
                                        [self.newsStandDataSource.refreshControl endRefreshing];
                                    }];
}


@end
