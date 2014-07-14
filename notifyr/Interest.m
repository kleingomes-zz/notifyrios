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


- (id)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}

+ (Interest *)makeInterestFromDictionary:(NSDictionary *)dictionary
{
    Interest *interest = [[Interest alloc] init];
    interest.interestId = [Utils getNumberFromDictionary:dictionary name:@"Id"];
    interest.companyId = [Utils getNumberFromDictionary:dictionary name:@"CompanyId"];
    interest.productId = [Utils getNumberFromDictionary:dictionary name:@"ProductId"];
    interest.eventTypeId = [Utils getNumberFromDictionary:dictionary name:@"EventTypeId"];

    return interest;
}


@end
