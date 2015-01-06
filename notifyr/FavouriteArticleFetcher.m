

#import "BreakingNewsArticleFetcher.h"
#import "Biz.h"

@implementation FavouriteArticleFetcher

- (NSString *)getTitle
{
    return @"Saved Articles";
}

- (void)getArticlesWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion
{
    [[Biz sharedBiz] getArticlesForBreakingNewsWithSkip:skip take:take sortBy:sortBy completion:completion];
}

@end
