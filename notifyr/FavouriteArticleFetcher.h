

#import <Foundation/Foundation.h>
#import "ArticlesViewController.h"


@interface FavouriteArticleFetcher : NSObject <ArticlesViewControllerDelegate>

- (void)getArticlesWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion;

@end
