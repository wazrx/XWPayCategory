//
//  XWSimpleTipView.h
//  XWCurrencyExchange
//
//  Created by YouLoft_MacMini on 16/3/1.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWSimpleTipView : UIView

+ (void)xw_showSimpleTipOnView:(UIView *)view WithTitle:(NSString *)title;

+ (void)xw_removeSimpleTipOnView:(UIView *)view;

@end
