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

@property (nonatomic,strong) UIView * superView;
@property (nonatomic,strong) UIView * playerView;

/**
 即将全屏旋转回调
 */
@property (nonatomic,copy) void (^orientationWillChange) (UIInterfaceOrientation orientation);

/**
 全屏旋转回调完成回调
 */
@property (nonatomic,copy) void (^orientationDidChanged) (UIInterfaceOrientation orientation);

- (void)setFullScreen:(BOOL)isFullScreen interfaceOrientation:(UIInterfaceOrientation)orientation fromFrame:(CGRect)fromFrame toFrame:(CGRect)toFrame animated:(BOOL)isAnimate completion:(void (^) (CGRect toFrame))competionHandler;

@end

NS_ASSUME_NONNULL_END
