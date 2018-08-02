//
//  MSPOSViewController.m
//  MSPOSPaySDK
//
//  Created by wanghuizhou21@163.com on 07/20/2018.
//  Copyright (c) 2018 wanghuizhou21@163.com. All rights reserved.
//


#define AP_SUBVIEW_XGAP   (20.0f)
#define AP_SUBVIEW_WIDTH  (([UIScreen mainScreen].bounds.size.width) - 2*(AP_SUBVIEW_XGAP))
#define AP_BUTTON_HEIGHT  (60.0f)

#import "MSPOSViewController.h"
#import <MSPOSPaySDK/UMSCashierPlugin.h>

@interface MSPOSViewController ()<UMSCashierPluginDelegate>

@end

@implementation MSPOSViewController

- (void)generateBtnWithTitle:(NSString*)title selector:(SEL)selector posy:(CGFloat)posy {
    UIButton* tmpBtn = [[UIButton alloc]initWithFrame:CGRectMake(AP_SUBVIEW_XGAP, posy, AP_SUBVIEW_WIDTH, AP_BUTTON_HEIGHT)];
    tmpBtn.backgroundColor = [UIColor colorWithRed:81.0f/255.0f green:141.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    tmpBtn.layer.masksToBounds = YES;
    tmpBtn.layer.cornerRadius = 4.0f;
    [tmpBtn setTitle:title forState:UIControlStateNormal];
    [tmpBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tmpBtn];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat originalPosY = [UIApplication sharedApplication].statusBarFrame.size.height + 80.0f;
    [self generateBtnWithTitle:@"设备连接" selector:@selector(contentDevice) posy:originalPosY];
    
    originalPosY += (AP_BUTTON_HEIGHT + 20);
//    [self generateBtnWithTitle:@"支付" selector:@selector(payMoney) posy:originalPosY];
//
//    originalPosY += (AP_BUTTON_HEIGHT + 20);
//    [self generateBtnWithTitle:@"打印单据" selector:@selector(printPay) posy:originalPosY];
    
    
    
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

#pragma mark - 设备连接
- (void) contentDevice {
    
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

@end
