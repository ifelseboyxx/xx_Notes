//
//  FDLabelCell.m
//  Demo
//
//  Created by lx13417 on 2017/9/5.
//  Copyright © 2017年 forkingdog. All rights reserved.
//

#import "FDLabelCell.h"

@interface FDLabelCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end

@implementation FDLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.layer.borderColor = [UIColor brownColor].CGColor;
    self.titleLabel.layer.cornerRadius = 1.f;
    self.titleLabel.layer.borderWidth = 1.f;
    
    self.subTitleLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.subTitleLabel.layer.cornerRadius = 1.f;
    self.subTitleLabel.layer.borderWidth = 1.f;
    
    self.contentLabel.layer.borderColor = [UIColor greenColor].CGColor;
    self.contentLabel.layer.cornerRadius = 1.f;
    self.contentLabel.layer.borderWidth = 1.f;
}

- (void)setEntity:(FDFeedEntity *)entity
{
    _entity = entity;
    
    self.titleLabel.text = entity.title;
    self.subTitleLabel.text = entity.subTitle;
    self.contentLabel.text = entity.content;
    self.usernameLabel.text = entity.username;
    self.timeLabel.text = entity.time;
}

@end
