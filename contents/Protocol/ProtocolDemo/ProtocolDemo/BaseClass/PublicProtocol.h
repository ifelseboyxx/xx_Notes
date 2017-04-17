//
//  PublicProtocol.h
//  MultipleInheritDemo
//
//  Created by Jason on 2017/4/16.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//
//
#ifndef PublicProtocol_h
#define PublicProtocol_h

@protocol DataInfoProtocol <NSObject>
@required
/** title */
@property (copy, nonatomic, readonly) NSString *title;
@optional
/** subTitle */
@property (copy, nonatomic, readonly) NSString *subTitle;
@end

#endif /* PublicProtocol_h */
