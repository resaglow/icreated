//
//  UserUpdater.m
//  icreated
//
//  Created by Artem Lobanov on 19/12/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "UserUpdater.h"

@implementation UserUpdater

static NSManagedObjectContext *managedObjectContext;
static NSMutableArray *friendsArray;
static NSFetchedResultsController *fetchedResultsController;

+ (void)setManagedObjectContext:(NSManagedObjectContext *)context {
    managedObjectContext = context;
}

+ (NSFetchedResultsController *)fetchedResultsController {
    if (!managedObjectContext) {
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        self.managedObjectContext = appDelegate.managedObjectContext;
    }
    
    if (fetchedResultsController) {
        return fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userId" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                   managedObjectContext:managedObjectContext
                                                                     sectionNameKeyPath:nil
                                                                              cacheName:nil];
    
    
    return fetchedResultsController;
}




+ (void)getUsersOfType:(UserType)userType byUserId:(NSInteger)userId completionhandler:(void (^)(void))handler {
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      @"http://nbixman-001-site1.myasp.net/api/friends/my/m"]];
    
    // Standard authRequired code
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token == nil) {
        NSLog(@"WAT: Users request while logged out");
        if (handler) handler();
        return;
    }

    NSString *tokenToSend = [@"Bearer " stringByAppendingString:token];
    [theRequest addValue:tokenToSend forHTTPHeaderField:@"Authorization"];
    
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error != nil) {
             NSLog(@"BUG: Connection fault, error = %@", error);
             if (handler) handler();
             return;
         }
         
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         if (httpResponse.statusCode != 200) {
             NSLog(@"BUG: Server fault, status code = %ld", (long)httpResponse.statusCode);
             if (handler) handler();
             return;
         }
         
         NSError *error2 = nil;
         friendsArray = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableLeaves
                                                                                  error:&error2];
         NSLog(@"FRIENDS: %@", friendsArray);
         
//         NSLog(@"Started updateding MOC");
//         [self updateManagedObjectContext];
         
         // Somehow "костыль" because of dead server response
         // Приходит, когда сервер упал, но все равно присылает 200
         if ([friendsArray isEqual: @{ @"Message": @"An error has occurred." }]) {
             NSLog(@"BUG: Server fault, however 200 status code (Message : An error has occurred)");
             friendsArray = (NSMutableArray *)@[];
         }
         else {
             NSLog(@"Users update OK");
         }
         
         if (handler) handler();
         
         
     }];
}


@end
