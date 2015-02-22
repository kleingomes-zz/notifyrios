//
//  AppSettings.h
//  notifyr
//
//  Created by Nelson Narciso on 2015-02-21.
//  Copyright (c) 2015 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject

@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic) BOOL sentDeviceTokenToApi;

+ (AppSettings *)sharedSettings;

@end
