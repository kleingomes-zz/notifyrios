//
//  Biz.h
//  notifyr
//
//  Created by Nelson Narciso on 2014-04-25.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReceivedNotification.h"
#import "Company.h"

@interface Biz : NSObject

@property (nonatomic, strong) NSArray *companies;

+ (Biz *)sharedBiz;

- (void)getReceivedNotifications;

- (Company *)getCompanyById:(NSNumber *)companyId;

@end
