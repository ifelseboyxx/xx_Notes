//
//  FrameYYFeedCell.h
//  Demo
//
//  Created by lx13417 on 2017/9/5.
//  Copyright © 2017年 forkingdog. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FrameYYModel;

static NSString *const FrameYYFeedCellIdentifier = @"FrameYYFeedCell";

@interface FrameYYFeedCell : UITableViewCell

@property (strong, nonatomic) FrameYYModel *model;

@end
