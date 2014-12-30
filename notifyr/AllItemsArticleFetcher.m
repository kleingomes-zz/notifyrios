//
//  AllItemsArticleFetcher.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-12-28.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "AllItemsArticleFetcher.h"
#import "Biz.h"

@implementation AllItemsArticleFetcher

- (NSString *)getTitle
{
    return @"My News";
}

- (void)getArticlesWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion
{
    [[Biz sharedBiz] getArticlesForAllItemsWithSkip:skip take:take sortBy:sortBy completion:completion];
}

@end
