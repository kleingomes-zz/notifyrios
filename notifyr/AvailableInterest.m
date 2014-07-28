//
//  AvailableInterest.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-07-27.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "AvailableInterest.h"
#import "Utils.h"

@implementation AvailableInterest

+ (AvailableInterest *)makeAvailableInterestFromDictionary:(NSDictionary *)dictionary
{
    AvailableInterest *ai = [[AvailableInterest alloc] init];
    ai.availableInterestId = [Utils getNumberFromDictionary:dictionary name:@"Id"];
    ai.name = [Utils getStringFromDictionary:dictionary name:@"Name"];
    ai.type = [Utils getStringFromDictionary:dictionary name:@"Type"];
    
    return ai;
}

@end
