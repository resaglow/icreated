//
//  TableRefreshDataSource.h
//  icreated
//
//  Created by Artem Lobanov on 20/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TableDataSource.h"

@protocol TableRefreshDataSourceDelegate <NSObject>
- (void)refreshingMethod:(void (^)(void))handler;
@end

@interface TableRefreshDataSource : TableDataSource

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, weak) UIViewController<TableDataSourceDelegate, TableRefreshDataSourceDelegate> *delegate;

- (id)initWithTableView:(UITableView *)tableView fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
         reuseIdenifier:(NSString *)reuseIdentifier;

@end
