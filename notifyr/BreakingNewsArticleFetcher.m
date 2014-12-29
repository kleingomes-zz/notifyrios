//
//  BreakingNewsArticleFetcher.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-12-28.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "BreakingNewsArticleFetcher.h"
#import "Biz.h"

@implementation BreakingNewsArticleFetcher

- (NSString *)getTitle
{
    return @"Breaking News";
}

- (void)getArticlesWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion
{
    [[Biz sharedBiz] getArticlesForBreakingNewsWithSkip:skip take:take sortBy:sortBy completion:completion];
}

@end
