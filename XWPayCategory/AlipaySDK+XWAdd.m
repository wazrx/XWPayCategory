//
//  AlipaySDK+XWAdd.m
//  yyjx
//
//  Created by wazrx on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AlipaySDK+XWAdd.h"
#import "Order.h"
#import "DataSigner.h"
#import <objc/runtime.h>

static void * const xwAdd_partnerID_key = "xwAdd_partnerID_key";
static void * const xwAdd_sellerID_key = "xwAdd_sellerID_key";
static void * const xwAdd_partnerPrivKey_key = "xwAdd_partnerPrivKey_key";
static void * const xwAdd_callbackConfig_key = "xwAdd_callbackConfig_key";

@implementation AlipaySDK (XWAdd)

+ (void)xwAdd_registerAlipayWithPartnerID:(NSString*)partnerID sellerID:(NSString*)sellerID partnerPrivKey:(NSString *)partnerPrivKey {
    [self _xwAdd_saveValueWithKey:xwAdd_partnerID_key value:partnerID];
    [self _xwAdd_saveValueWithKey:xwAdd_sellerID_key value:sellerID];
    [self _xwAdd_saveValueWithKey:xwAdd_partnerPrivKey_key value:partnerPrivKey];
}

+ (void)xwAdd_sendPayRequestWithOrderID:(NSString *)orderID
                              orderName:(NSString *)orderName
                              orderDescription:(NSString *)orderDescription
                             orderPrice:(NSString *)orderPrice
                         orderNotifyUrl:(NSString *)orderNotifyUrl
                              appScheme:(NSString *)appScheme
                         callbackConfig:(void (^)(BOOL successed))config {
    if (!config) {
        NSLog(@"必须设置回调block");
        return;
    }
    //生成订单信息
    NSString * partnerID = [self _xwAdd_readValueWithKey:xwAdd_partnerID_key];
    NSString * sellerID = [self _xwAdd_readValueWithKey:xwAdd_sellerID_key];
    NSString * partnerPrivKey = [self _xwAdd_readValueWithKey:xwAdd_partnerPrivKey_key];
    if (!partnerID.length || !sellerID.length || !partnerPrivKey.length) {
        NSLog(@"基础信息不全");
        config(NO);
        return;
    }
    Order *order = [[Order alloc] init];
    order.partner = partnerID; //支付宝分配给商户的ID
    order.sellerID = sellerID; //收款支付宝账号（用于收💰）
    order.outTradeNO = orderID; //订单ID(由商家自行制定)
    order.subject = orderName; //商品标题
    order.body = orderDescription; //商品描述
    order.totalFee = orderPrice; //商品价格
    order.notifyURL =  orderNotifyUrl; //回调URL（通知服务器端交易结果）(重要)
    order.service = @"mobile.securitypay.pay"; //接口名称, 固定值, 不可空
    order.inputCharset = @"utf-8"; //参数编码字符集: 商户网站使用的编码格式, 固定为utf-8, 不可空
    // 将订单信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"订单信息orderSpec = %@", orderSpec);
    //通过私钥将订单信息签名
    id<DataSigner> signer = CreateRSADataSigner(partnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    if (!signedString.length) {
        NSLog(@"签名失败");
        config(NO);
        return;
    }
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                   orderSpec, signedString, @"RSA"];
    NSLog(@"==== %@", orderString);
    [self xwAdd_sendPayWithOrderInfo:orderString appScheme:appScheme callbackConfig:config];
}

+ (void)xwAdd_sendPayWithOrderInfo:(NSString *)orderInfo
                         appScheme:(NSString *)appScheme
                    callbackConfig:(void (^)(BOOL successed))config {
    //保存回调block
    objc_setAssociatedObject(self, xwAdd_callbackConfig_key, config, OBJC_ASSOCIATION_COPY_NONATOMIC);
    //发起支付请求
    [[AlipaySDK defaultService] payOrder:orderInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        [self _xwAdd_checkResultWithDict:resultDic];
    }];
    
}

+ (void)xwAdd_handleOpenURL:(NSURL *)url {
    if (![url.host isEqualToString:@"safepay"]) {
        return;
    }
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        [self _xwAdd_checkResultWithDict:resultDic];
    }];
}

#pragma mark - private methods

+ (void)_xwAdd_checkResultWithDict:(NSDictionary *)resultDic{
    void (^config)(BOOL successed) = objc_getAssociatedObject(self, xwAdd_callbackConfig_key);
    if (!config) {
        return;
    }
    config([resultDic[@"resultStatus"] intValue] == 9000);
    config = nil;
    objc_setAssociatedObject(self, xwAdd_callbackConfig_key, nil, OBJC_ASSOCIATION_ASSIGN);
}

+ (void)_xwAdd_saveValueWithKey:(void *)key value:(id)value{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (id)_xwAdd_readValueWithKey:(void *)key{
    return objc_getAssociatedObject(self, key);
}
@end
