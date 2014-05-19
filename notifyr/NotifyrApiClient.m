//
//  NotifyrApiClient.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-05-12.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "NotifyrApiClient.h"
#import "ReceivedNotification.h"
#import "Company.h"
#import "Biz.h"
#import "Constants.h"


@implementation NotifyrApiClient

#pragma mark - Properties

- (NSString *)accessToken
{
    if (!_accessToken)
    {
        //get access token
    }
    return  _accessToken;
}

- (NSString *)userName
{
    return @"1470ce68-be22-485d-9ae6-453544326331@notifyr.ca";
}

- (NSString *)password
{
    return @"2014$NotifyrPassword$2014";
}


- (NSString *)getUrl:(NSString *)urlString
{
    //return [NSString stringWithFormat:@"%@%@", @"http://192.168.1.180/Notifyr.WebAPI/api/", urlString];
    return [NSString stringWithFormat:@"%@%@", @"http://www.notifyr.ca/service/api/", urlString];
}


- (NSMutableURLRequest *)getRequestWithUrlString:(NSString *)urlString method:(NSString *)method
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (self.accessToken)
    {
        [request addValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    }
    
    [request setHTTPMethod:method];
    return request;
}

- (void)getReceivedNotifications
{
    //NSString *urlString = @"http://www.notifyr.ca/service/api/Notification/GetNotifications?userId=19a65135-4dff-4ac1-b7c0-877c640581ac";
    //NSString *urlString = @"http://frogs.primeprojection.com/api/playsessionapi";
    //NSString *urlString = @"http://192.168.1.103/Notifyr.WebAPI/api/Notification/GetNotifications?userId=19a65135-4dff-4ac1-b7c0-877c640581ac";
    
    NSString *urlString = [self getUrl:@"Notification/GetNotifications?userId=19a65135-4dff-4ac1-b7c0-877c640581ac"];
    
    [self makeAPICallWithUrlString:urlString method:@"GET" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        if (!error && jsonObject)
        {
            //[self notifyNewCompaniesWithDictionary:(NSArray *) jsonObject];
            [self notifyNewReceivedNotificationsWithDictionary:jsonObject];
        }
    }];
}

- (void)getCompanies
{
    //NSString *urlString = @"http://www.notifyr.ca/service/api/Company/GetAllCompanies";
    //NSString *urlString = @"http://frogs.primeprojection.com//api/playsessionapi";
    
    NSString *urlString = [self getUrl:@"Company/GetAllCompanies"];

    [self makeAPICallWithUrlString:urlString method:@"GET" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        if (!error && jsonObject)
        {
            [self notifyNewCompaniesWithDictionary:(NSArray *) jsonObject];
            [self getReceivedNotifications];
        }
    }];
}

- (void)getNewAccessToken
{
    //NSString *urlString = @"http://www.notifyr.ca/service/token";
    NSString *baseUrl = [self getUrl:@""];
    baseUrl = [baseUrl stringByReplacingOccurrencesOfString:@"/api/" withString:@"/"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", baseUrl, @"token"];
    
    NSMutableURLRequest *request = [self getRequestWithUrlString:urlString method:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //NSString *userName = @"1470ce68-be22-485d-9ae6-453544326331@notifyr.ca";
    //NSString *password = @"2014$NotifyrPassword$2014";
    
    NSString *userName = self.userName;
    NSString *password = self.password;
    
    //NSString *bodyString = [NSString stringWithFormat:@"grant_type=password&username=%@&password=%@", userName, password];
    NSString *bodyString = @"grant_type=password&username=1470ce68-be22-485d-9ae6-453544326331@notifyr.ca&password=2014$NotifyrPassword$2014";
    
    //[request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:[bodyString dataUsingEncoding:NSASCIIStringEncoding]];
    
    
    [self makeAPICallWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {

        NSLog(@"%@", jsonObject[@"access_token"]);
        self.accessToken = jsonObject[@"access_token"];
        [self getCompanies];
    }];
}



- (void)makeAPICallWithUrlString:(NSString *)urlString
                          method:(NSString *)method
               completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error, id jsonObject))completionHandler
{
    NSMutableURLRequest *request = [self getRequestWithUrlString:urlString method:method];
    [self makeAPICallWithRequest:request completionHandler:completionHandler];
    
}

- (void)makeAPICallWithRequest:(NSMutableURLRequest *)request
               completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error, id jsonObject))completionHandler
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                NSInteger statusCode = ((NSHTTPURLResponse *) response).statusCode;
                                                NSLog(@"API response status code:%ld", (long)statusCode);
                                                //NSString *result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
                                                
                                                if (error)
                                                {
                                                    NSLog(@"Error attempting to %@: %@", [request.URL absoluteString], error.description);
                                                }
                                                else
                                                {
                                                    NSError *error = nil;
                                                    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                    options:0
                                                                                                      error:&error];
                                                    if (error)
                                                    {
                                                        NSLog(@"Serialization error: %@", error.description);
                                                    }
                                                    else
                                                    {
                                                        NSLog(@"Response: %@", jsonObject);
                                                    }
                                                    completionHandler(data, response, error, jsonObject);
                                                }
                                            }];
    [task resume];
}


/*
 - (void)getCompaniesFromApi
 {
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
 
 
 [self getReceivedNotifications];
 }
 }
 }];
 [task resume];
 }
 */

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

- (void)getReceivedNotifications
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
 
 */

#pragma mark - Create objects and notify observers

- (void)notifyNewReceivedNotificationsWithDictionary:(NSArray *)jsonItems
{
    Biz *biz = [Biz sharedBiz];

    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[jsonItems count]];
    for (NSDictionary *dict in jsonItems)
    {
        [items addObject:[ReceivedNotification makeReceivedNotificationFromDictionary:dict]];
    }
    
    for (ReceivedNotification *notification in items)
    {
        notification.title = [biz getCompanyById:notification.companyId].name;
    }
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    userInfo[@"receivedNotifications"] = items;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:ReceivedNotificationsNotification object:nil userInfo:userInfo];
}

- (void)notifyNewCompaniesWithDictionary:(NSArray *)jsonItems
{
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[jsonItems count]];
    for (NSDictionary *dict in jsonItems)
    {
        [items addObject:[Company makeCompanyFromDictionary:dict]];
    }
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    userInfo[@"companies"] = items;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:ReceivedCompaniesNotification object:nil userInfo:userInfo];

}


@end
