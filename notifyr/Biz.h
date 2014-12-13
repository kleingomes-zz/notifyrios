//
//  Biz.h
//  notifyr
//
//  Created by Nelson Narciso on 2014-04-25.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Interest.h"
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

- (void)getArticlesForInterest:(Interest *)interest;

- (void)getArticlesForAllInterestsWithSort:(NSString *)sortOrder;

- (void)saveInterest:(Interest *)interest withCompletionHandler:(void (^)(NSError *error))completionHandler;

- (void)deleteInterest:(Interest *)interest withCompletionHandler:(void (^)(NSError *error))completionHandler;

- (void)getAvailableInterests:(NSString *)query withCompletionHandler:(void (^)(NSArray *availableInterests, NSError *error))completionHandler;


- (Company *)getCompanyById:(NSNumber *)companyId;

- (Product *)getProductById:(NSNumber *)productId;



@end
