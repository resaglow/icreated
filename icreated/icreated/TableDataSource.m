//
//  TableDataSource.m
//  icreated
//
//  Created by Artem Lobanov on 20/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import "TableDataSource.h"

@interface TableDataSource ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *reuseIdentifier;

@end

@implementation TableDataSource

#pragma mark - Initializers

- (id)initWithTableView:(UITableView *)tableView withFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
      andReuseIdenifier:(NSString *)reuseIdentifier
{
    self = [super init];
    
    if (self) {
        self.tableView = tableView;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.fetchedResultsController = fetchedResultsController;
        self.fetchedResultsController.delegate = self;
        
        NSError *error = nil;
        if ((self.fetchedResultsController != nil) && ![self.fetchedResultsController performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        self.reuseIdentifier = reuseIdentifier;
    }
    
    return self;
}

- (BOOL)deleteObject:(id)object {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [context deleteObject:object];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return NO;
    }
    
    return YES;
}

- (NSEntityDescription *)entity
{
    return [[self.fetchedResultsController fetchRequest] entity];
}

#pragma mark - UITableViewDataSource delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    id cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    [self.delegate configureCell:cell withObject:object];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((editingStyle == UITableViewCellEditingStyleDelete)
        && ![self deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]]) {
        abort();
    }
}

#pragma mark - UITableViewDataDelegate delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate selectedObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

@end
