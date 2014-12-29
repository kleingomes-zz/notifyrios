//
//  NotifyrApiClient.h
//  notifyr
//
//  Created by Nelson Narciso on 2014-05-12.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface NotifyrApiClient : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *accessToken;

- (void)getInterests;

- (void)getArticlesForInterest:(Item *)interest;

- (void)getArticlesForAllInterestsWithSort:(NSString *)sortOrder;

- (void)getCompaniesWithCompletionHandler:(void (^)(NSError *error))completionHandler;

- (void)getProductsWithCompletionHandler:(void (^)(NSError *error))completionHandler;

- (void)saveInterest:(Item *)interest withCompletionHandler:(void (^)(NSError *error))completionHandler;

- (void)deleteInterest:(Item *)interest withCompletionHandler:(void (^)(NSError *error))completionHandler;

- (void)getAvailableInterests:(NSString *)query withCompletionHandler:(void (^)(NSArray *availableInterests, NSError *error))completionHandler;


@end
