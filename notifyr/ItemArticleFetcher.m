//
//  ItemArticleFetcher.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-12-28.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "ItemArticleFetcher.h"
#import "Biz.h"

@implementation ItemArticleFetcher

- (NSString *)getTitle
{
    return self.item.itemName;
}

- (void)getArticlesWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion
{
    [[Biz sharedBiz] getArticlesForItem:self.item skip:skip take:take sortBy:sortBy completion:completion];
}

@end
