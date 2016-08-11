//
//  ViewController.m
//  Dcloud_iOS_SDKDemo
//
//  Created by liuhaiyuan on 16/8/8.
//  Copyright © 2016年 liuhaiyuan. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import "WebAppController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}
- (IBAction)didOnClickedWithWebView:(id)sender {
    
    WebViewController *webView = [[WebViewController alloc] init];
    
    [self.navigationController pushViewController:webView animated:YES];
}
- (IBAction)didOnClickedWithWidget:(id)sender {
    
    WebAppController *webApp = [[WebAppController alloc] init];
    
    [self.navigationController pushViewController:webApp animated:YES];
}

@end
