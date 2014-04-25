//
//  Biz.h
//  notifyr
//
//  Created by Nelson Narciso on 2014-04-25.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReceivedNotification.h"

@interface Biz : NSObject

+ (Biz *)sharedBiz;

- (NSArray *)getReceivedNotifications;


@end
