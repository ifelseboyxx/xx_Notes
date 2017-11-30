
//
//  ViewController.m
//  Hook_Delegate
//
//  Created by Jason on 2017/11/30.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    webView.delegate = self;
//    webView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:webView];
////    webView.delegate = self;
//
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]]];
    
     [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]]];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"*********** webViewDidStartLoad:");
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSLog(@"*********** webViewDidFinishLoad:");
//}

@end
