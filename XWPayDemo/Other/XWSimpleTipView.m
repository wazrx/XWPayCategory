//
//  XWSimpleTipView.m
//  XWCurrencyExchange
//
//  Created by YouLoft_MacMini on 16/3/1.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "XWSimpleTipView.h"
#import "NSString+SizeToFit.h"
#import "UIView+FrameChange.h"
#import <objc/runtime.h>

static NSUInteger count;

@interface XWSimpleTipView ()
@property (nonatomic, weak) UILabel *tipLabel;
@end

@implementation XWSimpleTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.layer.cornerRadius = 5;
        UILabel *tipLabel = [UILabel new];
        _tipLabel = tipLabel;
        tipLabel.font = [UIFont systemFontOfSize:14];
        tipLabel.textAlignment = 1;
        tipLabel.numberOfLines = 0;
        tipLabel.textColor = [UIColor whiteColor];
        [self addSubview:tipLabel];
    }
    return self;
}

+ (void)xw_showSimpleTipOnView:(UIView *)view WithTitle:(NSString *)title{
    [self xw_removeSimpleTipOnView:view];
    CGSize size = [title xw_sizeWithfont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(200, MAXFLOAT)];
    XWSimpleTipView *tipView = [[XWSimpleTipView alloc] initWithFrame:CGRectMake(0, 0, size.width + 20, size.height + 20)];
    objc_setAssociatedObject(self, "XWSimpleTipView", tipView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    tipView.center = CGPointMake(view.width / 2.0f, view.height / 2.0f);
    tipView.tipLabel.text = title;
    tipView.tipLabel.size = size;
    tipView.tipLabel.center = CGPointMake(tipView.width / 2.0f, tipView.height / 2.0f);
    [view addSubview:tipView];
    tipView.alpha = 0;
    __block NSInteger currentCount = count;
    CGFloat time = 1 + (fmax(10, title.length) - 10) * 0.1;
    [UIView animateWithDuration:0.5 animations:^{
        tipView.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSLog(@"after =  %zd, %zd", count, currentCount);
            if (count == currentCount) {
                objc_removeAssociatedObjects(self);
                [tipView removeFromSuperview];
                count = 0;
            }
        });
    }];
}

+ (void)xw_removeSimpleTipOnView:(UIView *)view{
    count ++;
//    NSLog(@"%zd", count);
    UIView *tipView = objc_getAssociatedObject(self, "XWSimpleTipView");
    if (tipView) {
        [tipView.layer removeAllAnimations];
        [tipView removeFromSuperview];
        objc_removeAssociatedObjects(self);
    }
}

@end
