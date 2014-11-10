//
//  ArticleWebViewController.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-08-02.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "ArticleWebViewController.h"

@interface ArticleWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end


@implementation ArticleWebViewController

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSURL *websiteUrl = [NSURL URLWithString:@"http://www.google.com"];
    NSURL *websiteUrl = [NSURL URLWithString:self.article.url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [self.webView loadRequest:urlRequest];
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
