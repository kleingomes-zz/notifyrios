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

- (IBAction)sharePressed:(id)sender {
    NSString *notifyrString = @"Sent From NotifyR";
    
    NSString *shareString = [NSString stringWithFormat:@"%@\n\n%@\n\n%@",self.article.title,self.article.url,notifyrString];
    
    NSArray *activityItems = @[shareString];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController animated:YES completion:^{
    }];
}

@end
