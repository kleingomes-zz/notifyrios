//
//  Biz.h
//  notifyr
//
//  Created by Nelson Narciso on 2014-04-25.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "Company.h"
#import "Product.h"
#import "EventType.h"

@interface Biz : NSObject

@property (nonatomic, strong) NSArray *interests;

@property (nonatomic, strong) NSArray *companies;

@property (nonatomic, strong) NSArray *products;

@property (nonatomic, strong) NSMutableDictionary *imageCache;


+ (Biz *)sharedBiz;

- (void)getInterests;

- (void)getArticlesForInterest:(Item *)interest;

- (void)getArticlesForItem:(Item *)item skip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion;

- (void)getArticlesForAllItemsWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion;

- (void)getArticlesForBreakingNewsWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion;



- (void)saveInterest:(Item *)interest withCompletionHandler:(void (^)(NSError *error))completionHandler;

- (void)deleteInterest:(Item *)interest withCompletionHandler:(void (^)(NSError *error))completionHandler;

- (void)getAvailableInterests:(NSString *)query withCompletionHandler:(void (^)(NSArray *availableInterests, NSError *error))completionHandler;


- (Company *)getCompanyById:(NSNumber *)companyId;

- (Product *)getProductById:(NSNumber *)productId;



@end
