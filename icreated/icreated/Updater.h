//
//  Updater.h
//  icreated
//
//  Created by Artem Lobanov on 21/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import <UIKit/UIKit.h>

typedef void (^RestKitSuccessHandler)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult);
typedef void (^RestKitFailureHandler)(RKObjectRequestOperation *operation, NSError *error);

@interface Updater : NSObject

- (NSFetchedResultsController *)getFetchedResultsControllerWithEntity:(NSString *)entityName sortKey:(NSString *)sortKey;

- (void)getTokenWithSuccess:(void (^)(NSString *))successHandler failure:(void (^)(void))failureHandler;

@end
