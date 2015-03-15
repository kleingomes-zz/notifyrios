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
#import "FavouriteArticleFetcher.h"
#import "AppDelegate.h"
#import "ArticleWebViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

#define ALL_ITEMS_INDEX 1
#define BREAKING_NEWS_INDEX 2
#define FAVOURITES_INDEX 3

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
    
    if ([self.viewControllers[FAVOURITES_INDEX] isKindOfClass:[UINavigationController class]])
    {
        ArticlesViewController *favouritesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticlesViewController"];
        favouritesViewController.delegate = [[FavouriteArticleFetcher alloc] init];
        
        UINavigationController *navigationController = (UINavigationController *) self.viewControllers[FAVOURITES_INDEX];
        navigationController.viewControllers = @[favouritesViewController];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.startingArticle != nil)
    {
        [self showArticle:appDelegate.startingArticle];
        appDelegate.startingArticle = nil;
    }
}

- (void)showArticle:(Article *)article
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setSelectedIndex:ALL_ITEMS_INDEX];
        
        ArticleWebViewController *articleWebViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleWebViewController"];
        articleWebViewController.article = article;
        
        UINavigationController *allItemsNavigationController = self.viewControllers[ALL_ITEMS_INDEX];
        [allItemsNavigationController pushViewController:articleWebViewController animated:YES];
    });
}

@end
