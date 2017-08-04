//
//  TestTestTableViewCell.m
//  ResponderChainDemo
//
//  Created by lx13417 on 2017/8/3.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//

#import "TestTestTableViewCell.h"
#import "UIResponder+Router.h"

NSString * const TestTestTableViewCellIdentifier = @"TestTestTableViewCell";

@interface TestTestTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *btn1;

@end

@implementation TestTestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    
    [self.btn1 setTitle:subTitle forState:UIControlStateNormal];

}

- (IBAction)btnClick1:(UIButton *)sender {
    
    [self routerEventWithSelectorName:@"btnClick1:userInfo:" object:sender userInfo:@{@"key":@"蓝色按钮"}];
    
}

- (IBAction)btnClick2:(UIButton *)sender {
    
    [self routerEventWithSelectorName:@"btnClick2:userInfo:" object:sender userInfo:@{@"key":@"蓝色按钮"}];
}



@end
