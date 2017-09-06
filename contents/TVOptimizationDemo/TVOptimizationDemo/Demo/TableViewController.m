//
//  TableViewController.m
//  Demo
//
//  Created by lx13417 on 2017/9/5.
//  Copyright © 2017年 forkingdog. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

BOOL IBAsyn = NO;
- (IBAction)switch0ne:(UISwitch *)sender {
    IBAsyn = sender.on;
}

BOOL frameAsyn = NO;
- (IBAction)switchTwo:(UISwitch *)sender {
    
    frameAsyn = sender.on;
    
}


@end
