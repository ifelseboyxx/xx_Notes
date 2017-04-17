//
//  ClassB.m
//  MultipleInheritDemo
//
//  Created by Jason on 2017/4/16.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//

#import "ClassB.h"
#import "ClassBModel.h"

@implementation ClassB

- (void)fetchDataWithCompletionHandler:(void (^)())completeBlock {
    
    //模拟请求接口操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSDictionary *tempDict = @{@"titleB"    : @"Jason",
                                   @"subTitleB" : @"Android dev"};
        ClassBModel *bModel = [ClassBModel classBModelWithDict:tempDict];
        self.dataList = @[bModel];
        
        completeBlock();
    });
    
}

- (void)dealloc {
    NSLog(@"%@dealloc",self.class);
}


@end
