//
//  FrameModel.m
//  Demo
//
//  Created by lx13417 on 2017/9/4.
//  Copyright © 2017年 forkingdog. All rights reserved.
//

#import "FrameModel.h"
#import <NSAttributedString+YYText.h>

@implementation FrameModel

- (void)setEntity:(FDFeedEntity *)entity {
    if (!entity) return;
    
    _entity = entity;
    
    CGFloat maxLayout = ([UIScreen mainScreen].bounds.size.width - 20.f);
    CGFloat space = 10.f;
    CGFloat bottom = 4.f;
    
    //title
    CGFloat titleX = 10.f;
    CGFloat titleY = 10.f;
    CGSize titleSize = [entity.title boundingRectWithSize:CGSizeMake(maxLayout, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : Font(16.f)} context:nil].size;
    _titleFrame = CGRectMake(titleX, titleY, titleSize.width, titleSize.height);
    
    //subTitle
    NSMutableAttributedString *subTitle = [[NSMutableAttributedString alloc] initWithString:entity.subTitle];
    subTitle.yy_font = Font(15.f);
    subTitle.yy_font = Font(15.f);
    subTitle.yy_color = [UIColor darkGrayColor];
    
    [subTitle yy_setFont:Font(30.f) range:NSMakeRange(0, 2)];
    [subTitle yy_setColor:[UIColor redColor] range:NSMakeRange(0, 2)];
    
    _attributedSubTitle = subTitle;
    
    CGSize subTitleSize = [subTitle boundingRectWithSize:CGSizeMake(maxLayout, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
    CGFloat subTitleY = (CGRectGetMaxY(_titleFrame) + space);
    _subTitleFrame = CGRectMake(titleX, subTitleY, subTitleSize.width, subTitleSize.height);
    
    //content
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:entity.content];
    content.yy_font = Font(14.f);
    content.yy_color = [UIColor lightGrayColor];
    
    [content yy_setFont:Font(20.f) range:NSMakeRange(5, 10)];
    [content yy_setColor:[UIColor greenColor] range:NSMakeRange(5, 10)];
    
    _attributedContent = content;
    
    CGSize contentSize = [content boundingRectWithSize:CGSizeMake(maxLayout, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
    CGFloat contentY = (CGRectGetMaxY(_subTitleFrame) + space);
    _contentFrame = CGRectMake(titleX, contentY, contentSize.width, contentSize.height);
    
    //username
    CGSize nameSize = [entity.username sizeWithAttributes:@{NSFontAttributeName : Font(13.f)}];
    CGFloat nameY = (CGRectGetMaxY(_contentFrame) + 15.f);
    _usernameFrame = CGRectMake(titleX, nameY, nameSize.width, nameSize.height);
    
    //time
    CGSize timeSize = [entity.time sizeWithAttributes:@{NSFontAttributeName : Font(12.f)}];
    CGFloat timeX = ([UIScreen mainScreen].bounds.size.width - space - timeSize.width);
    _timeFrame = CGRectMake(timeX, nameY, timeSize.width, timeSize.height);
    
    //cell Height
    _cellHeight = (CGRectGetMaxY(_usernameFrame) + bottom);
}


@end
