//
//  TableDataSource.m
//  icreated
//
//  Created by Artem Lobanov on 20/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import "TableDataSource.h"
#import "Event.h"

@interface TableDataSource ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *reuseIdentifier;

@end

@implementation TableDataSource

#pragma mark - Initializers

- (id)initWithTableView:(UITableView *)tableView withFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
         reuseIdenifier:(NSString *)reuseIdentifier
{
    self = [super init];
    
    if (self) {
        self.tableView = tableView;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.fetchedResultsController = fetchedResultsController;
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

- (NSEntityDescription *)entity {
    return [[self.fetchedResultsController fetchRequest] entity];
}

#pragma mark - UITableViewDataSource delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionsCount = [[self.fetchedResultsController sections] count];
    NSLog(@"%ld sections", (long)sectionsCount);
    return sectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    NSLog(@"%lu rows in section #%ld", (unsigned long)[sectionInfo numberOfObjects], (long)section);
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    id cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    [self.delegate configureCell:cell withObject:object];
    return cell;
}

#pragma mark - UITableViewDataDelegate delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(selectedObject:)]) {
        [self.delegate selectedObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
}

@end