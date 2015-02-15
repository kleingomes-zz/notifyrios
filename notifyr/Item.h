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

@interface Item : NSObject

@property (nonatomic) NSNumber *itemId;
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic) NSString *logoUrl;
@property (nonatomic) NSString *primaryForegroundColour;
@property (nonatomic) NSString *primaryForegroundColourAlt;
@property (nonatomic) NSString *primaryBackgroundColour;
@property (nonatomic) NSString *primaryBackgroundColourAlt;

+ (Item *)makeInterestFromDictionary:(NSDictionary *)dictionary;

@end
