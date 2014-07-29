//
//  ReceivedNotification.h
//  Notifyr
//
//  Created by Nelson Narciso on 2014-04-18.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Company.h"
#import "Product.h"
#import "EventType.h"

@interface Interest : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSNumber *interestId;
@property (nonatomic) NSNumber *companyId;
@property (nonatomic) NSNumber *productId;
@property (nonatomic) NSNumber *eventTypeId;

@property (nonatomic, weak) Company *company;
@property (nonatomic, weak) Product *product;
@property (nonatomic, weak) EventType *eventType;

@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic) NSNumber *isProduct;
@property (nonatomic) NSString *eventTypeName;
@property (nonatomic) NSNumber *stockQuote;
@property (nonatomic) NSString *logoUrl;
@property (nonatomic) NSNumber *hasBeenViewed;
@property (nonatomic) NSNumber *notificationPriority;
@property (nonatomic) NSNumber *notificationFrequencyHours;
@property (nonatomic) NSNumber *isActive;



+ (Interest *)makeInterestFromDictionary:(NSDictionary *)dictionary;

@end
