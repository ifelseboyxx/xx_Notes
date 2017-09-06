//
//  FrameYYFeedCell.m
//  Demo
//
//  Created by lx13417 on 2017/9/5.
//  Copyright © 2017年 forkingdog. All rights reserved.
//

#import "FrameYYFeedCell.h"
#import "FrameYYModel.h"
#import <YYLabel.h>

#define Font(font_size) [UIFont systemFontOfSize:(font_size)]

@interface FrameYYFeedCell ()

@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, strong) YYLabel *subTitleLabel;
@property (nonatomic, strong) YYLabel *contentLabel;
@property (nonatomic, strong) YYLabel *usernameLabel;
@property (nonatomic, strong) YYLabel *timeLabel;

@end

@implementation FrameYYFeedCell

extern BOOL frameAsyn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    YYLabel *title = [YYLabel new];
    title.layer.borderColor = [UIColor brownColor].CGColor;
    title.layer.cornerRadius = 1.f;
    title.layer.borderWidth = 1.f;
    [self.contentView addSubview:_titleLabel = title];
    
    YYLabel *subTitle = [YYLabel new];
    subTitle.layer.borderColor = [UIColor redColor].CGColor;
    subTitle.layer.cornerRadius = 1.f;
    subTitle.layer.borderWidth = 1.f;
    [self.contentView addSubview:_subTitleLabel = subTitle];
    
    YYLabel *content = [YYLabel new];
    content.layer.borderColor = [UIColor greenColor].CGColor;
    content.layer.cornerRadius = 1.f;
    content.layer.borderWidth = 1.f;
    [self.contentView addSubview:_contentLabel = content];
    
    YYLabel *username = [YYLabel new];
    [self.contentView addSubview:_usernameLabel = username];
    
    YYLabel *time = [YYLabel new];
    [self.contentView addSubview:_timeLabel = time];
    
    
    BOOL asyn = frameAsyn;
    
    title.displaysAsynchronously = asyn;
    subTitle.displaysAsynchronously = asyn;
    content.displaysAsynchronously = asyn;
    username.displaysAsynchronously = asyn;
    time.displaysAsynchronously = asyn;
    
    title.ignoreCommonProperties = asyn;
    subTitle.ignoreCommonProperties = asyn;
    content.ignoreCommonProperties = asyn;
    username.ignoreCommonProperties = asyn;
    time.ignoreCommonProperties = asyn;
    
    
    
    return self;
}

- (void)setModel:(FrameYYModel *)model {
    if (!model) return;
    _model = model;
    
    self.titleLabel.frame = model.titleFrame;
    self.titleLabel.textLayout = model.titleLayout;
    
    self.subTitleLabel.frame = model.subTitleFrame;
    self.subTitleLabel.textLayout = model.subTitleLayout;
    
    self.contentLabel.frame = model.contentFrame;
    self.contentLabel.textLayout = model.contentLayout;
    
    self.usernameLabel.frame = model.usernameFrame;
    self.usernameLabel.textLayout = model.usernameLayout;
    
    self.timeLabel.frame = model.timeFrame;
    self.timeLabel.textLayout = model.timeLayout;
}

@end
