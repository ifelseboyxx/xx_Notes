//
//  ClassBModel.m
//  MultipleInheritDemo
//
//  Created by Jason on 2017/4/16.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//

#import "ClassBModel.h"


@implementation ClassBModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.titleB = dict[@"titleB"];
        self.subTitleB = dict[@"subTitleB"];
    }
    return self;
}

+ (instancetype)classBModelWithDict:(NSDictionary *)dict
{
    return  [[self alloc] initWithDict:dict];
}

#pragma mark - DataInfoProtocol setter

- (NSString *)title {
    return self.titleB;
}

- (NSString *)subTitle {
    return self.subTitleB;
}

@end
