//
//  ReceivedNotification.h
//  Notifyr
//
//  Created by Nelson Narciso on 2014-04-18.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceivedNotification : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSNumber *notificationId;
@property (nonatomic) NSNumber *companyId;
@property (nonatomic) NSNumber *productId;


- (id)initWithTitle:(NSString *)title;

+ (ReceivedNotification *)makeReceivedNotificationFromDictionary:(NSDictionary *)dictionary;

@end
