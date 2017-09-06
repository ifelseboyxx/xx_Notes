//
//  FrameFeedCell.h
//  Demo
//
//  Created by lx13417 on 2017/9/4.
//  Copyright © 2017年 forkingdog. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FrameModel;

static NSString *const FrameFeedCellIdentifier = @"FrameFeedCell";

@interface FrameFeedCell : UITableViewCell

@property (strong, nonatomic) FrameModel *model;

@end
