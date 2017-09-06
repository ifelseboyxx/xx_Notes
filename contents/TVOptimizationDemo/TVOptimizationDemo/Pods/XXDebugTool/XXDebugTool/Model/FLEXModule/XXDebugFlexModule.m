//
//  xxDebugFlexModule.m
//  CoreDataDemo
//
//  Created by lx13417 on 2017/5/12.
//  Copyright © 2017年 lx13417. All rights reserved.
//

#import "XXDebugFlexModule.h"
#import "XXDebugFlexAction.h"

@implementation XXDebugFlexModule

- (NSString *)xx_debugTitle {
    return @"FLEX Tool";
}

- (NSString *)xx_debugSubTitle {
    return @"视图层级查看 (command+F)";
}

- (XXDebugBaseAction *)xx_debugAction {
    return [XXDebugFlexAction new];
}
@end
