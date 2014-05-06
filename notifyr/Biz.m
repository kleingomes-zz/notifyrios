//
//  Biz.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-04-25.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "Biz.h"

@implementation Biz


- (NSMutableArray *)companies
{
    if (!_companies)
    {
        _companies = [[NSMutableArray alloc] init];
        //[self getCompaniesFromApi];
    }
    return _companies;
}

- (NSMutableURLRequest *)getRequestWithUrlString:(NSString *)urlString method:(NSString *)method
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:method];
    return request;
}

- (NSMutableURLRequest *)getRequestWithUrlString:(NSString *)urlString
{
    return [self getRequestWithUrlString:urlString method:@"GET"];
}

- (NSArray *)getCompaniesFromApi
{
    NSMutableArray *companies = [[NSMutableArray alloc] init];
    
    NSString *urlString = @"http://www.notifyr.ca/service/api/Company/GetAllCompanies";
    NSMutableURLRequest *request = [self getRequestWithUrlString:urlString];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
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
                                                            [self notifyNewCompaniesWithDictionary:items];
                                                            
                                                            
                                                            [self getReceivedNotificationsFromApi];
                                                        }
                                                    }
                                                }];
    [task resume];
    
    return [NSArray arrayWithArray:companies];
}

- (NSArray *)getReceivedNotifications
{
    [self getCompaniesFromApi];
    
    //[self getReceivedNotificationsFromApi];
    
    return [[NSArray alloc] init];
}


/*
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
 */

- (void)getReceivedNotificationsFromApi
{
    NSString *urlString = @"http://www.notifyr.ca/service/api/Notification/GetNotifications?userId=19a65135-4dff-4ac1-b7c0-877c640581ac";
    NSString *method = @"GET";
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:method];
    
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
    
    for (ReceivedNotification *notification in items)
    {
        notification.title = [self getCompanyById:notification.companyId].name;
    }
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    userInfo[@"receivedNotifications"] = items;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"ntest1" object:nil userInfo:userInfo];
}

- (void)notifyNewCompaniesWithDictionary:(NSArray *)jsonItems
{
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[jsonItems count]];
    for (NSDictionary *dict in jsonItems)
    {
        [items addObject:[Company makeCompanyFromDictionary:dict]];
    }
    
    self.companies  = items;
    
    return;
    
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    userInfo[@"receivedNotifications"] = items;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"ntest1" object:nil userInfo:userInfo];
}



- (Company *)getCompanyById:(NSNumber *)companyId
{
    if (companyId == nil)
    {
        return nil;
    }
    for (Company *company in self.companies)
    {
        if ([company.companyId isEqualToValue:companyId])
        {
            return company;
        }
    }
    return nil;
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
