//
//  InterestArticlesViewController.h
//  notifyr
//
//  Created by Nelson Narciso on 2014-07-14.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@protocol ArticlesViewControllerDelegate <NSObject>

- (NSString *)getTitle;
- (void)getArticlesWithSkip:(NSInteger)skip take:(NSInteger)take sortBy:(NSString *)sortBy completion:(void(^)(NSArray *articles, NSError *error))completion;

@end


@interface ArticlesViewController : UITableViewController

@property (nonatomic, strong) id<ArticlesViewControllerDelegate> delegate;

@end
