//
//  UIResponder+Router.h
//  ResponderChainDemo
//
//  Created by lx13417 on 2017/8/3.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Router)

- (void)routerEventWithSelectorName:(NSString *)selectorName
                     object:(id)object
                   userInfo:(NSDictionary *)userInfo;


@end
