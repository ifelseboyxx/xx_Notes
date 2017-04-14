//
//  UIControl+DelayEvent.m
//  TCTravel_IPhone
//
//  Created by lx13417 on 2017/2/3.
//  Copyright © 2017年 www.ly.com. All rights reserved.
//

#import "UIControl+DelayEvent.h"
#import <objc/runtime.h>

@implementation UIControl (DelayEvent)

- (NSTimeInterval)xx_delayTime {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setXx_delayTime:(NSTimeInterval)xx_delayTime {
    objc_setAssociatedObject(self,
                             @selector(xx_delayTime),
                             @(xx_delayTime),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)xx_ignoreEvent {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setXx_ignoreEvent:(BOOL)xx_ignoreEvent {
    objc_setAssociatedObject(self,
                             @selector(xx_ignoreEvent),
                             @(xx_ignoreEvent),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL mySEL = @selector(xx_sendAction:to:forEvent:);
        SEL systemSEL = @selector(sendAction:to:forEvent:);
        Class class = [self class];
        Method myM = class_getInstanceMethod(class, mySEL);
        Method systemM = class_getInstanceMethod(class, systemSEL);
        BOOL success = class_addMethod(class,
                                       mySEL,
                                       method_getImplementation(systemM),
                                       method_getTypeEncoding(systemM));
        if (success) {
            class_replaceMethod(class,
                                systemSEL,
                                method_getImplementation(myM),
                                method_getTypeEncoding(myM));
        }else {
            method_exchangeImplementations(myM, systemM);
        }
    });
}

- (void)xx_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    if (self.xx_ignoreEvent) return;
    if (self.xx_delayTime > 0.0f) {
        self.xx_ignoreEvent = YES;
        [self performSelector:@selector(setXx_ignoreEvent:)
                   withObject:@(NO)
                   afterDelay:self.xx_delayTime];
    }
    
    [self xx_sendAction:action to:target forEvent:event];
}

@end
