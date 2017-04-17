//
//  ClassAModel.h
//  MultipleInheritDemo
//
//  Created by Jason on 2017/4/16.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublicProtocol.h"

@interface ClassAModel : NSObject
<DataInfoProtocol>

/** titleA */
@property (copy, nonatomic) NSString *titleA;

/** subTitleA */
@property (copy, nonatomic) NSString *subTitleA;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)classAModelWithDict:(NSDictionary *)dict;
@end
