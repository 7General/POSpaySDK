//
//  MSSettingViewController.m
//  POSpayDemo
//
//  Created by zzg on 2018/7/18.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import "MSSettingViewController.h"
#import <Masonry/Masonry.h>
#import "MSConfigViewController.h"

@interface MSSettingViewController ()

@property (nonatomic, weak) UITextField * midField;
@property (nonatomic, weak) UITextField * tidField;
@property (nonatomic, weak) UITextField * busField;
@end

@implementation MSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
    
    [self initView];
    
    UIBarButtonItem *rightButton           = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}
- (void)initView {
    self.view.backgroundColor = [UIColor grayColor];
    
    UILabel * mid = [[UILabel alloc] init];
    mid.text = @"商户号";
    [self.view addSubview:mid];
    [mid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.top.mas_equalTo(self.view.mas_top).offset(100);
    }];
    
    
    UITextField * midField = [[UITextField alloc] init];
    midField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:midField];
    [midField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mid);
        make.left.mas_equalTo(mid.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
    self.midField = midField;
    [[NSUserDefaults standardUserDefaults] setObject:@"898310072994003" forKey:M_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.midField.text = [[NSUserDefaults standardUserDefaults] objectForKey:M_ID];
    
    UILabel * tid = [[UILabel alloc] init];
    tid.text = @"终端号";
    [self.view addSubview:tid];
    [tid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(mid);
        make.top.mas_equalTo(midField.mas_bottom).offset(20);
    }];
    
    
    UITextField * tidField = [[UITextField alloc] init];
    tidField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:tidField];
    [tidField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tid);
        make.left.mas_equalTo(tid.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
    self.tidField = tidField;
    [[NSUserDefaults standardUserDefaults] setObject:@"00000001" forKey:T_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.tidField.text = [[NSUserDefaults standardUserDefaults] objectForKey:T_ID];
    
    UILabel * busid = [[UILabel alloc] init];
    busid.text = @"bussinessid";
    [self.view addSubview:busid];
    [busid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(mid);
        make.top.mas_equalTo(tidField.mas_bottom).offset(20);
    }];
    
    
    UITextField * busField = [[UITextField alloc] init];
    busField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:busField];
    [busField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(busid);
        make.left.mas_equalTo(busid.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
    self.busField = busField;
    [[NSUserDefaults standardUserDefaults] setObject:@"ums.trade.pay.wo8y2lsu" forKey:BUSSINESS_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.busField.text = [[NSUserDefaults standardUserDefaults] objectForKey:BUSSINESS_ID];
    
}

- (void)nextAction {
    if (self.midField.text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.midField.text forKey:M_ID];
    }
    if (self.tidField.text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.tidField.text forKey:T_ID];
    }
    if (self.busField.text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.busField.text forKey:BUSSINESS_ID];
    }
}


@end
