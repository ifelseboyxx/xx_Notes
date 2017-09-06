//
//  FrameModel.h
//  Demo
//
//  Created by lx13417 on 2017/9/4.
//  Copyright © 2017年 forkingdog. All rights reserved.
//
#define Font(font_size) [UIFont systemFontOfSize:(font_size)]

#import <UIKit/UIKit.h>
#import "FDFeedEntity.h"

@interface FrameModel : NSObject

@property (assign, nonatomic, readonly) CGRect titleFrame;

@property (assign, nonatomic, readonly) CGRect subTitleFrame;
@property (copy, nonatomic, readonly) NSAttributedString *attributedSubTitle;

@property (assign, nonatomic, readonly) CGRect contentFrame;
@property (copy, nonatomic, readonly) NSAttributedString *attributedContent;

@property (assign, nonatomic, readonly) CGRect usernameFrame;
@property (assign, nonatomic, readonly) CGRect timeFrame;
@property (assign, nonatomic, readonly) CGFloat cellHeight;

@property (strong, nonatomic) FDFeedEntity *entity;

@end
