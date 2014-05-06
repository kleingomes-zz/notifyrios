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

@end
