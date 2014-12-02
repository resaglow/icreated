//
//  EventUpdater.m
//  icreated
//
//  Created by Artem Lobanov on 20/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "EventUpdater.h"

@interface EventUpdater ()

@end

@implementation EventUpdater

static NSManagedObjectContext *managedObjectContext;
static NSMutableArray *updatedEventsArray;
static NSFetchedResultsController *fetchedResultsController;

+ (void)setManagedObjectContext:(NSManagedObjectContext *)context {
    managedObjectContext = context;
}

+ (NSFetchedResultsController *)fetchedResultsController {
    if (!managedObjectContext) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = appDelegate.managedObjectContext;
    }
    
    if (fetchedResultsController) {
        return fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event"
                                              inManagedObjectContext:managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"eventId" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                   managedObjectContext:managedObjectContext
                                                                     sectionNameKeyPath:nil
                                                                              cacheName:nil];
    
    
    return fetchedResultsController;
}

+ (void)getEventsWithCompletionHandler:(void (^)(void))handler {
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      @"http://customer87-001-site1.myasp.net/api/Events"]];
    
    // Standard authRequired code
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//    if (token == nil) {
//        handler();
//        return;
//    }
//    
//    NSString *tokenToSend = [@"Bearer " stringByAppendingString:token];
//    [theRequest addValue:tokenToSend forHTTPHeaderField:@"Authorization"];
    
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if (error != nil) {
            NSLog(@"BUG: Connection fault, error = %@", error);
            handler();
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            NSLog(@"BUG: Server fault, status code = %ld", (long)httpResponse.statusCode);
            handler();
            return;
        }
        
        NSError *error2 = nil;
        updatedEventsArray = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:data
                                                                               options:NSJSONReadingMutableLeaves
                                                                                 error:&error2];
        NSLog(@"Started updateding moc");
        [self updateManagedObjectContext];
        
        // Somehow "костыль" because of dead server response
        // Приходит, когда сервер упал, но все равно присылает 200
        if ([updatedEventsArray isEqual: @{ @"Message": @"An error has occurred." }]) {
            NSLog(@"BUG: Server fault, however 200 status code (Message : An error has occurred)");
            updatedEventsArray = (NSMutableArray *)@[];
        }
        else {
            NSLog(@"Events update OK");
        }
        
        handler();
            
        // TODO Write updatedEventsArray into a DB
        
        
    }];
}


+ (void)updateManagedObjectContext {
    // (Temp) Delete all the entries from the context
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Event"
                                        inManagedObjectContext:managedObjectContext]];
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    for (id event in result) {
        [managedObjectContext deleteObject:event];
    }
    
    // Add all the new entries in the context
    for (id eventDict in updatedEventsArray) {
        Event *newEvent = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                                 inManagedObjectContext:managedObjectContext];
        
        newEvent.eventId = [eventDict objectForKey:@"EventId"];
        newEvent.date = [eventDict objectForKey:@"EventDate"];
        newEvent.desc = [eventDict objectForKey:@"Description"];
        
        NSString *stringLatitude = [eventDict objectForKey:@"Latitude"];
        NSString *stringLongitude = [eventDict objectForKey:@"Longitude"];
        
        if (stringLatitude == nil || stringLongitude == nil) {
            NSLog(@"Nil latitude/longitude, continuing");
            [managedObjectContext deleteObject:newEvent];
            continue;
        }
        else if ([stringLatitude isEqual:[NSNull null]] || [stringLongitude isEqual:[NSNull null]]) {
            NSLog(@"<null> latitude/longitude from the server, continuing");
            [managedObjectContext deleteObject:newEvent];
            continue;
        }
        
        double latitude = [NSDecimalNumber decimalNumberWithString:stringLatitude].doubleValue;
        double longitude = [NSDecimalNumber decimalNumberWithString:stringLongitude].doubleValue;
        
        if (!(latitude > -90 && latitude < 90 && longitude > -180 && longitude < 180)) {
            NSLog(@"BUG: Coordinates out of the range, continuing");
            [managedObjectContext deleteObject:newEvent];
            continue;
        }
        else {
            NSLog(@"Valid coordinates, latitude = %f, longitude = %f", latitude, longitude);
        }
        
        newEvent.latitude = [NSNumber numberWithDouble:latitude];
        newEvent.longitude = [NSNumber numberWithDouble:longitude];
        
        
        CLLocation *eventLocation = [[CLLocation alloc] initWithLatitude: latitude longitude: longitude];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:eventLocation
                       completionHandler:^(NSArray *placemarks, NSError *error) {
                           newEvent.place = [NSKeyedArchiver archivedDataWithRootObject:[placemarks objectAtIndex:0]];
                       }];
        
        
    }
    
    // Save context
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error! %@", error);
    }
}


@end
