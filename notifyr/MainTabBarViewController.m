//
//  MainTabBarViewController.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-12-28.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "ArticlesViewController.h"
#import "AllItemsArticleFetcher.h"
#import "BreakingNewsArticleFetcher.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

#define ALL_ITEMS_INDEX 0
#define BREAKING_NEWS_INDEX 2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.viewControllers[ALL_ITEMS_INDEX] isKindOfClass:[UINavigationController class]])
    {
        ArticlesViewController *allItemsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticlesViewController"];
        allItemsViewController.delegate = [[AllItemsArticleFetcher alloc] init];
        
        UINavigationController *navigationController = (UINavigationController *) self.viewControllers[ALL_ITEMS_INDEX];
        navigationController.viewControllers = @[allItemsViewController];
    }
    
    if ([self.viewControllers[BREAKING_NEWS_INDEX] isKindOfClass:[UINavigationController class]])
    {
        ArticlesViewController *breakingNewsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticlesViewController"];
        breakingNewsViewController.delegate = [[BreakingNewsArticleFetcher alloc] init];
        
        UINavigationController *navigationController = (UINavigationController *) self.viewControllers[BREAKING_NEWS_INDEX];
        navigationController.viewControllers = @[breakingNewsViewController];
    }
    
}

@end
