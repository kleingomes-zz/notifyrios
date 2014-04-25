//
//  Biz.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-04-25.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "Biz.h"

@implementation Biz


- (NSArray *)getReceivedNotifications
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:[[ReceivedNotification alloc] initWithTitle:@"One"]];
    [items addObject:[[ReceivedNotification alloc] initWithTitle:@"Two"]];
    [items addObject:[[ReceivedNotification alloc] initWithTitle:@"Three"]];
    
    return [NSArray arrayWithArray:items];
}


+ (Biz *)sharedBiz
{
    static Biz *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Biz alloc] init];
    });
    return sharedInstance;
}

@end
