//
//  ReceivedNotification.m
//  Notifyr
//
//  Created by Nelson Narciso on 2014-04-18.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "Item.h"
#import "Utils.h"

@implementation Item

+ (Item *)makeInterestFromDictionary:(NSDictionary *)dictionary
{
    Item *interest = [[Item alloc] init];
    interest.itemId = [Utils getNumberFromDictionary:dictionary name:@"Id"];
    interest.itemTypeId = [Utils getNumberFromDictionary:dictionary name:@"ItemTypeId"];
    interest.logoUrl = [Utils getStringFromDictionary:dictionary name:@"IUrl"];
    interest.itemName = [Utils getStringFromDictionary:dictionary name:@"Name"];
    interest.primaryBackgroundColour = [Utils getStringFromDictionary:dictionary name:@"PrimaryBackgroundColour"];
    interest.primaryBackgroundColourAlt = [Utils getStringFromDictionary:dictionary name:@"PrimaryBackgroundColourAlt"];
    interest.primaryForegroundColour = [Utils getStringFromDictionary:dictionary name:@"PrimaryForegroundColour"];
    interest.primaryForegroundColourAlt = [Utils getStringFromDictionary:dictionary name:@"PrimaryForegroundColourAlt"];

    return interest;
}


@end
