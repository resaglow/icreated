//
//  CoreDataTests.m
//  icreated
//
//  Created by Artem Lobanov on 19/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#import "objc/runtime.h"
#import "Event.h"

@interface CoreDataTests : XCTestCase
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSString *tempFilePath;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSString *storeName;
@end

@implementation CoreDataTests

- (void)setUp {
    [super setUp];
    
    // Setup entity name
    self.entityName = @"Event";
    
    // Setup model and coordinator
    NSURL *urlToModel = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Model" ofType:@"momd"]];
    self.model = [[NSManagedObjectModel alloc] initWithContentsOfURL:urlToModel];
    self.coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
    
    // Create the temp directory
    self.storeName = @"test.sqlite";
    self.tempFilePath = [NSTemporaryDirectory() stringByAppendingString:@"UnitTests"];
    self.fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if (![self.fileManager fileExistsAtPath:self.tempFilePath]) {
        [self.fileManager createDirectoryAtPath:self.tempFilePath
                    withIntermediateDirectories:YES
                                     attributes:nil
                                          error:&error];
    }
    
    // Remove the existing store path
    [self clearTempDBs];
    
    // Add the new persistent store
    [self.coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                   configuration:nil
                                             URL:[NSURL fileURLWithPath:
                                                  [self.tempFilePath stringByAppendingPathComponent:self.storeName]]
                                         options:nil error:&error];
    
    // Setup the context
    self.context = [[NSManagedObjectContext alloc] init];
    [self.context setPersistentStoreCoordinator:self.coordinator];
    
}

- (void)tearDown {
    self.model = nil;
    self.coordinator = nil;
    self.context = nil;
    [self clearTempDBs];
    self.tempFilePath = nil;
    self.fileManager = nil;
    self.storeName = nil;
    self.entityName = nil;
    [super tearDown];
}

- (void)clearTempDBs {
    NSError *error;
    NSArray *possibleStoreFileStrings = @[[self.tempFilePath stringByAppendingPathComponent:self.storeName],
                                          [self.tempFilePath stringByAppendingPathComponent:
                                           [NSString stringWithFormat:@"%@-shm", self.storeName]],
                                          [self.tempFilePath stringByAppendingPathComponent:
                                           [NSString stringWithFormat:@"%@-wal", self.storeName]]];
    
    for (NSInteger i = 0; i < possibleStoreFileStrings.count; i++) {
        if ([self.fileManager fileExistsAtPath:possibleStoreFileStrings[i]]) {
            [self.fileManager removeItemAtPath:possibleStoreFileStrings[i] error:&error];
        }
    }
}

- (NSDictionary *)getPropertiesWithTypes:(NSString *)objectName {
    NSMutableDictionary *returnDictionary = [NSMutableDictionary new];
    id LenderClass = NSClassFromString(objectName);
    if (LenderClass == nil) {
        return returnDictionary;
    }
    
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(LenderClass, &outCount);
    for (int i = 0; i < outCount; i++) {
        // Retreive all of the raw information
        objc_property_t property = properties[i];
        NSString *propStr = [[NSString alloc] initWithCString:property_getName(property) encoding:NSASCIIStringEncoding];
        const char *type = property_getAttributes(property);
        NSString *typeString = [NSString stringWithUTF8String:type];
        NSArray *attributes = [typeString componentsSeparatedByString:@","];
        NSString *typeAttribute = [attributes objectAtIndex:0];
        
        // Retrieve the type
        NSString *propType = nil;
        if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1) {
            // Turns @"NSDate" into NSDate
            propType = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length] - 4)];
        }
        
        [returnDictionary setValue:propType forKey:propStr];
    }
    
    return returnDictionary;
}


- (void)testEventDescriptionAttributeTest {
    NSDictionary *properties = [self getPropertiesWithTypes:self.entityName];
    NSString *fieldName;
    NSString *dataType;
    
    fieldName = @"desc";
    dataType = @"NSString";
    
    XCTAssertTrue([properties.allKeys containsObject:fieldName], @"Event object doesn't contain field: %@", fieldName);
    XCTAssertTrue([[properties valueForKey:fieldName] isEqualToString:dataType], @"%@ is not of type: %@", fieldName, dataType);
}


- (void)testInsertAndDelete {
    Event *newEvent = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                    inManagedObjectContext:self.context];
    
    NSString *description = @"test Event desc";
    newEvent.desc = description;
    
    [self.context insertObject:newEvent];
    NSError *saveError = nil;
    [self.context save:&saveError];
    
    self.context = [[NSManagedObjectContext alloc] init];
    [self.context setPersistentStoreCoordinator:self.coordinator];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
    [request setPredicate:[NSPredicate predicateWithFormat:@"desc == %@", description]];
    NSError *fetchError = nil;
    NSArray *items = [self.context executeFetchRequest:request error:&fetchError];
    
    XCTAssertNil(saveError, @"There was an error trying to save the data while inserting");
    XCTAssertNil(fetchError, @"There was an error trying to fetch the data while inserting");
    XCTAssertEqual(items.count, 1, @"The insert failed");
    
    [self.context deleteObject:items.firstObject];
    [self.context save:&saveError];
    self.context = [[NSManagedObjectContext alloc] init];
    [self.context setPersistentStoreCoordinator:self.coordinator];
    NSArray *deletedItems = [self.context executeFetchRequest:request error:&fetchError];
    
    XCTAssertNil(saveError, @"There was an error trying to save the data while deleting");
    XCTAssertNil(fetchError, @"There was an error trying to fetch the data deleting");
    XCTAssertEqual(deletedItems.count, 0, @"The delete failed");
}

@end