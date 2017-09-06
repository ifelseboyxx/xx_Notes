//
//  xxDebugContraintsModule.m
//  CoreDataDemo
//
//  Created by lx13417 on 2017/5/12.
//  Copyright © 2017年 lx13417. All rights reserved.
//

#import "XXDebugContraintsModule.h"
#import "XXDebugContraintsAction.h"
#import <objc/runtime.h>

@implementation XXDebugContraintsModule

- (NSString *)xx_debugTitle {
    return @"页面约束警告提示";
}

- (NSString *)xx_debugSubTitle {
    return [[[NSUserDefaults standardUserDefaults] valueForKey:DebugConstraintsModuleIdentifier] boolValue] ? @"已开启" : @"已关闭";
}

- (XXDebugBaseAction *)xx_debugAction {
    return [XXDebugContraintsAction new];
}

@end

@implementation NSLayoutConstraint (TCTUnsatisfiableConstraints)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL s1 = @selector(description);
        SEL s2 = @selector(debugConstraints_description);
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

- (NSString *)debugConstraints_description {
    NSString *description = [self debugConstraints_description];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:DebugConstraintsModuleIdentifier] boolValue]) {
        if ([self.tmpData containsObject:description]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"autolayout error(仅供参考)" message:description delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"复制", nil];
            [alert show];
        }
        else {
            [self.tmpData addObject:description];
        }
    }
    return description;
}

- (NSMutableArray *)tmpData {
    NSMutableArray *_tmpData = objc_getAssociatedObject(self, _cmd) ?: ({
        _tmpData = NSMutableArray.new;
        self.tmpData = _tmpData;
    });
    return _tmpData;
}

- (void)setTmpData:(NSMutableArray *)array {
    objc_setAssociatedObject(self, @selector(tmpData), array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = alertView.message;
    }
}

@end
