//
//  FDFeedCell.m
//  Demo
//
//  Created by sunnyxx on 15/4/17.
//  Copyright (c) 2015年 forkingdog. All rights reserved.
//

#define Font(font_size) [UIFont systemFontOfSize:(font_size)]

#import "FDFeedCell.h"
#import <YYText.h>

@interface FDFeedCell ()

@property (nonatomic, weak) IBOutlet YYLabel *titleLabel;
@property (nonatomic, weak) IBOutlet YYLabel *subTitleLabel;
@property (nonatomic, weak) IBOutlet YYLabel *contentLabel;
@property (nonatomic, weak) IBOutlet YYLabel *usernameLabel;
@property (nonatomic, weak) IBOutlet YYLabel *timeLabel;

@end

@implementation FDFeedCell

extern BOOL IBAsyn;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Fix the bug in iOS7 - initial constraints warning
    self.contentView.bounds = [UIScreen mainScreen].bounds;
    
    self.titleLabel.numberOfLines = 0;
    self.subTitleLabel.numberOfLines = 0;
    self.contentLabel.numberOfLines = 0;
    
    
    self.titleLabel.layer.borderColor = [UIColor brownColor].CGColor;
    self.titleLabel.layer.cornerRadius = 1.f;
    self.titleLabel.layer.borderWidth = 1.f;
    
    self.subTitleLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.subTitleLabel.layer.cornerRadius = 1.f;
    self.subTitleLabel.layer.borderWidth = 1.f;
    
    self.contentLabel.layer.borderColor = [UIColor greenColor].CGColor;
    self.contentLabel.layer.cornerRadius = 1.f;
    self.contentLabel.layer.borderWidth = 1.f;
    
    CGFloat maxLayout = [UIScreen mainScreen].bounds.size.width - 20.f;
    
    self.titleLabel.preferredMaxLayoutWidth = maxLayout;
    self.subTitleLabel.preferredMaxLayoutWidth = maxLayout;
    self.contentLabel.preferredMaxLayoutWidth = maxLayout;
    
    BOOL asyn = IBAsyn;
    
    self.titleLabel.displaysAsynchronously = asyn;
    self.subTitleLabel.displaysAsynchronously = asyn;
    self.contentLabel.displaysAsynchronously = asyn;
    self.usernameLabel.displaysAsynchronously = asyn;
    self.timeLabel.displaysAsynchronously = asyn;
    
    self.titleLabel.font = Font(16.f);
    self.subTitleLabel.font = Font(15.f);
    self.contentLabel.font = Font(14.f);
    self.usernameLabel.font = Font(13.f);
    self.timeLabel.font = Font(12.f);
}

- (void)setEntity:(FDFeedEntity *)entity
{
    _entity = entity;
    
    self.titleLabel.text = entity.title;
    
    
    NSMutableAttributedString *subTitle = [[NSMutableAttributedString alloc] initWithString:entity.subTitle];
    subTitle.yy_font = Font(15.f);
    subTitle.yy_color = [UIColor darkGrayColor];
    [subTitle yy_setFont:Font(30.f) range:NSMakeRange(0, 2)];
    [subTitle yy_setColor:[UIColor redColor] range:NSMakeRange(0, 2)];
    self.subTitleLabel.attributedText = subTitle;
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:entity.content];
    content.yy_font = Font(14.f);
    content.yy_color = [UIColor lightGrayColor];
    [content yy_setFont:Font(20.f) range:NSMakeRange(5, 10)];
    [content yy_setColor:[UIColor greenColor] range:NSMakeRange(5, 10)];
    self.contentLabel.attributedText = content;
    
    
    self.usernameLabel.text = entity.username;
    self.timeLabel.text = entity.time;
}

@end
