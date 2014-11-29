//
//  MainViewController+NewsStand.m
//  icreated
//
//  Created by Artem Lobanov on 29/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "MainViewController+NewsStand.h"
#import "NSDate+RFC1123.h"

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
    static NSString *CellIdentifier = @"eventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Event *event = [[EventUpdater fetchedResultsController] objectAtIndexPath:indexPath];
    cell.textLabel.text = event.desc;
    cell.detailTextLabel.text = [event.date RFC1123String];
    
    return cell;
}

@end
