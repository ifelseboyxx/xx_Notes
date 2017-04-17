//
//  ClassA.m
//  MultipleInheritDemo
//
//  Created by Jason on 2017/4/16.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//

#import "ClassA.h"
#import "ClassAModel.h"

@implementation ClassA

- (void)fetchDataWithCompletionHandler:(void (^)())completeBlock {
    
    //模拟请求接口操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSDictionary *tempDict = @{@"titleA"    : @"Jhons",
                                   @"subTitleA" : @"iOS dev"};
        ClassAModel *aModel = [ClassAModel classAModelWithDict:tempDict];
        self.dataList = @[aModel];
        
        completeBlock();
    });
    
}

- (void)dealloc {
    NSLog(@"%@dealloc",self.class);
}

@end
