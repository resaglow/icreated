//
//  NewsStandViewController.m
//  icreated
//
//  Created by Artem Lobanov on 20/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "NewsStandViewController.h"

@interface NewsStandViewController ()

@property (strong, nonatomic) IBOutlet UITableView *newsStand;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation NewsStandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        [self.newsStand reloadData];
        NSLog(@"Reloading data called");
        
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - UITableView Delegate and Datasource method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"Calculating number of sections");
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"eventsArray.count = %lu", (unsigned long)[EventUpdater eventsArray].count);
    return [EventUpdater eventsArray].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Setting smth at indexPath");
    
    static NSString *CellIdentifier = @"eventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Is it necessary? Can reusable cell not be dequeued?
    // [There are some problems without it]
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"eventCell"];
    }
    
    NSDictionary *dict = [[EventUpdater eventsArray] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dict objectForKey:@"Description"];
    cell.detailTextLabel.text = [dict objectForKey:@"EventDate"];
    
    return cell;
}

@end
