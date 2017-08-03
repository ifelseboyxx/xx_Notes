//
//  UIResponder+Router.m
//  ResponderChainDemo
//
//  Created by lx13417 on 2017/8/3.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)routerEventWithSelectorName:(NSString *)selectorName
                             object:(id)object
                           userInfo:(NSDictionary *)userInfo {
    
    [[self nextResponder] routerEventWithSelectorName:selectorName
                                       object:object
                                     userInfo:userInfo];
    
}

@end
