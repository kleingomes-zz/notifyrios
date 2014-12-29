//
//  AllItemsArticleFetcher.h
//  notifyr
//
//  Created by Nelson Narciso on 2014-12-28.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticlesViewController.h"

@interface AllItemsArticleFetcher : NSObject <ArticlesViewControllerDelegate>

- (void)getArticlesWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion;

@end
