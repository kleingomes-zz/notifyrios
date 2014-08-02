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
#import "ArticleDetailsViewController.h"

@interface ArticlesViewController ()

@property (weak, nonatomic) IBOutlet UILabel *interestNameLabel;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) id articleObserver;

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
    [[Biz sharedBiz] getArticlesForInterest:self.interest];
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
        ArticleDetailsViewController *vc = (ArticleDetailsViewController *)segue.destinationViewController;
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

    self.navigationItem.title = self.interest.productName ? self.interest.productName : self.interest.companyName;
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
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InterestCell" forIndexPath:indexPath];
    
    Article *article = self.items[indexPath.row];
    cell.titleLabel.text = article.title ? article.title : @"[No Title]";
    cell.descriptionTextView.text = article.description;
    cell.authorLabel.text = article.author ? article.author : @"[No Author]";
    [cell.sourceButton setTitle:article.source ? article.source : @"[No Source]" forState:UIControlStateNormal];
    cell.score.text = [NSString stringWithFormat:@"%.1f", [article.score floatValue]];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:article.iUrl]];
        if (imgData) {
            UIImage *image = [UIImage imageWithData:imgData];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.mainImageView setImage:image];
                    //ArticleCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    //if (updateCell)
                        //updateCell.poster.image = image;
                });
            }
        }
    });
    
    
    return cell;
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
