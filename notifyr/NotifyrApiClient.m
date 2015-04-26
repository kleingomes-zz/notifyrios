//
//  NotifyrApiClient.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-05-12.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "NotifyrApiClient.h"
#import "Item.h"
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
    return [NSString stringWithFormat:@"%@@notifyr.ca", self.userId]; //TODO: make this use the saved user name
    
    //return @"1470ce68-be22-485d-9ae6-453544326331@notifyr.ca";
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
    NSString *urlString = [self getUrl:[NSString stringWithFormat:@"Item/GetUserItems?userId=%@", self.userId]];
    
    [self makeAPICallWithUrlString:urlString method:@"GET" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        if (!error && jsonObject)
        {
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

- (void)getArticlesForInterest:(Item *)interest
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

- (void)getArticlesMainForInterest:(Item *)interest
{
    NSString *urlString = [self getUrl:[NSString stringWithFormat:@"Item/GetItemArticles?itemId=%@", interest.itemId]];
    
    [self makeAPICallWithUrlString:urlString method:@"GET" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        if (!error && jsonObject)
        {
            [self notifyArticlesUpdatedForInterest:interest jsonItems:jsonObject];
        }
    }];
}



- (void)getArticlesForItem:(Item *)item skip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion
{
    if (!self.accessToken)
    {
        [self getNewAccessTokenWithCompletionHandler:^(NSError *error) {
            [self getArticlesForItemMain:item skip:skip take:take sortBy:sortBy completion:completion];
        }];
    }
    else
    {
        [self getArticlesForItemMain:item skip:skip take:take sortBy:sortBy completion:completion];
    }
}

- (void)getArticlesForItemMain:(Item *)item skip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion
{
    NSString *urlString = [self getUrl:[NSString stringWithFormat:@"Item/GetItemArticles?itemId=%@&skip=%ld&take=%ld&sortBy=%@", item.itemId, (long)skip, (long)take, sortBy]];
    
    [self makeAPICallWithUrlString:urlString method:@"GET" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        if (error != nil)
        {
            completion(nil, error);
            return;
        }
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[jsonObject count]];
        for (NSDictionary *dict in jsonObject)
        {
            Article *article = [Article makeArticleFromDictionary:dict];
            [items addObject:article];
        }
        
        completion(items, nil);
    }];
}




- (void)getArticlesForAllItemsWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion
{
    if (!self.accessToken)
    {
        [self getNewAccessTokenWithCompletionHandler:^(NSError *error) {
            [self getArticlesForAllItemsMainWithSkip:skip take:take sortBy:sortBy completion:completion];
        }];
    }
    else
    {
        [self getArticlesForAllItemsMainWithSkip:skip take:take sortBy:sortBy completion:completion];
    }
}

- (void)getArticlesForAllItemsMainWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion
{
    NSString *urlString = [self getUrl:[NSString stringWithFormat:@"Item/GetAllItemArticles?skip=%ld&take=%ld&userId=%@&sortBy=%@", (long)skip, (long)take, self.userId, sortBy]];
    
    [self makeAPICallWithUrlString:urlString method:@"GET" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        if (error != nil)
        {
            completion(nil, error);
            return;
        }
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[jsonObject count]];
        for (NSDictionary *dict in jsonObject)
        {
            Article *article = [Article makeArticleFromDictionary:dict];
            [items addObject:article];
        }
        
        completion(items, nil);
    }];
}

- (void)getArticlesForBreakingNewsWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion
{
    if (!self.accessToken)
    {
        [self getNewAccessTokenWithCompletionHandler:^(NSError *error) {
            [self getArticlesForBreakingNewsMainWithSkip:skip take:take sortBy:sortBy completion:completion];
        }];
    }
    else
    {
        [self getArticlesForBreakingNewsMainWithSkip:skip take:take sortBy:sortBy completion:completion];
    }
}

- (void)getArticlesForBreakingNewsMainWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion
{
    NSString *urlString = [self getUrl:[NSString stringWithFormat:@"Article/GetBreakingNews?skip=%ld&take=%ld&sortBy=%@", (long)skip, (long)take, sortBy]];
    
    [self makeAPICallWithUrlString:urlString method:@"GET" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        if (error != nil)
        {
            completion(nil, error);
            return;
        }
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[jsonObject count]];
        for (NSDictionary *dict in jsonObject)
        {
            Article *article = [Article makeArticleFromDictionary:dict];
            [items addObject:article];
        }
        
        completion(items, nil);
    }];
}

///
- (void)getArticlesForFavouritesWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion
{
    if (!self.accessToken)
    {
        [self getNewAccessTokenWithCompletionHandler:^(NSError *error) {
            [self getArticlesForFavouritesMainWithSkip:skip take:take sortBy:sortBy completion:completion];
        }];
    }
    else
    {
        [self getArticlesForFavouritesMainWithSkip:skip take:take sortBy:sortBy completion:completion];
    }
}

- (void)getArticlesForFavouritesMainWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion
{
    NSString *urlString = [self getUrl:[NSString stringWithFormat:@"Article/GetUserFavouriteArticles?userId=%@&skip=%ld&take=%ld&sortBy=%@", self.userId, (long)skip, (long)take, sortBy]];
    
    [self makeAPICallWithUrlString:urlString method:@"GET" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        if (error != nil)
        {
            completion(nil, error);
            return;
        }
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[jsonObject count]];
        for (NSDictionary *dict in jsonObject)
        {
            Article *article = [Article makeArticleFromDictionary:dict];
            [items addObject:article];
        }
        
        completion(items, nil);
    }];
}


- (void)getUserItemsWithWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *items, NSError *error)) completion
{
    if (!self.accessToken)
    {
        [self getNewAccessTokenWithCompletionHandler:^(NSError *error) {
            [self getUserItemsMainWithWithSkip:skip take:take sortBy:sortBy completion:completion];
        }];
    }
    else
    {
        [self getUserItemsMainWithWithSkip:skip take:take sortBy:sortBy completion:completion];
    }
}

- (void)getUserItemsMainWithWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *items, NSError *error))completion
{
    NSString *urlString = [self getUrl:[NSString stringWithFormat:@"Item/GetUserItems?userId=%@", self.userId]];
    
    [self makeAPICallWithUrlString:urlString method:@"GET" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        if (!error && jsonObject)
        {
            NSArray *jsonItems = (NSArray *)jsonObject;
            NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[jsonItems count]];
            for (NSDictionary *dict in jsonItems)
            {
                Item *item = [Item makeInterestFromDictionary:dict];
                [items addObject:item];
            }
            completion(items, error);
        }
    }];
}


- (void)saveInterest:(Item *)interest withCompletionHandler:(void (^)(NSError *error))completionHandler
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

- (void)saveInterestMain:(Item *)interest withCompletionHandler:(void (^)(NSError *error))completionHandler
{
    NSString *urlString = [self getUrl:@"Item/SaveUserItems"];
    
    NSMutableURLRequest *request = [self getRequestWithUrlString:urlString method:@"POST"];
    //[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"ItemId"] = interest.itemId;
    dict[@"Priority"] = interest.priority;
    
    NSArray *interestsArray = @[dict];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:interestsArray options:0 error:&error];
    [request setHTTPBody:postData];
    
    [self makeAPICallWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        
        NSInteger statusCode = ((NSHTTPURLResponse *) response).statusCode;
        if (statusCode != 200)
        {
            NSLog(@"Got bad response code trying to save interest: %ld", (long)statusCode);
            return;
        }
        
        [self notifyInterestsUpdatedWithDictionary:jsonObject];
        completionHandler(error);
    }];
}

- (void)addFavourite:(Article *)article withCompletionHandler:(void (^)(NSError *error))completionHandler
{
    //todo: replace this access token pattern/main method in these methods
    if (!self.accessToken)
    {
        [self getNewAccessTokenWithCompletionHandler:^(NSError *error) {
            [self addFavouriteMain:article withCompletionHandler:completionHandler];
        }];
    }
    else
    {
        [self addFavouriteMain:article withCompletionHandler:completionHandler];
    }
}
- (void)addFavouriteMain:(Article *)article withCompletionHandler:(void (^)(NSError *))completionHandler
{
    
    NSString *urlString = [self getUrl:[NSString stringWithFormat:@"User/AddArticleToUserFavourites?articleId=%@", article.articleId]];
    
    [self makeAPICallWithUrlString:urlString method:@"POST" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        
        //TODO: move the notification code elsewhere
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        userInfo[@"article"] = @[article];
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:DeleteInterestNotification object:nil userInfo:userInfo];
        
        completionHandler(error);
    }];
}
- (void)deleteFavourite:(Article *)article withCompletionHandler:(void (^)(NSError *error))completionHandler
{
    //todo: replace this access token pattern/main method in these methods
    if (!self.accessToken)
    {
        [self getNewAccessTokenWithCompletionHandler:^(NSError *error) {
            [self deleteFavouriteMain:article withCompletionHandler:completionHandler];
        }];
    }
    else
    {
        [self deleteFavouriteMain:article withCompletionHandler:completionHandler];
    }
}

- (void)deleteFavouriteMain:(Article *)article withCompletionHandler:(void (^)(NSError *))completionHandler
{
    NSString *urlString = [self getUrl:[NSString stringWithFormat:@"User/RemoveArticleFromUserFavourites?articleId=%@", article.articleId]];
    
    [self makeAPICallWithUrlString:urlString method:@"POST" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        
        //TODO: move the notification code elsewhere
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        userInfo[@"article"] = @[article];
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:DeleteInterestNotification object:nil userInfo:userInfo];
        
        completionHandler(error);
    }];
}

- (void)deleteInterest:(Item *)interest withCompletionHandler:(void (^)(NSError *error))completionHandler
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

- (void)deleteInterestMain:(Item *)interest withCompletionHandler:(void (^)(NSError *error))completionHandler
{
    NSString *urlString = [self getUrl:[NSString stringWithFormat:@"Item/DeleteUserItem?ItemId=%@", interest.itemId]];
    
    [self makeAPICallWithUrlString:urlString method:@"POST" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        
        //TODO: move the notification code elsewhere
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        userInfo[@"interests"] = @[interest];
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:DeleteInterestNotification object:nil userInfo:userInfo];

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
    NSString *encodedQuery = [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *urlString = [self getUrl:[NSString stringWithFormat:@"Item/GetItems?query=%@", encodedQuery]];
    
    [self makeAPICallWithUrlString:urlString method:@"GET" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        if (!error && jsonObject)
        {
            NSArray *jsonItems = (NSArray *)jsonObject;
            NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[jsonItems count]];
            for (NSDictionary *dict in jsonItems)
            {
                Item *item = [Item makeInterestFromDictionary:dict];
                [items addObject:item];
            }
            completionHandler(items, error);
        }
    }];
}



- (void)getPopularItemsWithCompletionHandler:(void (^)(NSArray *items, NSError *error))completionHandler
{
    //todo: replace this access token pattern/main method in these methods
    if (!self.accessToken)
    {
        [self getNewAccessTokenWithCompletionHandler:^(NSError *error) {
            [self getPopularItemsMainWithCompletionHandler:completionHandler];
        }];
    }
    else
    {
        [self getPopularItemsMainWithCompletionHandler:completionHandler];
    }
}

- (void)getPopularItemsMainWithCompletionHandler:(void (^)(NSArray *items, NSError *error))completionHandler
{
    NSString *urlString = [self getUrl:[NSString stringWithFormat:@"Item/GetPopularItems"]];
    
    [self makeAPICallWithUrlString:urlString method:@"GET" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        if (!error && jsonObject)
        {
            NSArray *jsonItems = (NSArray *)jsonObject;
            NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[jsonItems count]];
            for (NSDictionary *dict in jsonItems)
            {
                Item *item = [Item makeInterestFromDictionary:dict];
                [items addObject:item];
            }
            completionHandler(items, error);
        }
    }];
}



- (void)registerDevice:(NSString *)deviceToken withCompletionHandler:(void (^)(NSError *error))completionHandler
{
    //todo: replace this access token pattern/main method in these methods
    if (!self.accessToken)
    {
        [self getNewAccessTokenWithCompletionHandler:^(NSError *error) {
            [self registerDeviceMain:deviceToken withCompletionHandler:completionHandler];
        }];
    }
    else
    {
        [self registerDeviceMain:deviceToken withCompletionHandler:completionHandler];
    }

}

- (void)registerDeviceMain:(NSString *)deviceToken withCompletionHandler:(void (^)(NSError *error))completionHandler
{
    NSString *urlString = [self getUrl:[NSString stringWithFormat:@"Account/RegisterDevice?deviceToken=%@&deviceOperatingSystem=apns", deviceToken]];
    
    [self makeAPICallWithUrlString:urlString method:@"GET" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error, id jsonObject) {
        completionHandler(error);
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
    
    NSLog(@"API call: %@", request.URL.absoluteString);
    
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


#pragma mark - Create objects and notify observers


- (void)notifyInterestsUpdatedWithDictionary:(NSArray *)jsonItems
{
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[jsonItems count]];
    for (NSDictionary *dict in jsonItems)
    {
        Item *interest = [Item makeInterestFromDictionary:dict];
        [items addObject:interest];
    }
    
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
        [items addObject:[Item makeInterestFromDictionary:dict]];
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

- (void)notifyArticlesUpdatedForInterest:(Item *)interest jsonItems:(NSArray *)jsonItems
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
