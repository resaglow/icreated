//
//  TableDataSource.h
//  icreated
//
//  Created by Artem Lobanov on 20/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@protocol TableDataSourceDelegate <NSObject>
- (void)configureCell:(UITableViewCell *)cell withObject:(id)object;
@optional
- (void)selectedObject:(id)object;
@end

@interface TableDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UIViewController<TableDataSourceDelegate> *delegate;
@property (readonly, strong) NSFetchedResultsController *fetchedResultsController;
@property (readonly, strong) UITableView *tableView;
@property (readonly, copy) NSString *reuseIdentifier;
@property (readonly) NSEntityDescription *entity;

- (id)initWithTableView:(UITableView *)tableView withFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
         reuseIdenifier:(NSString *)reuseIdentifier;

@end
