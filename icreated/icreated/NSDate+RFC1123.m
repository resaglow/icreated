//
//  NSDate+RFC1123.m
//  icreated
//
//  Created by Artem Lobanov on 27/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "NSDate+RFC1123.h"



@implementation NSDate (RFC1123)

+(NSDate*)dateFromRFC1123:(NSString*)string
{
    if(string == nil)
        return nil;
    
    static NSDateFormatter *rfc1123 = nil;
    
    if(rfc1123 == nil)
    {
        rfc1123 = [[NSDateFormatter alloc] init];
        rfc1123.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        rfc1123.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        rfc1123.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss z";
    }
    
    return [rfc1123 dateFromString:string];
}

- (NSString*)RFC1123String {
    static NSDateFormatter *df = nil;
    if(df == nil) {
        df = [[NSDateFormatter alloc] init];
        df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        df.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";
    }
    return [df stringFromDate:self];
}

@end