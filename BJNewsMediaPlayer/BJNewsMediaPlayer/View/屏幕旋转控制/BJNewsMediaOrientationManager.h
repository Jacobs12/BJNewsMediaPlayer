//
//  BJNewsMediaOrientationManager.h
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/6/19.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJNewsMediaOrientationManager : NSObject

/**
 播放器旋转至横屏

 @param rotateView 要旋转的view
 @param handler 完成回调
 */
- (void)rotateToLandScapeWithView:(UIView *)rotateView completionHandler:(void (^) (void))handler;

/**
 播放器切换到竖屏全屏播放

 @param scaleView 缩放的view
 */
- (void)scaleToPortraitWithView:(UIView *)scaleView completionHandler:(void (^) (void))handler;

/**
 恢复播放器原先位置

 @param resumeView 要恢复的view
 @param toView 恢复到superView
 @param handler 完成回调
 */
- (void)resumeWithView:(UIView *)resumeView toView:(UIView *)toView completionHandler:(void (^) (void))handler;

@end

NS_ASSUME_NONNULL_END
