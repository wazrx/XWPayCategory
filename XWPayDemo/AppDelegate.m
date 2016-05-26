//
//  AppDelegate.m
//  XWPayDemo
//
//  Created by wazrx on 16/5/22.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi+XWAdd.h"
#import "AlipaySDK+XWAdd.h"
#import "XWConst.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //注册微信
    [WXApi xwAdd_registerWeiXinWithAppID:weiXinID];
    //注册微信支付(客户端签名才需要注册)
    [WXApi xwAdd_registerWXPayWithMchID:weiXinMchID appSecret:weiXinSecretKey];
    //注册支付宝支付(客户端签名才需要注册)
    [AlipaySDK xwAdd_registerAlipayWithPartnerID:AliPayPartnerID sellerID:AliPaySellerID partnerPrivKey:AliPayPartnerPrivKey];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    //处理微信回调信息
    [WXApi xwAdd_handleOpenURL:url];
    //处理支付宝回调信息
    [AlipaySDK xwAdd_handleOpenURL:url];
    return YES;
}

@end
