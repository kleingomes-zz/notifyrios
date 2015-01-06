//
//  Biz.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-04-25.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "Biz.h"
#import "Repository.h"
#import "NotifyrApiClient.h"
#import "Constants.h"

@implementation Biz


#pragma mark - Properties

- (NSArray *)interests
{
    if (!_interests)
    {
        _interests = [[Repository sharedRepository] getInterests];
    }
    return _interests;
}

- (NSArray *)companies
{
    if (!_companies)
    {
        _companies = [[Repository sharedRepository] getCompanies];
    }
    return _companies;
}

- (NSMutableDictionary *)imageCache
{
    if (!_imageCache)
    {
        _imageCache = [[NSMutableDictionary alloc] init];
    }
    return _imageCache;
}

#pragma mark - Get Object Methods

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

- (Product *)getProductById:(NSNumber *)productId
{
    if (productId == nil)
    {
        return nil;
    }
    for (Product *product in self.products)
    {
        if ([product.productId isEqualToValue:productId])
        {
            return product;
        }
    }
    return nil;
}


#pragma mark - Main Methods

- (void)getInterests
{
    NotifyrApiClient *apiClient = [[NotifyrApiClient alloc] init];
    [apiClient getInterests];

    return;
    [apiClient getCompaniesWithCompletionHandler:^(NSError *error) {
        [apiClient getProductsWithCompletionHandler:^(NSError *error) {
            [apiClient getInterests];
        }];
    }];
}

- (void)getArticlesForInterest:(Item *)interest
{
    NotifyrApiClient *apiClient = [[NotifyrApiClient alloc] init];
    [apiClient getArticlesForInterest:interest];
}

- (void)getArticlesForItem:(Item *)item skip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion
{
    NotifyrApiClient *apiClient = [[NotifyrApiClient alloc] init];
    [apiClient getArticlesForItem:item skip:skip take:take sortBy:sortBy completion:completion];
}


- (void)getArticlesForAllItemsWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion
{
    NotifyrApiClient *apiClient = [[NotifyrApiClient alloc] init];
    [apiClient getArticlesForAllItemsWithSkip:skip take:take sortBy:sortBy completion:completion];
}

- (void)getArticlesForBreakingNewsWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion
{
    NotifyrApiClient *apiClient = [[NotifyrApiClient alloc] init];
    [apiClient getArticlesForBreakingNewsWithSkip:skip take:take sortBy:sortBy completion:completion];
}

- (void)getArticlesForFavouritesWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion
{
    NotifyrApiClient *apiClient = [[NotifyrApiClient alloc] init];
    [apiClient getArticlesForFavouritesWithSkip:skip take:take sortBy:sortBy completion:completion];
}


- (void)saveInterest:(Item *)interest withCompletionHandler:(void (^)(NSError *error))completionHandler;
{
    NotifyrApiClient *apiClient = [[NotifyrApiClient alloc] init];
    [apiClient saveInterest:interest withCompletionHandler:completionHandler];
}

- (void)deleteInterest:(Item *)interest withCompletionHandler:(void (^)(NSError *error))completionHandler
{
    NotifyrApiClient *apiClient = [[NotifyrApiClient alloc] init];
    [apiClient deleteInterest:interest withCompletionHandler:completionHandler];
}


- (void)getAvailableInterests:(NSString *)query withCompletionHandler:(void (^)(NSArray *availableInterests, NSError *error))completionHandler;
{
    NotifyrApiClient *apiClient = [[NotifyrApiClient alloc] init];
    [apiClient getAvailableInterests:query withCompletionHandler:completionHandler];
}

- (void)initObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
    [center addObserverForName:CompaniesUpdateNotification
                        object:nil
                         queue:mainQueue
                    usingBlock:^(NSNotification *notification) {
                         NSArray *companies = notification.userInfo[@"companies"];
                                                             
                         NSLog(@"Got %lu companies", (unsigned long)[companies count]);
                                                             
                         self.companies = companies;
                     }];
    
    [center addObserverForName:ProductsUpdateNotification
                        object:nil
                         queue:mainQueue
                    usingBlock:^(NSNotification *notification) {
                        NSArray *products = notification.userInfo[@"products"];
                        
                        NSLog(@"Got %lu products", (unsigned long)[products count]);
                        
                        self.products = products;
                    }];
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

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initObserver];
    }
    return self;
}

@end
