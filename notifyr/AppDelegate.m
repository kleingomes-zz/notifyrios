//
//  AppDelegate.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-04-19.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "AppDelegate.h"
#import <WindowsAzureMessaging/WindowsAzureMessaging.h>

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [self checkNotificationTypes:application];
    
     [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
//    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x0066ff)];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:10/255.0 green:96/255.0  blue:254/255.0  alpha:1.0]] ;
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue" size:18.0], NSFontAttributeName, nil]];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    return YES;
}

- (void)checkNotificationTypes:(UIApplication *)application
{
    UIRemoteNotificationType remoteNotifcationTypes = [application enabledRemoteNotificationTypes];

    NSLog(@"Remote Notification Types:%lu", remoteNotifcationTypes);
    if (remoteNotifcationTypes == UIRemoteNotificationTypeNone)
    {
        NSLog(@"UIRemoteNotificationTypeNone");
    }
    if (remoteNotifcationTypes & UIRemoteNotificationTypeAlert)
    {
        NSLog(@"UIRemoteNotificationTypeAlert");
    }
    if (remoteNotifcationTypes & UIRemoteNotificationTypeBadge)
    {
        NSLog(@"UIRemoteNotificationTypeBadge");
    }
    if (remoteNotifcationTypes & UIRemoteNotificationTypeSound)
    {
        NSLog(@"UIRemoteNotificationTypeSound");
    }
    if (remoteNotifcationTypes & UIRemoteNotificationTypeNewsstandContentAvailability)
    {
        NSLog(@"UIRemoteNotificationTypeNewsstandContentAvailability");
    }
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *) deviceToken
{
    
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"%@", hexToken);
    
    
    SBNotificationHub* hub = [[SBNotificationHub alloc] initWithConnectionString:
                              @"Endpoint=sb://notifyrtoronto.servicebus.windows.net/;SharedAccessKeyName=DefaultFullSharedAccessSignature;SharedAccessKey=YbApWjxkhzS9/ppSUOEqisY28oUH2cge+hXAIV3HRDU=" notificationHubPath:@"notifyrhub"];
    
    [hub registerNativeWithDeviceToken:deviceToken tags:nil completion:^(NSError* error) {
        if (error != nil) {
            NSLog(@"Error registering for notifications: %@", error);
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register for remote notifications: %@", [error description]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification: (NSDictionary *)userInfo {
    NSLog(@"%@", userInfo);
    
    NSDictionary *aps1 = userInfo[@"aps"];
    
    //NSDictionary *aps2 = aps1[@"aps"];
    //NSString *msg = aps2[@"alert"];
    
    NSString *msg = aps1[@"alert"];
    
    NSLog(@"msg: %@", msg);


    
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:
    //                      [[userInfo objectForKey:@"aps"] valueForKey:@"alert"] delegate:nil cancelButtonTitle:
    //                      @"OK" otherButtonTitles:nil, nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:msg delegate:nil cancelButtonTitle:
                          @"OK" otherButtonTitles:nil, nil];

    
    [alert show];
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
