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

@interface InterestsViewController ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) id interestObserver;

@end


@implementation InterestsViewController

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

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initObserver];
    [self refreshAction];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self.interestObserver];
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
    InterestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InterestCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Interest *interest = self.items[indexPath.row];
    //cell.titleLabel.text = interest.title ? interest.title : @"[No company]";
    cell.companyNameLabel.text = interest.companyName ? interest.companyName : @"[No company]";
    cell.productNameLabel.text = interest.productName ? interest.productName : @"";
    cell.eventTypeLabel.text = [NSString stringWithFormat:@"Type: %@", interest.eventTypeName ? interest.eventTypeName : @"[No Event Type]"];
    
    
    static NSNumberFormatter *numberFormatter = nil;
    if (!numberFormatter)
    {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setGroupingSeparator:@","];
    }
    
    cell.stockQuote.text = [numberFormatter stringFromNumber:interest.stockQuote];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
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
