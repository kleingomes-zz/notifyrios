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
    [self getReceivedNotificationsFromApi];
    
    return [[NSArray alloc] init];
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:[[ReceivedNotification alloc] initWithTitle:@"One"]];
    [items addObject:[[ReceivedNotification alloc] initWithTitle:@"Two"]];
    [items addObject:[[ReceivedNotification alloc] initWithTitle:@"Three"]];
    
    return [NSArray arrayWithArray:items];
}

- (void)getReceivedNotificationsFromApi
{
    NSString *urlString = @"http://frogs.primeprojection.com//api/playsessionapi";
    NSString *method = @"GET";
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:method];
    
    //NSError *error;
    //NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    //[request setHTTPBody:postData];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        NSInteger statusCode = ((NSHTTPURLResponse *) response).statusCode;
                                                        NSLog(@"API response status code:%ld", (long)statusCode);
                                                        //NSString *result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
                                                        
                                                        
                                                        if (error)
                                                        {
                                                            NSLog(@"Error attempting to %@: %@", urlString, error.description);
                                                        }
                                                        else
                                                        {
                                                            NSError *error = nil;
                                                            NSArray *items = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                       options:0
                                                                                                                         error:&error];
                                                            if (error)
                                                            {
                                                                NSLog(@"Serialization error: %@", error.description);
                                                            }
                                                            else
                                                            {
                                                                NSLog(@"Response: %@", items);
                                                                [self notifyNewReceivedNotificationsWithDictionary:items];
                                                            }
                                                        }
                                                    }];
    
    [task resume];
}

- (void)notifyNewReceivedNotificationsWithDictionary:(NSArray *)jsonItems
{
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[jsonItems count]];
    for (NSDictionary *dict in jsonItems)
    {
        [items addObject:[ReceivedNotification makeReceivedNotificationFromDictionary:dict]];
    }
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    userInfo[@"receivedNotifications"] = items;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"ntest1" object:nil userInfo:userInfo];
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
