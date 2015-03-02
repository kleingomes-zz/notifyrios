//
//  Utils.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-05-04.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSNumber *)getNumberFromDictionary:(NSDictionary *)dictionary name:(NSString *)name
{
    if (dictionary[name] == [NSNull null])
    {
        return nil;
    }
    return dictionary[name];
}

+ (NSString *)getStringFromDictionary:(NSDictionary *)dictionary name:(NSString *)name
{
    if (dictionary[name] == [NSNull null])
    {
        return nil;
    }
    return dictionary[name];
}

+ (BOOL *)getBoolFromDictionary:(NSDictionary *)dictionary name:(NSString *)name
{
    if (dictionary[name] == [NSNull null])
    {
        return nil;
    }
    return [dictionary[name] boolValue];
}


+ (NSDate *)getDateFromDictionary:(NSDictionary *)dictionary name:(NSString *)name
{
    if (dictionary[name] == [NSNull null])
    {
        return nil;
    }
    
    NSString *dateString = dictionary[name];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateString];

    return date;
}

@end
