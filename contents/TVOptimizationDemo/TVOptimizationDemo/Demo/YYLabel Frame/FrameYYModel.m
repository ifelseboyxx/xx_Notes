//
//  FrameYYModel.m
//  Demo
//
//  Created by lx13417 on 2017/9/5.
//  Copyright © 2017年 forkingdog. All rights reserved.
//

#define Font(font_size) [UIFont systemFontOfSize:(font_size)]

#import "FrameYYModel.h"

@implementation FrameYYModel

- (void)setEntity:(FDFeedEntity *)entity {
    if (!entity) return;
    
    _entity = entity;
    
    CGFloat maxLayout = ([UIScreen mainScreen].bounds.size.width - 20.f);
    CGFloat space = 10.f;
    CGFloat bottom = 4.f;
    
    //title
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:entity.title];
    title.yy_font = Font(16.f);
    title.yy_color = [UIColor blackColor];
    
    YYTextContainer *titleContainer = [YYTextContainer containerWithSize:CGSizeMake(maxLayout, CGFLOAT_MAX)];
    _titleLayout = [YYTextLayout layoutWithContainer:titleContainer text:title];
    
    CGFloat titleX = 10.f;
    CGFloat titleY = 10.f;
    CGSize titleSize = _titleLayout.textBoundingSize;
    _titleFrame = (CGRect){titleX,titleY,CGSizeMake(titleSize.width, titleSize.height)};
    
    
    //subTitle
    NSMutableAttributedString *subTitle = [[NSMutableAttributedString alloc] initWithString:entity.subTitle];
    subTitle.yy_font = Font(15.f);
    subTitle.yy_color = [UIColor darkGrayColor];
    
    [subTitle yy_setFont:Font(30.f) range:NSMakeRange(0, 2)];
    [subTitle yy_setColor:[UIColor redColor] range:NSMakeRange(0, 2)];
    
    YYTextContainer *subTitleContainer = [YYTextContainer containerWithSize:CGSizeMake(maxLayout, CGFLOAT_MAX)];
    _subTitleLayout = [YYTextLayout layoutWithContainer:subTitleContainer text:subTitle];

    CGSize subTitleSize = _subTitleLayout.textBoundingSize;
    CGFloat subTitleY = (CGRectGetMaxY(_titleFrame) + space);
    _subTitleFrame = (CGRect){titleX, subTitleY, subTitleSize};
    
    
    //content
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:entity.content];
    content.yy_font = Font(14.f);
    content.yy_color = [UIColor lightGrayColor];
    
    [content yy_setFont:Font(20.f) range:NSMakeRange(5, 10)];
    [content yy_setColor:[UIColor greenColor] range:NSMakeRange(5, 10)];
    
    YYTextContainer *contentContainer = [YYTextContainer containerWithSize:CGSizeMake(maxLayout, CGFLOAT_MAX)];
    _contentLayout = [YYTextLayout layoutWithContainer:contentContainer text:content];
    
    CGSize contentSize = _contentLayout.textBoundingSize;
    CGFloat contentY = (CGRectGetMaxY(_subTitleFrame) + space);
    _contentFrame = CGRectMake(titleX, contentY, contentSize.width, contentSize.height);
    
    //username
    NSMutableAttributedString *username = [[NSMutableAttributedString alloc] initWithString:entity.username];
    username.yy_font = Font(13.f);
    username.yy_color = [UIColor lightGrayColor];
    
    YYTextContainer *usernameContainer = [YYTextContainer containerWithSize:CGSizeMake(200.f, CGFLOAT_MAX)];
    usernameContainer.maximumNumberOfRows = 1;
    _usernameLayout = [YYTextLayout layoutWithContainer:usernameContainer text:username];
    
    CGSize nameSize = _usernameLayout.textBoundingSize;
    CGFloat nameY = (CGRectGetMaxY(_contentFrame) + 15.f);
    _usernameFrame = CGRectMake(titleX, nameY, nameSize.width, nameSize.height);
    
    //time
    NSMutableAttributedString *time = [[NSMutableAttributedString alloc] initWithString:entity.time];
    time.yy_font = Font(12.f);
    time.yy_color = [UIColor lightGrayColor];
    
    YYTextContainer *timeContainer = [YYTextContainer containerWithSize:CGSizeMake(200.f, CGFLOAT_MAX)];
    timeContainer.maximumNumberOfRows = 1;
    _timeLayout = [YYTextLayout layoutWithContainer:timeContainer text:time];
    
    CGSize timeSize = _timeLayout.textBoundingSize;
    CGFloat timeX = ([UIScreen mainScreen].bounds.size.width - space - timeSize.width);
    _timeFrame = CGRectMake(timeX, nameY, timeSize.width, timeSize.height);
    
    //cell Height
    _cellHeight = (CGRectGetMaxY(_usernameFrame) + bottom);
}


@end
