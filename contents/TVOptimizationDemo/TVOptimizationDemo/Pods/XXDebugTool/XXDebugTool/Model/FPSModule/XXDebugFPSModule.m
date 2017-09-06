//
//  XXDebugFPSModule.m
//  XXDebugToolDemo
//
//  Created by Jason on 2017/7/4.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//

#import "XXDebugFPSModule.h"
#import "XXDebugFPSAction.h"

@implementation XXDebugFPSModule

- (NSString *)xx_debugTitle {
    return @"页面滚动帧率（真机）";
}

- (NSString *)xx_debugSubTitle {
    return [[[NSUserDefaults standardUserDefaults] valueForKey:DebugFPSModuleIdentifier] boolValue] ? @"已开启" : @"已关闭";
}

- (XXDebugBaseAction *)xx_debugAction {
    return [XXDebugFPSAction new];
}

@end
