//
//  BaseClass.h
//  MultipleInheritDemo
//
//  Created by Jason on 2017/4/16.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicProtocol.h"

@interface BaseClass : NSObject

/** 数据源*/
@property (strong, nonatomic) NSArray <id<DataInfoProtocol>> *dataList;

/** 接口请求操作*/
- (void)fetchDataWithCompletionHandler:(void(^)())completeBlock;
@end
