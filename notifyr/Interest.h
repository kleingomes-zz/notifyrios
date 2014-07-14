//
//  ReceivedNotification.h
//  Notifyr
//
//  Created by Nelson Narciso on 2014-04-18.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Company.h"
#import "EventType.h"

@interface Interest : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSNumber *interestId;
@property (nonatomic) NSNumber *companyId;
@property (nonatomic) NSNumber *productId;
@property (nonatomic) NSNumber *eventTypeId;

@property (nonatomic, weak) Company *company;
@property (nonatomic, weak) EventType *eventType;


- (id)initWithTitle:(NSString *)title;

+ (Interest *)makeInterestFromDictionary:(NSDictionary *)dictionary;

@end
