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


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSURL *websiteUrl = [NSURL URLWithString:@"http://www.google.com"];
    NSURL *websiteUrl = [NSURL URLWithString:self.article.url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [self.webView loadRequest:urlRequest];
}


@end
