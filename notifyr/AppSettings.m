//
//  AppSettings.m
//  notifyr
//
//  Created by Nelson Narciso on 2015-02-21.
//  Copyright (c) 2015 Nelson Narciso. All rights reserved.
//

#import "AppSettings.h"

@implementation AppSettings

@synthesize deviceToken = _deviceToken, sentDeviceTokenToApi = _sentDeviceTokenToApi;

NSString * const kUserDefaultsKeyDeviceToken = @"deviceToken";
NSString * const kUserDefaultsKeySentDeviceTokenToApi = @"sentDeviceTokenToApi";


static AppSettings *sharedInstance = nil;

+ (AppSettings *)sharedSettings {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppSettings alloc] init];
    });
    return sharedInstance;
}


#pragma mark - deviceToken

- (NSString *)deviceToken
{
    if (_deviceToken == nil)
    {
        _deviceToken = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsKeyDeviceToken];
    }
    return _deviceToken;
}

- (void)setDeviceToken:(NSString *)deviceToken
{
    if ([_deviceToken isEqualToString: deviceToken])
    {
        return;
    }
    _deviceToken = deviceToken;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:deviceToken forKey:kUserDefaultsKeyDeviceToken];
    [userDefaults synchronize];
}


#pragma mark - sentDeviceTokenToApi

- (BOOL)sentDeviceTokenToApi
{
    _sentDeviceTokenToApi = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeySentDeviceTokenToApi];
    return _sentDeviceTokenToApi;
}

- (void)setSentDeviceTokenToApi:(BOOL)sentDeviceTokenToApi
{
    if (_sentDeviceTokenToApi == sentDeviceTokenToApi)
    {
        return;
    }
    _sentDeviceTokenToApi = sentDeviceTokenToApi;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:sentDeviceTokenToApi forKey:kUserDefaultsKeySentDeviceTokenToApi];
    [userDefaults synchronize];
}


@end
