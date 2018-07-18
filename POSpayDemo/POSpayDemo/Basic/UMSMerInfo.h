//
//  UMSMerInfo.h
//  PluginDemo
//
//  Created by CHANEL on 15/3/31.
//  Copyright (c) 2015年 CHANEL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMSMerInfo : NSObject <NSCopying>

@property (nonatomic, strong) NSString *billsMID;
@property (nonatomic, strong) NSString *billsTID;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *signAndCheckUrl;//加签URL
+ (UMSMerInfo *)sharedInstance;
@end
