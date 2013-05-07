//
//  Wiki.m
//  Countries
//
//  Created by TOM on 5/7/13.
//  Copyright (c) 2013 TOM. All rights reserved.
//

#import "Wiki.h"

@interface Wiki ()
@property(strong,nonatomic) UIWebView* wiki;
@end

@implementation Wiki

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; }
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{ [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wiki = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.wiki.scalesPageToFit = YES;
    [self.view addSubview:self.wiki];
    NSURL *url = [NSURL URLWithString:self.link];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wiki loadRequest:request];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
