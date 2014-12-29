//
//  ReceivedNotification.m
//  Notifyr
//
//  Created by Nelson Narciso on 2014-04-18.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "Interest.h"
#import "Utils.h"

@implementation Interest

+ (Interest *)makeInterestFromDictionary:(NSDictionary *)dictionary
{
    Interest *interest = [[Interest alloc] init];
    interest.itemId = [Utils getNumberFromDictionary:dictionary name:@"ItemId"];
    interest.logoUrl = [Utils getStringFromDictionary:dictionary name:@"LogoUrl"];
    interest.itemName = [Utils getStringFromDictionary:dictionary name:@"ItemName"];
    
    return interest;
}


@end
