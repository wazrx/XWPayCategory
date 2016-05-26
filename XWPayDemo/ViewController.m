//
//  ViewController.m
//  XWPayDemo
//
//  Created by wazrx on 16/5/22.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "ViewController.h"
#import "XWSimpleTipView.h"
#import "WXApi+XWAdd.h"
#import "AlipaySDK+XWAdd.h"

@interface ViewController ()
- (IBAction)alipay:(id)sender;
- (IBAction)wxpay:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)alipay:(id)sender {
    //发起支付宝支付（客户端签名版本）
    [AlipaySDK xwAdd_sendPayRequestWithOrderID:@"1221322213123131321" orderName:@"测试订单" orderDescription:nil orderPrice:@"0.01" orderNotifyUrl:@"www.test.com" appScheme:@"xwpaydemo" callbackConfig:^(BOOL successed) {
        //支付宝支付无论网页版本和app版本都统一在这里回调
        [self _xw_handleResult:successed];
    }];
}

- (IBAction)wxpay:(id)sender {
    //发起微信支付（客户端签名版本）
    [WXApi xwAdd_sendPayRequestWithOrderID:@"13212112313213213213" orderName:@"测试订单" orderPrice:@"1" orderNotifyUrl:@"www.test.com" callbackConfig:^(BOOL successed) {
        //微信支付回调回调
        [self _xw_handleResult:successed];
    }];
}

/**处理支付结果*/
- (void)_xw_handleResult:(BOOL)successed{
    [XWSimpleTipView xw_showSimpleTipOnView:self.view WithTitle:successed ? @"支付成功" : @"支付失败"];
}

@end
