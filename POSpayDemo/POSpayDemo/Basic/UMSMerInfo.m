//
//  UMSMerInfo.m
//  PluginDemo
//
//  Created by CHANEL on 15/3/31.
//  Copyright (c) 2015年 CHANEL. All rights reserved.
//

#import "UMSMerInfo.h"

@implementation UMSMerInfo

+ (UMSMerInfo *)sharedInstance{
    static dispatch_once_t onceToken;
    static UMSMerInfo *_umsMerInfo = nil;
    dispatch_once(&onceToken,^{
    _umsMerInfo                    = [[super allocWithZone:NULL] init];
    });
    return _umsMerInfo;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

#pragma - implement NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
