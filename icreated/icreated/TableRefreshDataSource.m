//
//  TableRefreshDataSource.m
//  icreated
//
//  Created by Artem Lobanov on 20/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import "TableRefreshDataSource.h"
#import "EventUpdater.h"

@implementation TableRefreshDataSource

- (id)initWithTableView:(UITableView *)tableView fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
         reuseIdenifier:(NSString *)reuseIdentifier
{
    self = [super initWithTableView:tableView withFetchedResultsController:fetchedResultsController reuseIdenifier:reuseIdentifier];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];

    self.refreshControl = [[UIRefreshControl alloc] init];

    [self.refreshControl addTarget:self
                            action:@selector(refreshTableView)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.fetchedResultsController performFetch:nil];
    
    [self.tableView addSubview:self.refreshControl];
    
    [self.tableView reloadData];
    
    return self;
}

- (void)refreshTableView {
    [self.delegate refreshingMethod:^(void) {
        [self.fetchedResultsController performFetch:nil];
        
        [self.tableView reloadData];
        NSLog(@"Newsstand reloaded");
        
        [self.refreshControl endRefreshing];
    }];
    
}

@end
