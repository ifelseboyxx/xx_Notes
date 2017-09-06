//
//  xxDebugContraintsAction.m
//  CoreDataDemo
//
//  Created by lx13417 on 2017/5/12.
//  Copyright © 2017年 lx13417. All rights reserved.
//

#import "XXDebugContraintsAction.h"

NSString *const DebugConstraintsModuleIdentifier = @"xx.constraints";

@implementation XXDebugContraintsAction

- (void)xx_debugCellDidClickFromViewController:(UIViewController *)fromVC {
    
    [super xx_debugCellDidClickFromViewController:fromVC];
 
    BOOL start = [[[NSUserDefaults standardUserDefaults] valueForKey:DebugConstraintsModuleIdentifier] boolValue];
    [[NSUserDefaults standardUserDefaults] setValue:@(!start) forKey:DebugConstraintsModuleIdentifier];
}

@end
