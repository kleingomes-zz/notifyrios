//
//  ReceivedNotification.m
//  Notifyr
//
//  Created by Nelson Narciso on 2014-04-18.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "ReceivedNotification.h"
#import "Utils.h"

@implementation ReceivedNotification


- (id)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}

+ (NSInteger)getIntegerFromDictionary:(NSDictionary *)dictionary name:(NSString *)name
{
    if (dictionary[name] == [NSNull null])
    {
        return -1;
    }
    else
    {
        return [dictionary[name] integerValue];
    }
}

+ (ReceivedNotification *)makeReceivedNotificationFromDictionary:(NSDictionary *)dictionary
{
    ReceivedNotification *receivedNotification = [[ReceivedNotification alloc] init];
    //receivedNotification.title = dictionary[@"DeviceId"];
    receivedNotification.notificationId = [Utils getNumberFromDictionary:dictionary name:@"Id"];
    receivedNotification.companyId = [Utils getNumberFromDictionary:dictionary name:@"CompanyId"];
    receivedNotification.productId = [Utils getNumberFromDictionary:dictionary name:@"ProductId"];

    return receivedNotification;
}


@end
