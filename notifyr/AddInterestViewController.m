//
//  AddInterestViewController.m
//  notifyr
//
//  Created by Nelson Narciso on 2015-01-31.
//  Copyright (c) 2015 Nelson Narciso. All rights reserved.
//

#import "AddInterestViewController.h"
#import "Biz.h"
#import "ItemCell.h"
#import "Item.h"
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface AddInterestViewController ()

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSArray *popularItems;
@property (nonatomic) BOOL loading;
@property (nonatomic) BOOL isShowingPopular;

@end

@implementation AddInterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowingPopular = YES;
    [self loadPopularItems];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)startLoading {
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.frame  = CGRectInset(activityIndicatorView.frame, 0.0f, -20.0f);
    self.tableView.tableFooterView = activityIndicatorView;
    [activityIndicatorView startAnimating];
    self.loading = YES;
}

- (void)endLoading {
    self.loading = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)loadPopularItems
{
    [self startLoading];
    [[Biz sharedBiz] getPopularItemsWithCompletionHandler:^(NSArray *items, NSError *error) {
        if (error != nil)
        {
            NSLog(@"Error: %@", [error localizedDescription]);
            return;
        }
        
        self.popularItems = items;
        if (self.isShowingPopular)
        {
            self.items = self.popularItems;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self endLoading];
                [self.tableView reloadData];
            });
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.items) ? [self.items count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    NSLog(@"Row: %ld", (long)indexPath.row);
    NSLog(@"object: %@", self.items[indexPath.row]);
    id dummy = self.items[0];
    Item *item = self.items[indexPath.row];
    cell.nameLabel.text = item.itemName;
    
    //Set image. Check image cache first
    Biz *biz = [Biz sharedBiz];
    if (biz.imageCache[item.logoUrl])
    {
        cell.logoImageView.image = biz.imageCache[item.logoUrl];
    }
    else
    {
        [cell.logoImageView setImageWithURL:[NSURL URLWithString:item.logoUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error)
                {
                    NSLog(@"Invalid Image %@: %@", item.logoUrl, [error localizedDescription]);
                }
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    return cell;
}




/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

@end
