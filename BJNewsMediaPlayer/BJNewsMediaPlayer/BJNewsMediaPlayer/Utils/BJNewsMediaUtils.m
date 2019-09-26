//
//  BJNewsMediaUtils.m
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/25.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import "BJNewsMediaUtils.h"

@interface BJNewsMediaUtils ()

@end

@implementation BJNewsMediaUtils

/**
 判断是否为全面屏手机
 
 @return 是否为全面屏手机
 */
+ (BOOL)isHaveSafeArea{
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}

/**
 获取状态栏高度
 
 @return 状态栏高度
 */
+ (CGFloat)statusBarHeight{
    BOOL isHaveSafeArea = [BJNewsMediaUtils isHaveSafeArea];
    if(isHaveSafeArea == NO){
        return 20;
    }else{
        return 20 + 24;
    }
}

/**
 获取底部安全区a高度

 @return 底部安全区高度
 */
+ (CGFloat)bottomSafeAreaHeight{
    BOOL isHaveSafeArea = [BJNewsMediaUtils isHaveSafeArea];
    if(isHaveSafeArea == NO){
        return 0;
    }else{
        return 34;
    }
}

+ (float)screenScale{
    float scale = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) / 375.0;
    return scale;
}

/**
 滑动块颜色
 
 @return return value description
 */
+ (UIColor *)sliderColor{
    UIColor * color = UIColorFromRGB(0xB81C22);
    return color;
}

@end
