//
//  BJNewsMediaUtils.h
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/25.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJNewsMediaUtils : NSObject

#define BJNEWS_MEDIA_SCALE [BJNewsMediaUtils screenScale]

#define BJNEWS_MEDIA_PLACHOLDERTEXT @"新京报 - 好新闻 无纸境"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/**
 判断是否为全面屏手机

 @return 是否为全面屏手机
 */
+ (BOOL)isHaveSafeArea;

/**
 获取状态栏高度

 @return 状态栏高度
 */
+ (CGFloat)statusBarHeight;

/**
 获取底部安全区a高度
 
 @return 底部安全区高度
 */
+ (CGFloat)bottomSafeAreaHeight;

+ (float)screenScale;

/**
 滑动块颜色

 @return return value description
 */
+ (UIColor *)sliderColor;

+ (UIColor *)colorWithHex:(NSInteger)rgbValue alpha:(float)alpha;

@end

NS_ASSUME_NONNULL_END
