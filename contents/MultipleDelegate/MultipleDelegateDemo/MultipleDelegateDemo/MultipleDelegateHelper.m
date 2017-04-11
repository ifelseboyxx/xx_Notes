//
//  MultipleDelegateHelper.m
//  MultipleDelegateDemo
//
//  Created by lx13417 on 2017/4/11.
//  Copyright © 2017年 lx13417. All rights reserved.
//

#import "MultipleDelegateHelper.h"

@interface MultipleDelegateHelper ()

@property (nonatomic, strong, nonnull) NSPointerArray *weakTargets;

@end

@implementation MultipleDelegateHelper

- (NSPointerArray *)weakTargets {
    if (!_weakTargets) {
        _weakTargets = [NSPointerArray weakObjectsPointerArray];
    }
    return _weakTargets;
}

- (void)setDelegateTargets:(NSArray *)delegateTargets{
    for (id delegate in delegateTargets) {
        [self.weakTargets addPointer:(__bridge void * _Nullable)(delegate)];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector{
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    for (id target in self.weakTargets) {
        if ([target respondsToSelector:aSelector]) {
            return YES;
        }
    }
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSMethodSignature *sig = [super methodSignatureForSelector:aSelector];
    if (!sig) {
        for (id target in self.weakTargets) {
            if ((sig = [target methodSignatureForSelector:aSelector])) {
                break;
            }
        }
    }
    return sig;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    for (id target in self.weakTargets) {
        if ([target respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:target];
        }
    }
}

@end
