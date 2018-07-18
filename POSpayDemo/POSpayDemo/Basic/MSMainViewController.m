//
//  MSMainViewController.m
//  POSpayDemo
//
//  Created by zzg on 2018/7/18.
//  Copyright © 2018年 zzg. All rights reserved.
//

#define AP_SUBVIEW_XGAP   (20.0f)
#define AP_SUBVIEW_WIDTH  (([UIScreen mainScreen].bounds.size.width) - 2*(AP_SUBVIEW_XGAP))
#define AP_BUTTON_HEIGHT  (60.0f)


#import "MSMainViewController.h"
#import "MSSettingViewController.h"
#import "MSConfigViewController.h"
#import "UMSCashierPlugin.h"
#import "AFNetworking.h"
#import "UMSMerInfo.h"

@interface MSMainViewController ()<UMSCashierPluginDelegate>

@end

@implementation MSMainViewController
static AFHTTPSessionManager *manager;

- (void)generateBtnWithTitle:(NSString*)title selector:(SEL)selector posy:(CGFloat)posy {
    UIButton* tmpBtn = [[UIButton alloc]initWithFrame:CGRectMake(AP_SUBVIEW_XGAP, posy, AP_SUBVIEW_WIDTH, AP_BUTTON_HEIGHT)];
    tmpBtn.backgroundColor = [UIColor colorWithRed:81.0f/255.0f green:141.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    tmpBtn.layer.masksToBounds = YES;
    tmpBtn.layer.cornerRadius = 4.0f;
    [tmpBtn setTitle:title forState:UIControlStateNormal];
    [tmpBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tmpBtn];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UMSMerInfo * merInfo = [UMSMerInfo sharedInstance];
    merInfo.signAndCheckUrl = @"https://mpos.quanminfu.com/qs/signAndCheck/";
    if (OBJFORKEY(M_ID)) {
        merInfo.billsMID = OBJFORKEY(M_ID);
    }else {
        merInfo.billsMID = @"shouji000000004";
    }
    
    if (OBJFORKEY(T_ID)) {
        merInfo.billsTID = OBJFORKEY(T_ID);
    }else {
        merInfo.billsTID = @"sj000004";
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"POS支付";
    self.view.backgroundColor = [UIColor grayColor];
    
    CGFloat originalPosY = [UIApplication sharedApplication].statusBarFrame.size.height + 80.0f;
    [self generateBtnWithTitle:@"设置设备" selector:@selector(setDevice) posy:originalPosY];
    
    originalPosY += (AP_BUTTON_HEIGHT + 20);
    [self generateBtnWithTitle:@"设备连接" selector:@selector(contentDevice) posy:originalPosY];
    
    originalPosY += (AP_BUTTON_HEIGHT + 20);
    [self generateBtnWithTitle:@"支付" selector:@selector(payMoney) posy:originalPosY];
    
    
}

#pragma mark - 设置设备MID ,PID,BUSSINESS_ID....
- (void) setDevice {
    MSSettingViewController * setting = [[MSSettingViewController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
}
#pragma mark - 设备连接
- (void) contentDevice {
    
    NSDictionary * dict = @{
                            @"billsMID":OBJFORKEY(M_ID),
                            @"billsTID":OBJFORKEY(T_ID)
                            };
    
    NSDictionary * paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               OBJFORKEY(M_ID),@"billsMID",
                               OBJFORKEY(T_ID),@"billsTID",
                               [self transitionJSONString_ums_request:dict extend_params:nil],@"ums_request",nil];
    
    [UMSCashierPlugin umsSetupDevice:paramDic ViewController:self Delegate:self];
}
#pragma mark -付款
- (void)payMoney {
    [self signAndCheckRequest];
}

-(AFHTTPSessionManager *)sharedHTTPSession{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 10;
    });
    return manager;
}

#pragma mark - 加签交易
-(void)signAndCheckRequest {
    NSString * trad_no =  [self getCurrentTime];
    NSDictionary *dicJson;
    //JsonValue以所进行交易参数JSONString形式发送
    dicJson = [NSDictionary dictionaryWithObjectsAndKeys:
               @"1",@"amount",
               OBJFORKEY(M_ID),@"billsMID",
               OBJFORKEY(T_ID),@"billsTID",
               trad_no,@"merOrderId",
               @"商户订单描述内容",@"merOrderDesc",
               @"10",@"operator",
               @"BANKCARD",@"payType",
               @"备注信息1=大众点评团",@"memo",
               @"auto",@"salesSlipType",
               @"flase",@"isShowOrderInfo",
               @"0", @"couponType",
               @"bank",@"cardType",
               @"",@"orgCode",
               @"15010206793",@"consumerPhone",
               @"NO",@"isPaperSign",
               @"horizontal",@"signDirection",
               @"",@"serialNum",
               @"0",@"unsupportedCardType",
               @"true",@"isShowEVoucherPage",
               @"defaultType",@"saleSlipFavorite",
               nil];
    
    
    NSString *jsonValue;
    if ([NSJSONSerialization isValidJSONObject:dicJson])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicJson options:NSJSONWritingPrettyPrinted error:&error];
        jsonValue        =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    AFHTTPSessionManager *manager            = [self sharedHTTPSession];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    [manager.requestSerializer setValue:@"application/json;charset=UTF-8"forHTTPHeaderField:@"Content-Type"];
    NSDictionary *parameters                 = @{@"billsMID":OBJFORKEY(M_ID),
                                                 @"signValue":jsonValue,
                                                 @"signModel":@"Encrypt"};
    
    UIActivityIndicatorView * activityIndicatorView =[[UIActivityIndicatorView alloc]initWithFrame:
      CGRectMake(0, 0, 100, 100)];
    activityIndicatorView.layer.cornerRadius = 10;
    activityIndicatorView.center             = self.view.center;
    [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicatorView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
#pragma mark POST Request
    NSString *URL  =  [UMSMerInfo sharedInstance].signAndCheckUrl;
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [activityIndicatorView stopAnimating];
        NSDictionary *dic;
        NSMutableDictionary *extentionDic = [[NSMutableDictionary alloc]initWithCapacity:1];
        //        [[NSUserDefaults standardUserDefaults] setObject:_merorderIdTF.text forKey:@"merorderId"];
//        [[NSUserDefaults standardUserDefaults] setObject:trad_no forKey:@"merorderId"];
        NSDictionary *wrap                = [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *sign;
        if (wrap){
            sign = [wrap objectForKey:@"sign"];
        }
        NSDictionary *dataDic;
        NSDictionary *extendDic;
        
        [extentionDic setObject:@"1000A4Z301000212345600001" forKey:@"BJP"];
        dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                   @"1",@"amount",
                   OBJFORKEY(M_ID),@"billsMID",
                   OBJFORKEY(T_ID),@"billsTID",
                   trad_no,@"merOrderId",
                   @"商户订单描述内容",@"merOrderDesc",
                   @"10",@"operator",
                   @"15010206793",@"consumerPhone",
                   @"BANKCARD",@"payType",
                   @"备注信息1=大众点评团",@"memo",
                   @"auto",@"salesSlipType",
                   @"flase",@"isShowOrderInfo",
                   @"0", @"couponType",
                   @"bank",@"cardType",
                   @"",@"orgCode",
                   @"NO",@"isPaperSign",
                   @"horizontal",@"signDirection",
                   @"0",@"unsupportedCardType",
                   @"true",@"isShowEVoucherPage",
                   @"defaultType",@"saleSlipFavorite",
                   @"",@"serialNum",
                   nil];
        extendDic =  [NSDictionary dictionaryWithObjectsAndKeys:
                      extentionDic,@"extension",
                      nil];
        
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [self transitionJSONString_ums_request:dataDic extend_params:extendDic sign:sign],@"ums_request",
               nil];
        [UMSCashierPlugin umsPay:dic ViewController:self Delegate:self];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [activityIndicatorView stopAnimating];
         UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"请求失败" message:@"加签请求失败" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *action        = [UIAlertAction actionWithTitle:@"重新请求" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self signAndCheckRequest];
         }];
         UIAlertAction *actionCacel   = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
             
         }];
         [alertView addAction:action];
         [alertView addAction:actionCacel];
         [self presentViewController:alertView animated:YES completion:nil];
     }];
}



#pragma mark 转换为JSON字符串 无需加签接口
-(NSString *)transitionJSONString_ums_request:(NSDictionary *) dic
                                extend_params:(NSDictionary *)extendDic{
    NSString *jsonValue = nil;
    NSError *error;
    NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:dic];
    NSDictionary *exDic = [NSDictionary dictionaryWithDictionary:extendDic];
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc]init];
    //[requestDic setObject:OBJFORKEY(BUSSINESS_ID) forKey:@"business_id"];
    [requestDic setObject:@"ums.device.connect.iertsl9s" forKey:@"business_id"];
    [requestDic setObject:dataDic forKey:@"data"];
    [requestDic setObject:exDic forKey:@"extend_params"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDic options:NSJSONWritingPrettyPrinted error:&error];
    jsonValue        =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonValue;
}
#pragma mark 转换为JSON字符串 需要加签
-(NSString *)transitionJSONString_ums_request:(NSDictionary *) dic
                                extend_params:(NSDictionary *)extendDic
                                         sign:(NSString *)sign{
    NSString *jsonValue = nil;
    NSError *error;
    NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:dic];
    NSDictionary *exDic = [NSDictionary dictionaryWithDictionary:extendDic];
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc]init];
//    [requestDic setObject:OBJFORKEY(BUSSINESS_ID) forKey:@"business_id"];
    // ums.trade.pay.wo8y2lsu
    [requestDic setObject:@"ums.trade.pay.wo8y2lsu" forKey:@"business_id"];
    [requestDic setObject:dataDic forKey:@"data"];
    [requestDic setObject:exDic forKey:@"extend_params"];
    [requestDic setObject:sign forKey:@"sign"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDic options:NSJSONWritingPrettyPrinted error:&error];
    jsonValue        =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonValue;
}



#pragma mak - 设备激活回调
//设备激活回调
-(void)onUMSSetupDevice:(BOOL) resultStatus resultInfo:(NSDictionary *)resultInfo withDeviceId:(NSString *)deviceId {
    NSLog(@"设备激活%@ ===%@",resultInfo,deviceId);
    NSString *result                  = resultStatus?@"设备激活 成功":@"设备激活 失败";
    NSDictionary *dict                = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", resultStatus], @"resultStatus", resultInfo, @"resultInfo",deviceId, @"deviceId", nil];
    NSLog(@"----result:%@,dict:%@",result,dict);
    if ([[resultInfo objectForKey:@"ums_response"]isKindOfClass:[NSString class]]){
        NSString *JSonStr = [resultInfo objectForKey:@"ums_response"];
        NSArray *JSonDic = [self dictionaryChangeFromJsonString:JSonStr];
        NSLog(@"%@",JSonDic);
    }
}

-(void)onPayResult:(PayStatus) payStatus
       PrintStatus:(PrintStatus) printStatus
   SignatureStatus:(SignatureStatus)uploadStatus
          withInfo:(NSDictionary *)dict {
    NSLog(@"%@", dict);
//    UMSResultViewController *resultVC = [[UMSResultViewController alloc] init];
//    resultVC.Fun_Type                 = Fun_Type;
//    NSMutableDictionary *tempDict     = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
//    switch (payStatus) {
//        case PayStatus_PAYSUCCESS:
//            [tempDict setObject:@"PayStatus_PAYSUCCESS" forKey:@"PayStatus"];
//            [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"orderId"] forKey:@"orderId"];
//            resultVC.result = @"支付 成功";
//            break;
//        case PayStatus_PAYFAIL:
//            [tempDict setObject:@"PayStatus_PAYFAIL" forKey:@"PayStatus"];
//            resultVC.result = @"支付 失败";
//            break;
//        case PayStatus_PAYCANCEL:
//            [tempDict setObject:@"PayStatus_PAYCANCEL" forKey:@"PayStatus"];
//            resultVC.result = @"支付 取消";
//            break;
//        case PayStatus_PAYTIMEOUT:
//            [tempDict setObject:@"PayStatus_PAYTIMEOUT" forKey:@"PayStatus"];
//            resultVC.result = @"支付 超时";
//            break;
//        case PayStatus_VOIDSUCCESS:
//            [tempDict setObject:@"PayStatus_VOIDSUCCESS" forKey:@"PayStatus"];
//            resultVC.result = @"消费撤销 撤销成功";
//            break;
//        case PayStatus_VOIDFAIL:
//            [tempDict setObject:@"PayStatus_VOIDFAIL" forKey:@"PayStatus"];
//            resultVC.result = @"消费撤销 撤销失败";
//            break;
//        case PayStatus_VOIDTIMEOUT:
//            [tempDict setObject:@"PayStatus_VOIDTIMEOUT" forKey:@"PayStatus"];
//            resultVC.result = @"消费撤销 撤销超时";
//            break;
//        case PayStatus_VOIDCANCEL:
//            [tempDict setObject:@"PayStatus_VOIDCANCEL" forKey:@"PayStatus"];
//            resultVC.result = @"消费撤销 撤销取消";
//            break;
//        default:
//            break;
//    }
//
//    resultVC.resultDict = [self setDictFromStatus:printStatus :uploadStatus :tempDict];
//    [self.navigationController pushViewController:resultVC animated:NO];
}

#pragma mark 插件返回的JSON字符串转化为字典
- (NSArray *)dictionaryChangeFromJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
#pragma mark - 获取订单号
- (NSString *) getCurrentTime {
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formater setTimeZone:timeZone];
    NSDate *curDate = [NSDate date];//获取当前日期
    [formater setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString * curTime = [formater stringFromDate:curDate];
    return curTime;
}


@end

