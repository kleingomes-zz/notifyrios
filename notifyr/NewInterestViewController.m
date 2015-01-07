//
//  NewInterestViewController.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-07-19.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "NewInterestViewController.h"
#import "Biz.h"
#import "AvailableInterest.h"
#import "Item.h"
#import <QuartzCore/QuartzCore.h>
@interface NewInterestViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UISlider *notificationPrioritySlider;
@property (weak, nonatomic) IBOutlet UILabel *notFoundLabel;
@property (weak, nonatomic) IBOutlet UIView *saveIndicatorView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) UITableView *suggestionsTableView;
@property (strong, nonatomic) NSArray *allSuggestedInterests;
@property (strong, nonatomic) NSMutableArray *suggestedInterests;
@property (weak, nonatomic) IBOutlet UIView *sampleView;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *sampleViews;
@property (weak, nonatomic) IBOutlet UITextField *addInterestTxtField;
@property (weak, nonatomic) IBOutlet UITextField *addInterestsTxtField;
@property (weak, nonatomic) IBOutlet UITextField *addItemTxtField;


@end

@implementation NewInterestViewController

- (NSMutableArray *)suggestedInterests
{
    if (!_suggestedInterests)
    {
        _suggestedInterests = [[NSMutableArray alloc] init];
    }
    return _suggestedInterests;
}


- (IBAction)createAction:(id)sender
{
    Item *interest = [self getInterestFromUI];
    if (interest)
    {
        [self saveInterest:[self getInterestFromUI]];
    }
    else
    {
        NSLog(@"Interest not found");
    }
}

- (Item *)getInterestFromUI
{
    NSString *text = [self.inputField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    AvailableInterest *foundAvailableInterest = nil;
    for (AvailableInterest *availableInterest in self.allSuggestedInterests)
    {
        if ([availableInterest.name caseInsensitiveCompare:text] == NSOrderedSame)
        {
            foundAvailableInterest = availableInterest;
            break;
        }
    }
 
    if (foundAvailableInterest)
    {
        Item *interest = [[Item alloc] init];
        
        return interest;
    }
    
    return nil;
}

- (void)saveInterest:(Item *)interest
{
    self.saveIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
    [[Biz sharedBiz] saveInterest:interest withCompletionHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.saveIndicatorView.hidden = YES;
            [self.activityIndicatorView stopAnimating];

        });
        if (!error)
        {
            NSLog(@"Save worked");
        }
        else
        {
            NSLog(@"Save failed");
        }
    }];
}

- (void)showSuggestionsForText:(NSString *)text
{
    if (self.allSuggestedInterests == nil || [self.allSuggestedInterests count] < 1)
    {
        return;
    }
    
    self.suggestionsTableView.hidden = NO;
    [self.suggestedInterests removeAllObjects];
    
    for(AvailableInterest *availableInterest in self.allSuggestedInterests)
    {
        NSRange substringRange = [availableInterest.name rangeOfString:text options:NSCaseInsensitiveSearch];
        if (substringRange.location != NSNotFound)
        {
            [self.suggestedInterests addObject:availableInterest];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.suggestionsTableView reloadData];
    });    
}

- (void)hideKeyboard
{
    [self.inputField resignFirstResponder];
}

#pragma mark - TextField Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //NSLog(@"You entered %@",self.inputField.text);
    
    [self hideKeyboard];
    self.suggestionsTableView.hidden = YES;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //NSLog(@"%@", newString);
    
    if ([newString length] == 2)
    {
        [[Biz sharedBiz] getAvailableInterests:newString withCompletionHandler:^(NSArray *availableInterests, NSError *error) {
            self.allSuggestedInterests = availableInterests;
            //for (AvailableInterest *availableInterest in availableInterests)
            //{
            //    NSLog(@"%@", availableInterest.name);
            //}
            [self showSuggestionsForText:newString];
        }];
    }
    else if ([newString length] < 2)
    {
        self.allSuggestedInterests = nil;
        self.suggestionsTableView.hidden = YES;
    }
    else
    {
        [self showSuggestionsForText:newString];
    }
    
    return YES;
}


#pragma mark - TableView Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    
    AvailableInterest *availableInterest = self.suggestedInterests[indexPath.row];
    cell.textLabel.text = availableInterest.name;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.suggestedInterests) ? [self.suggestedInterests count] : 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AvailableInterest *availableInterest = self.suggestedInterests[indexPath.row];
    self.inputField.text = availableInterest.name;
    self.suggestionsTableView.hidden = YES;
    [self hideKeyboard];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.inputField.delegate = self;
    
  //  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"appTiles3.fix.png"]];
    //self.suggestionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, 320, 120) style:UITableViewStylePlain];
    self.suggestionsTableView = [[UITableView alloc] initWithFrame:
                                 CGRectMake(0, self.inputField.frame.origin.y + self.inputField.frame.size.height, self.view.frame.size.width, 200)
                                                             style: UITableViewStylePlain];
    
    self.suggestionsTableView.delegate = self;
    self.suggestionsTableView.dataSource = self;
    self.suggestionsTableView.scrollEnabled = YES;
    self.suggestionsTableView.hidden = YES;
    [self.view addSubview:self.suggestionsTableView];
    _btnNext.layer.borderWidth=1.0f;
    _btnNext.layer.borderColor=[[UIColor whiteColor] CGColor];
    
   // [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
   //                                               forBarMetrics:UIBarMetricsDefault];
   // self.navigationController.navigationBar.shadowImage = [UIImage new];
   // self.navigationController.navigationBar.translucent = YES;
   // self.navigationController.view.backgroundColor = [UIColor clearColor];
    //Adds a shadow to sampleView
    
    // Add a drop shadow to the views
    for (UIView *aLabel in self.sampleViews) {
         CALayer *layer = aLabel.layer;
         layer.shadowOffset = CGSizeMake(1, 1);
         layer.shadowColor = [[UIColor blackColor] CGColor];
         layer.shadowRadius = 1.50f;
         layer.shadowOpacity = 0.30f;
         layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
