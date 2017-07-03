//
//  ViewController.m
//  BtnEventsDemo
//
//  Created by Jason on 2017/7/3.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@property (strong, nonatomic) UIButton *btn1;
@property (strong, nonatomic) UIButton *btn2;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(100, 100, 60, 30);
    [btn1 setTitle:@"按钮一" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.view addSubview:_btn1 = btn1];
    [btn1 addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(170, 100, 60, 30);
    [btn2 setTitle:@"按钮二" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn2 setTitleColor:[UIColor redColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.view addSubview:_btn2 = btn2];
    [btn2 addTarget:self action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)btn1Click {
    if(_btn2.isSelected) {_btn2.selected = NO;}
    _btn1.selected = YES;
}

- (void)btn2Click {
    if(_btn1.isSelected) {_btn1.selected = NO;}
    _btn2.selected = YES;
    
}

@end
