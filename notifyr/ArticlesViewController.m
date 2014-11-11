//
//  InterestArticlesViewController.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-07-14.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "ArticlesViewController.h"
#import "Biz.h"
#import "Constants.h"
#import "ArticleCell.h"
#import "Article.h"
#import "ArticleWebViewController.h"
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "UIViewController+ECSlidingViewController.h"

@interface ArticlesViewController ()

@property (weak, nonatomic) IBOutlet UILabel *interestNameLabel;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) id articleObserver;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aspectRatoConstraint;

@end


@implementation ArticlesViewController

- (NSArray *)items
{
    if (!_items)
    {
        _items = [[NSMutableArray alloc] init];
        [self initItems];
    }
    return _items;
}

- (void)initItems
{
    if (self.interest == nil)
    {
        [[Biz sharedBiz] getArticlesForAllInterests];
    }
    else
    {
        [[Biz sharedBiz] getArticlesForInterest:self.interest];
    }
}

- (void)initObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
    self.articleObserver = [center addObserverForName:ArticlesUpdateNotification object:nil
                                                 queue:mainQueue usingBlock:^(NSNotification *notification) {
                                                     NSArray *articles = notification.userInfo[@"articles"];
                                                     
                                                     NSLog(@"Got %lu articles", (unsigned long)[articles count]);
                                                     
                                                     self.items = articles;
                                                     [self.refreshControl endRefreshing];
                                                     [self.tableView reloadData];
                                                 }];
}


- (void)refreshAction
{
    [[Biz sharedBiz] getInterests];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowArticle"])
    {
        ArticleWebViewController *vc = (ArticleWebViewController *)segue.destinationViewController;
        Article *article = self.items[[self.tableView indexPathForSelectedRow].row];
        vc.article = article;
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    NSString *title;
    if (self.interest != nil)
    {
        title = self.interest.productName ? self.interest.productName : self.interest.companyName;
    }
    else
    {
        title = @"All Interests";
    }
    
    self.titleLabel.text = title;
    self.navigationItem.title = title;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appTiles9.png"]];
    imageView.frame = self.tableView.frame;
    self.tableView.backgroundView = imageView;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.tableView.estimatedRowHeight = 350;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initObserver];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self.articleObserver];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = self.items[indexPath.row];
    ArticleCell *cell;

    BOOL hasImage = (article.iUrl && [article.iUrl length] > 0);
    if (hasImage)
    {
        BOOL isSmallImage = [article.iUrl containsString:@"gstatic"]; //TODO: replace this with a property in the article set by the server
        if (isSmallImage)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SmallImageCell" forIndexPath:indexPath];
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell" forIndexPath:indexPath];
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NoImageCell" forIndexPath:indexPath];
    }
    
    cell.titleLabel.text = article.title ? article.title : @"[No Title]";
    cell.descriptionLabel.text = article.articleDescription;
    cell.authorLabel.text = article.author ? article.author : @"[No Author]";
    cell.sourceLabel.text = article.source ? article.source : @"[No Source]";
    cell.score.text = [NSString stringWithFormat:@"%.1f", [article.score floatValue]];
    cell.dateLabel.text = [self convertDateToString:article.publishDate];
    //cell.mainImageView.image = nil; //todo replace with default image
    
    if (hasImage)
    {
        [cell.mainImageView setImageWithURL:[NSURL URLWithString:article.iUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error)
            {
                NSLog(@"Invalid Image %@: %@", article.iUrl, [error localizedDescription]);
            }
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    // Remove the border for the first cell
    if(indexPath.row == 0)
    {
        cell.borderLineView.hidden = true;
    }
    
    return cell;
}

- (NSString *)convertDateToString:(NSDate *)date
{
    NSTimeInterval secondsInDay = 60 * 60 * 24;
    NSTimeInterval secondsInHour = 60 * 60;
    NSTimeInterval secondsInMinute = 60;
    NSTimeInterval age = fabs(date.timeIntervalSinceNow);
    if (age > secondsInDay)
    {
        NSInteger daysAgo = round(age / secondsInDay);
        if(daysAgo > 1)
        {
            return [NSString stringWithFormat:@"%.0f days ago", round(age / secondsInDay)];
        }
        else
        {
            return [NSString stringWithFormat:@"%.0f day ago", round(age / secondsInDay)];
        }
    }
    else
    {
        if (age > secondsInHour)
        {
            NSInteger hoursAgo = round(age / secondsInHour);
            if(hoursAgo > 1)
            {
                return [NSString stringWithFormat:@"%.0f hours ago", round(age / secondsInHour)];
            }
            else
            {
                return [NSString stringWithFormat:@"%.0f hour ago", round(age / secondsInHour)];
            }
            
        }
        else
        {
            NSInteger minutesAgo = round(age / secondsInMinute);
            if(minutesAgo > 1)
            {
                return [NSString stringWithFormat:@"%.0f minutes ago", round(age / secondsInMinute)];
            }
            else
            {
                return [NSString stringWithFormat:@"%.0f minute ago", round(age / secondsInMinute)];
            }
            
        }
    }
}


- (IBAction)menuAction:(id)sender {
    //[self makeBlurredScreenshot];
    
    //self.slidingViewController.delegate = self.zoomController;
    
    
    if ([self.slidingViewController currentTopViewPosition] == ECSlidingViewControllerTopViewPositionAnchoredRight) {
        [self.slidingViewController resetTopViewAnimated:YES];
    }
    else
    {
        [self.slidingViewController anchorTopViewToRightAnimated:YES];
        self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGesturePanning | ECSlidingViewControllerAnchoredGestureTapping;
        
        self.slidingViewController.topViewController.view.layer.shadowOpacity = 0.75f;
        self.slidingViewController.topViewController.view.layer.shadowRadius = 10.0f;
        self.slidingViewController.topViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    }
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



@end
