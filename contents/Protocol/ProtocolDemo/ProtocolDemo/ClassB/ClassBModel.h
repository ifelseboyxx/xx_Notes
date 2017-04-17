//
//  ClassBModel.h
//  MultipleInheritDemo
//
//  Created by Jason on 2017/4/16.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublicProtocol.h"

@interface ClassBModel : NSObject
<DataInfoProtocol>

/** titleB */
@property (copy, nonatomic) NSString *titleB;

/** subTitleB */
@property (copy, nonatomic) NSString *subTitleB;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)classBModelWithDict:(NSDictionary *)dict;
@end
