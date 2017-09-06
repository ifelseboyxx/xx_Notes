//
//  FrameYYModel.h
//  Demo
//
//  Created by lx13417 on 2017/9/5.
//  Copyright © 2017年 forkingdog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDFeedEntity.h"
#import <YYText.h>

@interface FrameYYModel : NSObject

@property (assign, nonatomic, readonly) CGRect titleFrame;
@property (strong, nonatomic, readonly) YYTextLayout *titleLayout;

@property (assign, nonatomic, readonly) CGRect subTitleFrame;
@property (strong, nonatomic, readonly) YYTextLayout *subTitleLayout;

@property (assign, nonatomic, readonly) CGRect contentFrame;
@property (strong, nonatomic, readonly) YYTextLayout *contentLayout;

@property (assign, nonatomic, readonly) CGRect usernameFrame;
@property (strong, nonatomic, readonly) YYTextLayout *usernameLayout;

@property (assign, nonatomic, readonly) CGRect timeFrame;
@property (strong, nonatomic, readonly) YYTextLayout *timeLayout;

@property (assign, nonatomic, readonly) CGFloat cellHeight;

@property (strong, nonatomic) FDFeedEntity *entity;

@end
