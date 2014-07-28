//
//  NewInterestViewController.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-07-19.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "NewInterestViewController.h"
#import "Biz.h"

@interface NewInterestViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UISlider *notificationPrioritySlider;

@end

@implementation NewInterestViewController


- (IBAction)createAction:(id)sender {
    //[self saveInterestWithName:self.inputField.text priority:50];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //NSLog(@"You entered %@",self.inputField.text);
    
    [[Biz sharedBiz] getAvailableInterests:textField.text withCompletionHandler:^(NSArray *availableInterests, NSError *error) {
        
    }];

    
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //NSLog(@"%@", newString);
    
    //if ([newString length] > 1)
    //{
        
    //}
    
    return YES;
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
