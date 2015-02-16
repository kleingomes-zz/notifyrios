//
//  NotifyrApiClient.h
//  notifyr
//
//  Created by Nelson Narciso on 2014-05-12.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "Article.h"
@interface NotifyrApiClient : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *accessToken;

- (void)getInterests;


//Articles

- (void)getArticlesForInterest:(Item *)interest;

- (void)getArticlesForItem:(Item *)item skip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion;

- (void)getArticlesForAllItemsWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion;

- (void)getArticlesForBreakingNewsWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion;

- (void)getArticlesForFavouritesWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion;

- (void)addFavourite:(Article *)article withCompletionHandler:(void (^)(NSError *error))completionHandler;

- (void)deleteFavourite:(Article *)article withCompletionHandler:(void (^)(NSError *error))completionHandler;

//Items

- (void)getUserItemsWithWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *items, NSError *error)) completion;

- (void)getPopularItemsWithCompletionHandler:(void (^)(NSArray *items, NSError *error))completionHandler;



- (void)getCompaniesWithCompletionHandler:(void (^)(NSError *error))completionHandler;

- (void)getProductsWithCompletionHandler:(void (^)(NSError *error))completionHandler;

- (void)saveInterest:(Item *)interest withCompletionHandler:(void (^)(NSError *error))completionHandler;

- (void)deleteInterest:(Item *)interest withCompletionHandler:(void (^)(NSError *error))completionHandler;

- (void)getAvailableInterests:(NSString *)query withCompletionHandler:(void (^)(NSArray *availableInterests, NSError *error))completionHandler;



@end
