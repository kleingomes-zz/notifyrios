//
//  NotifyrApiClient.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-05-12.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "NotifyrApiClient.h"
#import "Interest.h"
#import "Company.h"
#import "Product.h"
#import "Article.h"
#import "AvailableInterest.h"
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

- (void)getInterests
{
    if (!self.accessToken)
    {
        [self getNewAccessTokenWithCompletionHandler:^(NSError *error) {
            [self getInterestsMain];
        }];
    }
    else
    {
        [self getInterestsMain];
    }
}

-(void)getInterestsMain
{
    //NSString *urlString = @"http://www.notifyr.ca/service/api/Notification/GetNotifications?userId=19a65135-4dff-4ac1-b7c0-877c640581ac";
    //NSString *urlString = @"http://frogs.primeprojection.com/api/playsessionapi";
    //NSString *urlString = @"http://192.168.1.103/Notifyr.WebAPI/api/Notification/GetNotifications?userId=19a65135-4dff-4ac1-b7c0-877c640581ac";

    //NSString *urlString = [self getUrl:@"Interest/GetInterests?userId=19a65135-4dff-4ac1-b7c0-877c640581ac"];
    NSString *urlString = [self getUrl:[NSString stringWithFormat:@"Interest/GetInterests?userId=%@", self.userId]];
    
    [self makeAPICallWithUrlString:urlString method:@"GET" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        if (!error && jsonObject)
        {
            
            //[self notifyInterestsUpdatedWithDictionary:jsonObject];
            //return;

            
            NSInteger statusCode = ((NSHTTPURLResponse *) response).statusCode;
            if (statusCode != 200)
            {
                NSLog(@"Got bad response code trying to get Interests: %ld", (long)statusCode);
                return;
            }
            [self notifyInterestsUpdatedWithDictionary:jsonObject];

        }
    }];
}

- (void)getArticlesForInterest:(Interest *)interest
{
    if (!self.accessToken)
    {
        [self getNewAccessTokenWithCompletionHandler:^(NSError *error) {
            [self getArticlesMainForInterest:interest];
        }];
    }
    else
    {
        [self getArticlesMainForInterest:interest];
    }
}

- (void)getArticlesMainForInterest:(Interest *)interest
{
    NSString *urlString = [self getUrl:[NSString stringWithFormat:@"Interest/GetInterestArticles?interestId=%@", interest.interestId]];
    
    [self makeAPICallWithUrlString:urlString method:@"GET" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        if (!error && jsonObject)
        {
            [self notifyArticlesUpdatedForInterest:interest jsonItems:jsonObject];
        }
    }];
}

- (void)getArticlesForAllInterests
{
    if (!self.accessToken)
    {
        [self getNewAccessTokenWithCompletionHandler:^(NSError *error) {
            [self getArticlesForAllInterestsMain];
        }];
    }
    else
    {
        [self getArticlesForAllInterestsMain];
    }
}

- (void)getArticlesForAllInterestsMain
{
    NSString *urlString = [self getUrl:[NSString stringWithFormat:@"Interest/GetAllInterestArticles?userId=%@", self.userId]];
    
    [self makeAPICallWithUrlString:urlString method:@"GET" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        if (!error && jsonObject)
        {
            [self notifyArticlesUpdatedForInterest:nil jsonItems:jsonObject]; //TODO: possibly not have the nill
        }
    }];
}

- (void)saveInterest:(Interest *)interest withCompletionHandler:(void (^)(NSError *error))completionHandler
{
    //todo: replace this access token pattern/main method in these methods
    if (!self.accessToken)
    {
        [self getNewAccessTokenWithCompletionHandler:^(NSError *error) {
            [self saveInterestMain:interest withCompletionHandler:completionHandler];
        }];
    }
    else
    {
        [self saveInterestMain:interest withCompletionHandler:completionHandler];
    }
}

- (void)saveInterestMain:(Interest *)interest withCompletionHandler:(void (^)(NSError *error))completionHandler
{
    NSString *urlString = [self getUrl:@"Interest/SaveInterests"];
    
    NSMutableURLRequest *request = [self getRequestWithUrlString:urlString method:@"POST"];
    //[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"UserId"] = self.userId;
    dict[@"ProductId"] = interest.productId ? interest.productId : [NSNull null];
    dict[@"CompanyId"] = interest.companyId ? interest.companyId : [NSNull null];
    dict[@"NotificationFrequencyHours"] = interest.notificationFrequencyHours;
    dict[@"NotificationPriority"] = interest.notificationPriority;
    dict[@"IsActive"] = interest.isActive;
    
    NSArray *interestsArray = @[dict];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:interestsArray options:0 error:&error];
    [request setHTTPBody:postData];
    
    [self makeAPICallWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        [self notifyInterestsUpdatedWithDictionary:jsonObject];
        completionHandler(error);
    }];
}

- (void)deleteInterest:(Interest *)interest withCompletionHandler:(void (^)(NSError *error))completionHandler
{
    //todo: replace this access token pattern/main method in these methods
    if (!self.accessToken)
    {
        [self getNewAccessTokenWithCompletionHandler:^(NSError *error) {
            [self deleteInterestMain:interest withCompletionHandler:completionHandler];
        }];
    }
    else
    {
        [self deleteInterestMain:interest withCompletionHandler:completionHandler];
    }
}

- (void)deleteInterestMain:(Interest *)interest withCompletionHandler:(void (^)(NSError *error))completionHandler
{
    NSString *urlString = [self getUrl:[NSString stringWithFormat:@"Interest/DeleteInterest?interestId=%@", interest.interestId]];
    
    [self makeAPICallWithUrlString:urlString method:@"POST" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        completionHandler(error);
    }];
}



- (void)getAvailableInterests:(NSString *)query withCompletionHandler:(void (^)(NSArray *availableInterests, NSError *error))completionHandler;
{
    //todo: replace this access token pattern/main method in these methods
    if (!self.accessToken)
    {
        [self getNewAccessTokenWithCompletionHandler:^(NSError *error) {
            [self getAvailableInterestsMain:query withCompletionHandler:completionHandler];
        }];
    }
    else
    {
        [self getAvailableInterestsMain:query withCompletionHandler:completionHandler];
    }
}

- (void)getAvailableInterestsMain:(NSString *)query withCompletionHandler:(void (^)(NSArray *availableInterests, NSError *error))completionHandler;
{
    NSString *urlString = [self getUrl:[NSString stringWithFormat:@"Interest/GetAvailableInterests?query=%@", query]];
    
    [self makeAPICallWithUrlString:urlString method:@"GET" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        if (!error && jsonObject)
        {
            NSArray *jsonItems = (NSArray *)jsonObject;
            NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[jsonItems count]];
            for (NSDictionary *dict in jsonItems)
            {
                AvailableInterest *availableInterest = [AvailableInterest makeAvailableInterestFromDictionary:dict];
                [items addObject:availableInterest];
            }
            completionHandler(items, error);
        }
    }];
}


- (void)getCompaniesWithCompletionHandler:(void (^)(NSError *error))completionHandler
{
    if (!self.accessToken)
    {
        [self getNewAccessTokenWithCompletionHandler:^(NSError *error) {
            [self getCompaniesMainWithCompletionHandler:completionHandler];
        }];
    }
    else
    {
        [self getCompaniesMainWithCompletionHandler:completionHandler];
    }
}

- (void)getCompaniesMainWithCompletionHandler:(void (^)(NSError *error))completionHandler
{
    NSString *urlString = [self getUrl:@"Company/GetAllCompanies"];
    
    [self makeAPICallWithUrlString:urlString method:@"GET" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        if (!error && jsonObject)
        {
            [self notifyNewCompaniesWithDictionary:(NSArray *) jsonObject];
            completionHandler(error);
        }
    }];
}

- (void)getProductsWithCompletionHandler:(void (^)(NSError *error))completionHandler
{
    if (!self.accessToken)
    {
        [self getNewAccessTokenWithCompletionHandler:^(NSError *error) {
            [self getProductsMainWithCompletionHandler:completionHandler];
        }];
    }
    else
    {
        [self getProductsMainWithCompletionHandler:completionHandler];
    }
}

- (void)getProductsMainWithCompletionHandler:(void (^)(NSError *error))completionHandler
{
    NSString *urlString = [self getUrl:@"Product/GetAllProducts"];
    
    [self makeAPICallWithUrlString:urlString method:@"GET" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        if (!error && jsonObject)
        {
            [self notifyNewProductsWithDictionary:(NSArray *) jsonObject];
            completionHandler(error);
        }
    }];
}

- (void)getNewAccessTokenWithCompletionHandler:(void (^)(NSError *error))completionHandler
{
    [self loadUserData];
    
    if (!self.userId)
    {
        [self registerGuestAccountWithCompletionHandler:^(NSError *error) {
            [self getNewAccessTokenMainWithCompletionHandler:completionHandler];
        }];
    }
    else
    {
        [self getNewAccessTokenMainWithCompletionHandler:completionHandler];
    }
}

- (void)getNewAccessTokenMainWithCompletionHandler:(void (^)(NSError *error))completionHandler
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
    
    NSString *bodyString = [NSString stringWithFormat:@"grant_type=password&username=%@&password=%@", userName, password];
    //NSString *bodyString = @"grant_type=password&username=1470ce68-be22-485d-9ae6-453544326331@notifyr.ca&password=2014$NotifyrPassword$2014";
    
    //[request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:[bodyString dataUsingEncoding:NSASCIIStringEncoding]];
    
    
    [self makeAPICallWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        
        NSLog(@"%@", jsonObject[@"access_token"]);
        self.accessToken = jsonObject[@"access_token"];
        //[self getCompanies];
        completionHandler(error);
    }];
}

- (void)registerGuestAccountWithCompletionHandler:(void (^)(NSError *error))completionHandler
{
    NSString *urlString = [self getUrl:@"Account/RegisterGuest"];
    
    [self makeAPICallWithUrlString:urlString method:@"POST" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        if (!error && jsonObject)
        {
            self.userId = jsonObject[@"UserId"];
            self.userName = jsonObject[@"UserId"];
            self.password = @"2014$NotifyrPassword$2014";
            [self saveUserData];
        }
        completionHandler(error);
    }];
}

- (void)saveUserData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userId forKey:@"userId"];
    [defaults setObject:self.userName forKey:@"userName"];
    [defaults setObject:self.password forKey:@"password"];
    [defaults synchronize];
}

- (void)loadUserData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userId = [defaults stringForKey:@"userId"];
    self.userName = [defaults stringForKey:@"userName"];
    self.password = [defaults stringForKey:@"password"];
}


#pragma mark - API Helper Methods

- (void)makeAPICallWithUrlString:(NSString *)urlString
                          method:(NSString *)method
               completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error, id jsonObject))completionHandler
{
    NSMutableURLRequest *request = [self getRequestWithUrlString:urlString method:method];
    
    NSLog(@"API Call: %@", [request.URL absoluteString]);
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


- (void)notifyInterestsUpdatedWithDictionary:(NSArray *)jsonItems
{

    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[jsonItems count]];
    for (NSDictionary *dict in jsonItems)
    {
        Interest *interest = [Interest makeInterestFromDictionary:dict];
        [items addObject:interest];
    }
    
    //set objects
//    Biz *biz = [Biz sharedBiz];
//    for (Interest *interest in items)
//    {
//        interest.title = [biz getCompanyById:interest.companyId].name;
//        interest.company = [biz getCompanyById:interest.companyId];
//        interest.product = [biz getProductById:interest.productId];
//    }
    
    
    //NSArray *items = [self getFakeInterests];

    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    userInfo[@"interests"] = items;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:InterestsUpdateNotification object:nil userInfo:userInfo];
}

- (NSArray *)getFakeInterests
{
    NSMutableArray *dictionaries = [[NSMutableArray alloc] init];
    
    [dictionaries addObject: @{
                           @"CompanyName": @"Apple",
                           @"ProductName": @"iPhone 6",
                           @"EventTypeName": @"Release Date"
                        }];
    
    [dictionaries addObject: @{
                        @"CompanyName": @"Samsung",
                        @"ProductName": @"G Watch",
                        @"EventTypeName": @"Conference"
                        }];
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in dictionaries)
    {
        [items addObject:[Interest makeInterestFromDictionary:dict]];
    }
    
    return items;
}


#pragma mark - Notification Methods

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
    [center postNotificationName:CompaniesUpdateNotification object:nil userInfo:userInfo];
}

- (void)notifyNewProductsWithDictionary:(NSArray *)jsonItems
{
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[jsonItems count]];
    for (NSDictionary *dict in jsonItems)
    {
        [items addObject:[Product makeProductFromDictionary:dict]];
    }
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    userInfo[@"products"] = items;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:ProductsUpdateNotification object:nil userInfo:userInfo];
}

- (void)notifyArticlesUpdatedForInterest:(Interest *)interest jsonItems:(NSArray *)jsonItems
{
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[jsonItems count]];
    for (NSDictionary *dict in jsonItems)
    {
        Article *article = [Article makeArticleFromDictionary:dict];
        article.interest = interest;
        [items addObject:article];
    }
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    userInfo[@"articles"] = items;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:ArticlesUpdateNotification object:nil userInfo:userInfo];
}


@end
