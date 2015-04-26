//
//  ReceivedNotificationViewController.m
//  Notifyr
//
//  Created by Nelson Narciso on 2014-04-18.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "InterestsViewController.h"
#import "Item.h"
#import "InterestCell.h"
#import "Biz.h"
#import "ArticlesViewController.h"
#import "Constants.h"
#import "UIImage+ImageEffects.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEZoomAnimationController.h"
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "ItemArticleFetcher.h"

@interface InterestsViewController ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) id interestObserver;

@property (nonatomic, strong) MEZoomAnimationController *zoomController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableDictionary *sectionCounts;

@end


@implementation InterestsViewController

- (MEZoomAnimationController *) zoomController
{
    if (!_zoomController)
    {
        _zoomController = [[MEZoomAnimationController alloc] init];
    }
    return _zoomController;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0;
}

- (NSMutableDictionary *)sectionCounts
{
    if (_sectionCounts == nil)
    {
        _sectionCounts = [[NSMutableDictionary alloc] init];
    }
    return _sectionCounts;
}

- (NSMutableArray *)items
{
    if (!_items)
    {
        _items = [[NSMutableArray alloc] init];
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
        Item *item = [self getItemAtIndexPath:[self.tableView indexPathForSelectedRow]];
        ItemArticleFetcher *itemArticleFetcher = [[ItemArticleFetcher alloc] init];
        itemArticleFetcher.item = item;
        vc.delegate = itemArticleFetcher;
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
    
    self.interestObserver = [center addObserverForName:DeleteInterestNotification object:nil
                                                 queue:mainQueue usingBlock:^(NSNotification *notification) {
                                                     NSArray *interests = notification.userInfo[@"interests"];
                                                     
                                                     [self deleteItems:interests];
                                                     [self.refreshControl endRefreshing];
                                                     [self.tableView reloadData];
                                                 }];
}

- (void)updateInterests:(NSArray *)updatedInterests
{
    for (Item *updatedInterest in updatedInterests)
    {
        Item *foundInterest = nil;
        for (Item *interest in self.items)
        {
            if ([updatedInterest.itemId isEqualToNumber:interest.itemId])
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
    
    [self updateSectionCounts];
}

- (void)updateSectionCounts
{
    [self.sectionCounts removeAllObjects];
    for (Item *item in self.items)
    {
        if (self.sectionCounts[item.itemTypeName] == nil)
        {
            self.sectionCounts[item.itemTypeName] = @1;
        }
        else
        {
            NSInteger sectionCount = ((NSNumber *)self.sectionCounts[item.itemTypeName]).integerValue + 1;
            self.sectionCounts[item.itemTypeName] = @(sectionCount);
        }
    }
}

- (void)deleteItems:(NSArray *)deletedItems
{
    for (Item *deletedItem in deletedItems)
    {
        NSInteger i = 0;
        while (i < [self.items count])
        {
            Item *item = self.items[i];
            if ([item.itemId isEqualToNumber:deletedItem.itemId])
            {
                [self.items removeObjectAtIndex:i];
            }
            else
            {
                i++;
            }
        }
    }
    [self updateSectionCounts];
}

- (Item *)getItemMatchingItem:(Item *)itemToFind
{
    for (Item *item in self.items)
    {
        if ([item.itemId isEqualToNumber:itemToFind.itemId])
        {
            return item;
        }
    }
    return nil;
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
- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}
- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
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
    
    [self initItems];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
   // UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appTiles9.png"]];
   // imageView.frame = self.tableView.frame;
   // self.tableView.backgroundView = imageView;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStylePlain target:nil action:nil];
   // self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menuBG6.png"]];
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
    
    // deselect the table cell
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:false];
    
    //[self refreshAction];
//    UIColor *lightColour = [self getUIColorObjectFromHexString:@"346ADC" alpha:1];
//    UIColor *darkColour = [self getUIColorObjectFromHexString:@"5197E9" alpha:1];
//    self.navigationController.navigationBar.barTintColor = lightColour;
//    //   self.navigationController.navigationBar.tintColor = darkColour;
//    self.navigationController.navigationBar.translucent = NO;

}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    //NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    //[center removeObserver:self.interestObserver];
//}
- (void)viewWillDisappear:(BOOL)animated
{

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionCounts.allKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionName = self.sectionCounts.allKeys[section];

    return ((NSNumber *)self.sectionCounts[sectionName]).integerValue;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = self.sectionCounts.allKeys[section];

    return [NSString stringWithFormat:@" %@", sectionName];
}


- (Item *)getItemAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: optimize this
    NSInteger sectionCount = 0;
    NSString *sectionName = self.sectionCounts.allKeys[indexPath.section];
    
    for (Item *item in self.items)
    {
        if ([item.itemTypeName isEqualToString:sectionName])
        {
            if (sectionCount == indexPath.row)
            {
                return item;
            }
            sectionCount++;
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InterestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InterestCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    // Set row highlight colour
    UIView *highlightColour = [[UIView alloc] init];
    highlightColour.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:240.0f/255.0f blue:241.0f/255.0f alpha:1];
    [cell setSelectedBackgroundView:highlightColour];
    
    // Configure the cell...
    Item *interest = [self getItemAtIndexPath:indexPath];
    
    //cell.titleLabel.text = interest.title ? interest.title : @"[No company]";
    cell.companyNameLabel.text = interest.itemName;
    
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
    
    NSString *priorityString;
    if (interest.priority.integerValue == ItemPriorityHigh)
    {
        priorityString = @"High";
    }
    else if (interest.priority.integerValue == ItemPriorityMedium)
    {
        priorityString = @"Medium";
    }
    else if (interest.priority.integerValue == ItemPriorityLow)
    {
        priorityString = @"Low";
    }
    else
    {
        priorityString = @"Unknown";
    }

    cell.priorityLabel.text = [NSString stringWithFormat:@"Frequency: %@", priorityString];
    
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
        [self deleteItemAtIndexPath:indexPath];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self deleteItemAtIndexPath:indexPath];
    }];
    
    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Frequency" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self getPriorityForItemAtIndexPath:indexPath];
    }];
    moreAction.backgroundColor = [UIColor blueColor];
    
    return @[deleteAction, moreAction];
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Delete the row from the data source
    Item *interest = [self getItemAtIndexPath:indexPath];
    [[Biz sharedBiz] deleteInterest:interest withCompletionHandler:^(NSError *error) {
        NSLog(@"deleted");
    }];
    
    NSInteger sectionCount = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
    [self.items removeObject:[self getItemAtIndexPath:indexPath]];
    [self updateSectionCounts];
    
    //if only 1 item in section then delete the whole section
    if (sectionCount == 1)
    {
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)getPriorityForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = [self getItemAtIndexPath:indexPath];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Frequency" message:@"How many notifications would you like to receive per week?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"1 - 3" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        item.priority = @(ItemPriorityLow);
        [self saveItem:item];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"3 - 6" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        item.priority = @(ItemPriorityMedium);
        [self saveItem:item];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"7+" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        item.priority = @(ItemPriorityHigh);
        [self saveItem:item];
    }]];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)saveItem:(Item *)item
{
//    NSInteger row = [self.items indexOfObject:item];
//    if (row != NSNotFound)
//    {
//        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
    [[Biz sharedBiz] saveInterest:item withCompletionHandler:^(NSError *error) {
        
    }];
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor blackColor];
    header.textLabel.font = [UIFont boldSystemFontOfSize:15];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentLeft;
    // Background color
    view.tintColor = [UIColor colorWithRed:240/255.0 green:240/255.0  blue:240/255.0  alpha:1.0];
    
    // Text Color
    [header.textLabel setTextColor:[UIColor darkGrayColor]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
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
