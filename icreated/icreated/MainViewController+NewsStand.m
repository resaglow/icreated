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

@interface MainViewController ()
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@end

@implementation MainViewController (NewsStand)

- (void)initNewsStand {
    self.newsStandDataSource =
        [[TableRefreshDataSource alloc] initWithTableView:self.newsStand
                                 fetchedResultsController:self.eventUpdater.fetchedResultsController
                                           reuseIdenifier:@"eventCell"];
    self.newsStandDataSource.delegate = self;
    
//    CGFloat tableBorderLeft = 20;
//    CGFloat tableBorderRight = 20;
//    
//    CGRect tableRect = self.view.frame;
//    tableRect.origin.x += tableBorderLeft; // make the table begin a few pixels right from its origin
//    tableRect.size.width -= tableBorderLeft + tableBorderRight; // reduce the width of the table
//    self.newsStand.frame = tableRect;
    
}

- (void)configureCell:(UITableViewCell *)cell withObject:(id)object {
    Event *event = (Event *)object;
    
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:1];
    label.text = event.desc;
    
    label = (UILabel *)[cell viewWithTag:2];
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
