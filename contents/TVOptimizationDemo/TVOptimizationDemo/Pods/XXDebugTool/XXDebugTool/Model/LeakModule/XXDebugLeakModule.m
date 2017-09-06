//
//  xxDebugLeakModule.m
//  CoreDataDemo
//
//  Created by lx13417 on 2017/5/12.
//  Copyright © 2017年 lx13417. All rights reserved.
//

#import "XXDebugLeakModule.h"
#import "XXDebugLeakAction.h"

@implementation XXDebugLeakModule

- (NSString *)xx_debugTitle {
    return @"内存泄露测试";
}

- (NSString *)xx_debugSubTitle {
    return @"重启失效";
}

- (XXDebugBaseAction *)xx_debugAction {
    return [XXDebugLeakAction new];
}

@end
