//
//  ClassAModel.m
//  MultipleInheritDemo
//
//  Created by Jason on 2017/4/16.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//

#import "ClassAModel.h"

@implementation ClassAModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.titleA = dict[@"titleA"];
        self.subTitleA = dict[@"subTitleA"];
    }
    return self;
}

+ (instancetype)classAModelWithDict:(NSDictionary *)dict
{
    return  [[self alloc] initWithDict:dict];
}

#pragma mark - DataInfoProtocol setter

- (NSString *)title {
    return self.titleA;
}

- (NSString *)subTitle {
    return self.subTitleA;
}

@end
