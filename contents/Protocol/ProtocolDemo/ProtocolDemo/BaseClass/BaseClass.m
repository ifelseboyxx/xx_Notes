//
//  BaseClass.m
//  MultipleInheritDemo
//
//  Created by Jason on 2017/4/16.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//

#import "BaseClass.h"

@implementation BaseClass


- (void)fetchDataWithCompletionHandler:(void (^)())completeBlock {}

- (void)dealloc {
    NSLog(@"%@dealloc",self.class);
}

@end
