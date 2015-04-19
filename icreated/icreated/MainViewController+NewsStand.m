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

@implementation MainViewController (NewsStand)

- (void)viewDidLoadNewsStand {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    [[EventUpdater fetchedResultsController] performFetch:nil];
    
    [self.newsStand setDataSource:self];
    [self.newsStand setDelegate:self];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshNewsStand)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.newsStand addSubview:self.refreshControl];
}

- (void)refreshNewsStand {
    [EventUpdater getEventsWithCompletionHandler:^(void) {
        [[EventUpdater fetchedResultsController] performFetch:nil];
        
        [self.newsStand reloadData];
        NSLog(@"Newsstand reloaded");
        
        [self.refreshControl endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger secNum = [[[EventUpdater fetchedResultsController] sections] count];
    NSLog(@"%ld sections", (long)secNum);
    return secNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> secInfo = [[[EventUpdater fetchedResultsController] sections] objectAtIndex:section];
    NSLog(@"%lu rows", (unsigned long)[secInfo numberOfObjects]);
    return [secInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    
    Event *event = [[EventUpdater fetchedResultsController] objectAtIndexPath:indexPath];
    
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:1];
    label.text = event.desc;
    
    label = (UILabel *)[cell viewWithTag:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    label.text = [[SORelativeDateTransformer registeredTransformer] transformedValue:event.date];
//    label.text = [event.date RFC1123String];
    
    label = (UILabel *)[cell viewWithTag:3];
    if (event.place) {
        CLPlacemark* placemark = [NSKeyedUnarchiver unarchiveObjectWithData:event.place];
//        NSLog(@"Placemark is: %@", placemark);
        if (placemark.country) {
            label.text = placemark.country;
            NSLog(@"Country is: %@", placemark.country);
        }
        else {
            NSLog(@"Unknown country");
        }
    }
    else {
        NSLog(@"event.place not set, probably placemark was = nil while updating");
    }
    
    return cell;
}

@end
