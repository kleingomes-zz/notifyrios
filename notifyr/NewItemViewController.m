//
//  AddInterestViewController.m
//  notifyr
//
//  Created by Nelson Narciso on 2015-01-31.
//  Copyright (c) 2015 Nelson Narciso. All rights reserved.
//

#import "NewItemViewController.h"
#import "Biz.h"
#import "ItemCell.h"
#import "Item.h"
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface NewItemViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSArray *popularItems;
@property (strong, nonatomic) NSArray *suggestedItems;
@property (strong, nonatomic) NSMutableArray *userItems;
@property (strong, nonatomic) NSArray *originalUserItems;
@property (nonatomic) BOOL loading;
@property (nonatomic) BOOL isShowingPopular;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@end

@implementation NewItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputTextField.delegate = self;
    self.isShowingPopular = YES;
    [self loadPopularItems];
    
    [self loadUserItems]; //temporary
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)loadUserItems //this is temporary, it should be passed in
{
    [[Biz sharedBiz] getUserItemsWithCompletion:^(NSArray *items, NSError *error) {
        self.userItems = [[NSMutableArray alloc] initWithArray:items];
        self.originalUserItems = items;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (NSMutableArray *)userItems
{
    if (_userItems == nil)
    {
        _userItems = [[NSMutableArray alloc] init];
    }
    return _userItems;
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
    
    Item *item = self.items[indexPath.row];
    cell.nameLabel.text = item.itemName;
    
    if (item.logoUrl != nil)
    {
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
    }
    
    if ([self userHasItem:item])
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.isShowingPopular)
    {
        return @"Popular";
    }
    else
    {
        return @"Results";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = self.items[indexPath.row];
    Item *userItem = [self getUserItemMatchingItem:item];
    if (userItem != nil)
    {
        [self.userItems removeObject:userItem];
        [[Biz sharedBiz] deleteInterest:item withCompletionHandler:^(NSError *error) {
            if (error != nil)
            {
                NSLog(@"Error deleting item: %@", [error localizedDescription]);
            }
        }];
    }
    else
    {
        [self.userItems addObject:item];
        [[Biz sharedBiz] saveInterest:item withCompletionHandler:^(NSError *error) {
            if (error != nil)
            {
                NSLog(@"Error saving item: %@", [error localizedDescription]);
            }
        }];
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //NSLog(@"%@", newString);
    
    if ([newString length] == 0)
    {
        self.items = self.popularItems;
        self.isShowingPopular = YES;
        [self.tableView reloadData];
        return YES;
    }
    
    self.isShowingPopular = NO;
    
    if ([newString length] >= 2)
    {
        [self startLoading];
        [[Biz sharedBiz] getAvailableInterests:newString withCompletionHandler:^(NSArray *availableInterests, NSError *error) {
            self.suggestedItems = availableInterests;
            self.items = self.suggestedItems;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self endLoading];
                [self.tableView reloadData];
            });
        }];
    }
    else if ([newString length] < 2)
    {
        self.items = nil;
        self.suggestedItems = nil;
        [self.tableView reloadData];
    }
    
    return YES;
}


#pragma mark - Convience Methods

- (BOOL)userHasItem:(Item *)item
{
    return [self getUserItemMatchingItem:item] != nil;
}

- (Item *)getUserItemMatchingItem:(Item *)item
{
    for (Item *userItem in self.userItems)
    {
        if ([userItem.itemId isEqualToNumber:item.itemId])
        {
            return userItem;
        }
    }
    return nil;
}


@end
