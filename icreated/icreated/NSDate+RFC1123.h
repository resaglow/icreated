//
//  NSDate+RFC1123.h
//  icreated
//
//  Created by Artem Lobanov on 27/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (RFC1123)


+(NSDate*)dateFromRFC1123:(NSString*)string;


-(NSString*)RFC1123String;

@end