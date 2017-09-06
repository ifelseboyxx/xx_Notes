//
//  xxDebugLeakAction.m
//  CoreDataDemo
//
//  Created by lx13417 on 2017/5/12.
//  Copyright © 2017年 lx13417. All rights reserved.
//

#import "XXDebugLeakAction.h"
#import "PLeakSniffer.h"

@implementation XXDebugLeakAction

- (void)xx_debugCellDidClickFromViewController:(UIViewController *)fromVC {
    
    [super xx_debugCellDidClickFromViewController:fromVC];
    
    [[PLeakSniffer sharedInstance] installLeakSniffer];
    [[PLeakSniffer sharedInstance] addIgnoreList:@[@"XXDebugViewController"]];
    [[PLeakSniffer sharedInstance] alertLeaks];
}

@end
