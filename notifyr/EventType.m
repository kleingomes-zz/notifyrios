//
//  EventType.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-07-13.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "EventType.h"

@implementation EventType

- (id)initWithEventTypeId:(NSNumber *)eventTypeId name:(NSString *)name
{
    self = [super init];
    if (self) {
        self.eventTypeId = eventTypeId;
        self.name = name;
    }
    return self;
}



@end
