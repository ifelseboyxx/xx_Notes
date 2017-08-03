//
//  NSObject+PerformSelector.h
//  ResponderChainDemo
//
//  Created by lx13417 on 2017/8/3.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformSelector)

- (id)performSelector:(SEL)aSelector withObjects:(NSArray <id> *)objects;

@end
