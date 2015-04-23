//
//  UserUpdater1.m
//  icreated
//
//  Created by Artem Lobanov on 23/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import "UserUpdater1.h"

@implementation UserUpdater1

- (void)getUserInfoWithCompletionhandler:(void (^)(void))handler {
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:[kServerUrl stringByAppendingString:@"/api/Account/UserInfo"]]];
    
    // Standard authRequired code
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token == nil) {
        NSLog(@"WAT: User info request while logged out");
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
         NSDictionary *info = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data
                                                                              options:NSJSONReadingMutableLeaves
                                                                                error:&error2];
         NSLog(@"USER INFO: %@", info);
         
         //         NSLog(@"Started updateding MOC");
         //         [self updateManagedObjectContext];
         
         if (handler) handler();
     }];
}

- (void)getUsersOfType:(UserType)userType byUserId:(NSInteger)userId
           WithSuccess:(RestKitSuccessHandler)successHandler
               failure:(RestKitFailureHandler)failureHandler {
    [self getTokenWithSuccess:^(NSString *tokenToSend) {
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:tokenToSend];
    } failure:^{
        NSLog(@"Couldn't get token");
    }];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/friends/my/m" parameters:nil
                                              success:successHandler failure:failureHandler];
}


@end
