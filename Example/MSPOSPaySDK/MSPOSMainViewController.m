//
//  MSPOSMainViewController.m
//  MSPOSPaySDK_Example
//
//  Created by zzg on 2018/7/21.
//  Copyright © 2018年 wanghuizhou21@163.com. All rights reserved.
//

#import "MSPOSMainViewController.h"
#import <MSPOSPaySDK/UMSCashierPlugin.h>

@interface MSPOSMainViewController ()<UMSCashierPluginDelegate>

@end

@implementation MSPOSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSDictionary * dict = @{
                            @"billsMID":@"898310072994003",
                            @"billsTID":@"00000001"
                            };
    
    NSDictionary * paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"898310072994003",@"billsMID",
                               @"00000001",@"billsTID",
                               [self transitionJSONString_ums_request:dict extend_params:nil ums_bussiness_id:@"ums.device.connect.iertsl9s"],@"ums_request",nil];
    
    [UMSCashierPlugin umsSetupDevice:paramDic ViewController:self Delegate:self];
}

-(NSString *)transitionJSONString_ums_request:(NSDictionary *) dic
                                extend_params:(NSDictionary *)extendDic ums_bussiness_id:(NSString *)bussinessid{
    NSString *jsonValue = nil;
    NSError *error;
    NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:dic];
    NSDictionary *exDic = [NSDictionary dictionaryWithDictionary:extendDic];
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc]init];
    // 设备绑定
    //    [requestDic setObject:@"ums.device.connect.iertsl9s" forKey:@"business_id"];
    // 答应
    // ums.device.print.cpuhqbfa
    [requestDic setObject:bussinessid forKey:@"business_id"];
    [requestDic setObject:dataDic forKey:@"data"];
    [requestDic setObject:exDic forKey:@"extend_params"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDic options:NSJSONWritingPrettyPrinted error:&error];
    jsonValue        =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonValue;
}

@end
