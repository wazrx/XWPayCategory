//
//  WXApi+XWAdd.h
//  yyjx
//
//  Created by wazrx on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WXApi.h"

/**
 集成步骤：
 1、导入相关库，配置info.plist、配置Scheme，进行编译前准备
 2、调用xwAdd_registerWeiXinWithAppID:注册微信
 3、调用xwAdd_registerWXPayWithMchID:appSecret:方法注册微信支付，该方法在客户端签名时候才需要调用
 4、在appDelegate中的handleURL中调用xwAdd_handleOpenURL设置回调
 5、调用xwAdd_sendPayRequest方法发起支付申请，该方法分为有客户端签名和服务端签名两个版本
 6、在回调block中处理相关逻辑
 */

NS_ASSUME_NONNULL_BEGIN

@interface WXApi (XWAdd)

#pragma mark - base

/**
 *  注册微信
 *
 *  @param appID 申请的appID
 */
+ (void)xwAdd_registerWeiXinWithAppID:(NSString *)appID;

/**
 *  处理openUrl回调，请在appdelegate对应的方法中调用
 *
 *  @param url openURL
 */
+ (void)xwAdd_handleOpenURL:(NSURL *)url;

#pragma mark - WXPay (微信支付相关)

/**
 *  注册微信支付 (客户端签名才需要)
 *
 *  @param mchID     商户id
 *  @param secretKey 秘钥
 */
+ (void)xwAdd_registerWXPayWithMchID:(NSString*)mchID appSecret:(NSString*)secretKey;

/**
 *  发起支付 (客户端签名版本)
 *
 *  @param orderID        订单ID
 *  @param orderName      订单标题
 *  @param orderPrice     订单价格，单位分，不能有小数点
 *  @param orderNotifyUrl 服务器回调URL（重要）
 *  @param config         支付完成后的回调（successed = YES 代表支付成功）
 */
+ (void)xwAdd_sendPayRequestWithOrderID:(NSString *)orderID
                              orderName:(NSString *)orderName
                             orderPrice:(NSString *)orderPrice
                         orderNotifyUrl:(NSString *)orderNotifyUrl
                         callbackConfig:(void (^)(BOOL successed))config;


/**
 *  发起支付（服务端签名版本）
 *
 *  @param appID     申请的APPID
 *  @param partnerId 商户ID
 *  @param prepayId  预支付ID
 *  @param nonceStr  随机字符串
 *  @param timeStamp 时间戳
 *  @param package   打包信息
 *  @param sign      签名信息
 *  @param config    支付完成后的回调（successed = YES 代表支付成功）
 */
+ (void)xwAdd_senPayRequsetWithAppID:(NSString *)appID
                               partnerId:(NSString *)partnerId
                               prepayId:(NSString *)prepayId
                               nonceStr:(NSString *)nonceStr
                               timeStamp:(NSString *)timeStamp
                               package:(NSString *)package
                                 sign:(NSString *)sign
                       callbackConfig:(void (^)(BOOL successed))config;
@end


NS_ASSUME_NONNULL_END