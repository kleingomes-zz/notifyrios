

#import "FavouriteArticleFetcher.h"
#import "Biz.h"

@implementation FavouriteArticleFetcher

- (NSString *)getTitle
{
    return @"My Favourites";
}

- (void)getArticlesWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion
{
    [[Biz sharedBiz] getArticlesForFavouritesWithSkip:skip take:take sortBy:sortBy completion:completion];
}

@end
