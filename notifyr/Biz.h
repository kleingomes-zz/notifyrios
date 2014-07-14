//
//  Biz.h
//  notifyr
//
//  Created by Nelson Narciso on 2014-04-25.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Interest.h"
#import "Company.h"
#import "EventType.h"

@interface Biz : NSObject

@property (nonatomic, strong) NSArray *companies;

@property (nonatomic, strong) NSArray *eventTypes;

+ (Biz *)sharedBiz;

- (void)getInterests;

- (Company *)getCompanyById:(NSNumber *)companyId;

- (EventType *)getEventTypeById:(NSNumber *)eventTypeId;


@end
