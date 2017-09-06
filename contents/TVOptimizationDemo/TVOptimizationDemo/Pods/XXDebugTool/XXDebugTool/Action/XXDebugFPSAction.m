//
//  XXDebugFPSAction.m
//  XXDebugToolDemo
//
//  Created by Jason on 2017/7/4.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//
#define SCREEN_HEIGHT [UIApplication sharedApplication].delegate.window.bounds.size.height

#define FPS_FRAME CGRectMake(20.0f, SCREEN_HEIGHT - 90.0f, 60.0f, 30.0f)

#import "XXDebugFPSAction.h"
#import "YYFPSLabel.h"
#import <objc/runtime.h>

NSString *const DebugFPSModuleIdentifier = @"xx.fps";

static inline void NewFPSLabel() {
    YYFPSLabel *lbl = [[YYFPSLabel alloc] initWithFrame:FPS_FRAME];
    [[UIApplication sharedApplication].delegate.window addSubview:lbl];
}

static inline void RemoveFPSLabel() {
    for (UIView *view in [UIApplication sharedApplication].delegate.window.subviews) {
        if ([view isKindOfClass:[YYFPSLabel class]]) {
            [view removeFromSuperview];
        }
    }
}

@implementation XXDebugFPSAction

- (void)xx_debugCellDidClickFromViewController:(UIViewController *)fromVC {
    
    [super xx_debugCellDidClickFromViewController:fromVC];
    
    BOOL isOpen = [[[NSUserDefaults standardUserDefaults] valueForKey:DebugFPSModuleIdentifier] boolValue];
    [[NSUserDefaults standardUserDefaults] setValue:@(!isOpen) forKey:DebugFPSModuleIdentifier];
    !isOpen ? NewFPSLabel() : RemoveFPSLabel();
}

@end


@implementation UIWindow (DebugFPS)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL s1 = @selector(makeKeyAndVisible);
        SEL s2 = @selector(fps_makeKeyAndVisible);
        Class class = [self class];
        Method m1 = class_getInstanceMethod(class, s1);
        Method m2 = class_getInstanceMethod(class, s2);
        BOOL success = class_addMethod(class, s1, method_getImplementation(m2), method_getTypeEncoding(m2));
        if (success){
            class_replaceMethod(class, s2, method_getImplementation(m1), method_getTypeEncoding(m1));
        }
        else{
            method_exchangeImplementations(m1, m2);
        }
    });
}

- (void)fps_makeKeyAndVisible {
    [self fps_makeKeyAndVisible];
    
    BOOL isOpen = [[[NSUserDefaults standardUserDefaults] valueForKey:DebugFPSModuleIdentifier] boolValue];

    !isOpen ?: NewFPSLabel();
}

@end



