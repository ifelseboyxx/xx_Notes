//
//  xxDebugBaseModule.h
//  CoreDataDemo
//
//  Created by lx13417 on 2017/5/12.
//  Copyright © 2017年 lx13417. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XXDebugBaseAction;

@interface XXDebugBaseModule : NSObject

- (NSString *)xx_debugTitle;
- (NSString *)xx_debugSubTitle;
- (XXDebugBaseAction *)xx_debugAction;

@end
