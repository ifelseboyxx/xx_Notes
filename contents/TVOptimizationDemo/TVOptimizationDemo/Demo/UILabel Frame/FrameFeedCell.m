//
//  FrameFeedCell.m
//  Demo
//
//  Created by lx13417 on 2017/9/4.
//  Copyright © 2017年 forkingdog. All rights reserved.
//

#import "FrameFeedCell.h"
#import "FrameModel.h"

@interface FrameFeedCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation FrameFeedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *title = [UILabel new];
    title.font = Font(16.f);
    title.numberOfLines = 0;
    title.layer.borderColor = [UIColor brownColor].CGColor;
    title.layer.cornerRadius = 1.f;
    title.layer.borderWidth = 1.f;
    [self.contentView addSubview:_titleLabel = title];
    
    UILabel *subTitle = [UILabel new];
    subTitle.font = Font(15.f);
    subTitle.numberOfLines = 0;
    subTitle.textColor = [UIColor darkGrayColor];
    subTitle.layer.borderColor = [UIColor redColor].CGColor;
    subTitle.layer.cornerRadius = 1.f;
    subTitle.layer.borderWidth = 1.f;
    [self.contentView addSubview:_subTitleLabel = subTitle];
    
    UILabel *content = [UILabel new];
    content.font = Font(14.f);
    content.numberOfLines = 0;
    content.textColor = [UIColor lightGrayColor];
    content.layer.borderColor = [UIColor greenColor].CGColor;
    content.layer.cornerRadius = 1.f;
    content.layer.borderWidth = 1.f;
    [self.contentView addSubview:_contentLabel = content];
    
    UILabel *username = [UILabel new];
    username.font = Font(13.f);
    username.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_usernameLabel = username];
    
    UILabel *time = [UILabel new];
    time.font = Font(12.f);
    time.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_timeLabel = time];
    
    return self;
}

- (void)setModel:(FrameModel *)model {
    if (!model) return;
    
    _model = model;
    
    FDFeedEntity *entity = model.entity;
    
    self.titleLabel.frame = model.titleFrame;
    self.titleLabel.text = entity.title;
    
    self.subTitleLabel.frame = model.subTitleFrame;
    self.subTitleLabel.attributedText = model.attributedSubTitle;
    
    self.contentLabel.frame = model.contentFrame;
    self.contentLabel.attributedText = model.attributedContent;
    
    self.usernameLabel.frame = model.usernameFrame;
    self.usernameLabel.text = entity.username;
    
    self.timeLabel.frame = model.timeFrame;
    self.timeLabel.text = entity.time;
    
}

@end
