//
//  ReceivedNotificationViewController.m
//  Notifyr
//
//  Created by Nelson Narciso on 2014-04-18.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "InterestsViewController.h"
#import "Interest.h"
#import "InterestCell.h"
#import "Biz.h"
#import "ArticlesViewController.h"
#import "Constants.h"
#import "UIImage+ImageEffects.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEZoomAnimationController.h"
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface InterestsViewController ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) id interestObserver;

@property (nonatomic, strong) MEZoomAnimationController *zoomController;

@end


@implementation InterestsViewController

#define INTEREST_SECTION 0
#define ADD_NEW_SECTION 1

- (MEZoomAnimationController *) zoomController
{
    if (!_zoomController)
    {
        _zoomController = [[MEZoomAnimationController alloc] init];
    }
    return _zoomController;
}

- (NSMutableArray *)items
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
    [[Biz sharedBiz] getInterests];
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

- (void)makeBlurredScreenshot
{
    //UIGraphicsBeginImageContext(self.view.window.bounds.size);
    //[self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *lightImage = [newImage applyLightEffect];

    [self.view addSubview:[[UIImageView alloc] initWithImage:lightImage]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"ShowInterestArticles"])
    {
        ArticlesViewController *vc = (ArticlesViewController *)segue.destinationViewController;
        Interest *interest = self.items[[self.tableView indexPathForSelectedRow].row];
        vc.interest = interest;
    }
}


- (void)initObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
    self.interestObserver = [center addObserverForName:InterestsUpdateNotification object:nil
                                                     queue:mainQueue usingBlock:^(NSNotification *notification) {
                                                         NSArray *interests = notification.userInfo[@"interests"];
                                                         
                                                         NSLog(@"Got %lu interests", (unsigned long)[interests count]);
                                                         
                                                         [self updateInterests:interests];
                                                         [self.refreshControl endRefreshing];
                                                         [self.tableView reloadData];
                                                     }];
}

- (void)updateInterests:(NSArray *)updatedInterests
{
    for (Interest *updatedInterest in updatedInterests)
    {
        Interest *foundInterest = nil;
        for (Interest *interest in self.items)
        {
            if ([updatedInterest.interestId isEqualToNumber:interest.interestId])
            {
                foundInterest = interest;
                break;
            }
        }
        if (foundInterest)
        {
            //todo: update interest
        }
        else
        {
            [self.items addObject:updatedInterest];
        }
    }
}

- (void)refreshAction
{
    [[Biz sharedBiz] getInterests];
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
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    if (!_interestObserver)
    {
        [self initObserver];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appTiles9.png"]];
    imageView.frame = self.tableView.frame;
    self.tableView.backgroundView = imageView;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStylePlain target:nil action:nil];
    
   // UIButton *btnName = [UIButton buttonWithType:UIButtonTypeCustom];
   // [btnName setFrame:CGRectMake(0, 0, 44, 44)];
   // [btnName setBackgroundImage:[UIImage imageNamed:@"appbar.add.new.png"] forState:UIControlStateNormal];
   // [btnName addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //UIBarButtonItem *locationItem = [[UIBarButtonItem alloc] initWithCustomView:btnName];
    //self.navigationItem.rightBarButtonItem = locationItem;

  //  self.navigationController.view.backgroundColor = [UIColor colorWithRed:52/255.0 green:106/255.0  blue:220/255.0  alpha:1.0];
}

- (IBAction)addAction:(id)sender
{
    [self performSegueWithIdentifier:@"AddNew" sender:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self refreshAction];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //[center removeObserver:self.interestObserver];
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
    if (section == INTEREST_SECTION)
    {
        return [self.items count];
    }
    else
    {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == INTEREST_SECTION)
    {
        InterestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InterestCell" forIndexPath:indexPath];
        
        // Configure the cell...
        Interest *interest = self.items[indexPath.row];
        //cell.titleLabel.text = interest.title ? interest.title : @"[No company]";
        cell.companyNameLabel.text = interest.productName ? interest.productName :interest.companyName ;
        cell.productNameLabel.text = interest.productName ? interest.productName : @"";
        cell.eventTypeLabel.text = [NSString stringWithFormat:@"Type: %@", interest.eventTypeName ? interest.eventTypeName : @"[No Event Type]"];
        
        static NSNumberFormatter *numberFormatter = nil;
        if (!numberFormatter)
        {
            numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [numberFormatter setGroupingSeparator:@","];
        }
        
        //cell.stockQuote.text = [NSString stringWithFormat:@"%@%@%@",@"$", [numberFormatter stringFromNumber:interest.stockQuote], @" (+2.42)"];
       // cell.stockQuote.text = [NSString stringWithFormat:@"%@",@"(+2.42)"];
        
        //Set image. Check image cache first
        Biz *biz = [Biz sharedBiz];
        if (biz.imageCache[interest.logoUrl])
        {
            cell.logoImageView.image = biz.imageCache[interest.logoUrl];
        }
        else
        {
            [cell.logoImageView setImageWithURL:[NSURL URLWithString:interest.logoUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error)
                {
                    NSLog(@"Invalid Image %@: %@", interest.logoUrl, [error localizedDescription]);
                }
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddNewCell" forIndexPath:indexPath];
        return cell;
    }
    
    
    /*
    cell.contentView.backgroundColor = [UIColor clearColor];
    //UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(10,10,300,70)];
    UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(10,5,300,70)];
    whiteRoundedCornerView.backgroundColor = [UIColor whiteColor];
    whiteRoundedCornerView.layer.masksToBounds = NO;
    whiteRoundedCornerView.layer.cornerRadius = 3.0;
    whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1);
    whiteRoundedCornerView.layer.shadowOpacity = 0.2;
    whiteRoundedCornerView.alpha = 0.95;
    [cell.contentView addSubview:whiteRoundedCornerView];
    [cell.contentView sendSubviewToBack:whiteRoundedCornerView];
     */
    
    
//    UIView *bgColorView = [[UIView alloc] init];
//    bgColorView.backgroundColor = [UIColor redColor];
//    [cell setSelectedBackgroundView:bgColorView];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return indexPath.section == INTEREST_SECTION;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        Interest *interest = self.items[indexPath.row];
        [[Biz sharedBiz] deleteInterest:interest withCompletionHandler:^(NSError *error) {
            NSLog(@"deleted");
        }];
        
        [self.items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
