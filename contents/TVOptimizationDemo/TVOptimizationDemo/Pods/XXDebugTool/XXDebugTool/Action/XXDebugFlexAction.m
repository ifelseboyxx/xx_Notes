//
//  xxDebugFlexAction.m
//  CoreDataDemo
//
//  Created by lx13417 on 2017/5/12.
//  Copyright © 2017年 lx13417. All rights reserved.
//

#import "XXDebugFlexAction.h"
#import "FLEXManager.h"

@implementation XXDebugFlexAction

- (void)xx_debugCellDidClickFromViewController:(UIViewController *)fromVC {
    
    [super xx_debugCellDidClickFromViewController:fromVC];
    
    [[FLEXManager sharedManager] showExplorer];
    
}

@end
