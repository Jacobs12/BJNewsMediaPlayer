//
//  BJNewsMediaOrientationManager.m
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/6/19.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import "BJNewsMediaOrientationManager.h"

@interface BJNewsMediaOrientationManager ()

@end

@implementation BJNewsMediaOrientationManager

- (void)setFullScreen:(BOOL)isFullScreen interfaceOrientation:(UIInterfaceOrientation)orientation fromFrame:(CGRect)fromFrame toFrame:(CGRect)toFrame animated:(BOOL)isAnimate  completion:(void (^) (CGRect toFrame))competionHandler{
    if(isFullScreen){
        if(UIInterfaceOrientationIsLandscape(orientation)){// 切换为全屏横屏
            [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.playerView];
            if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
                if(self.orientationWillChange){
                    self.orientationWillChange(orientation);
                }
                [UIApplication sharedApplication].statusBarOrientation = orientation;
                [UIView animateWithDuration:0.3 animations:^{
                    self.playerView.frame = CGRectMake(0, 0, [self screenHeight], [self screenWidth]);
                    self.playerView.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
                    self.playerView.center = CGPointMake([self screenWidth] / 2.0, [self screenHeight] / 2.0);
                } completion:^(BOOL finished) {
                    if(self.orientationDidChanged){
                        self.orientationDidChanged(orientation);
                    }
                }];
            }
        }else{ // 切换为全屏竖屏
            [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.playerView];
            if(self.orientationWillChange){
                self.orientationWillChange(orientation);
            }
            [UIView animateWithDuration:0.2 animations:^{
                self.playerView.frame = CGRectMake(0, 0, [self screenWidth], [self screenHeight]);
            } completion:^(BOOL finished) {
                if(self.orientationDidChanged){
                    self.orientationDidChanged(orientation);
                }
                if(competionHandler){
                    competionHandler(toFrame);
                }
            }];
        }

    }else{ // 切换到预览状态
        if(self.orientationWillChange){
            self.orientationWillChange(orientation);
        }
        if([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait){
//            横屏切换到预览状态
            [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
            [self.superView addSubview:self.playerView];
            [UIView animateWithDuration:0.3 animations:^{
                self.playerView.transform = CGAffineTransformMakeRotation(0);
                self.playerView.frame = toFrame;
            } completion:^(BOOL finished) {
                if(self.orientationDidChanged){
                    self.orientationDidChanged(orientation);
                }
            }];
        }else if(isAnimate){
            [self.superView addSubview:self.playerView];
            [UIView animateWithDuration:0.2 animations:^{
                self.playerView.frame = toFrame;
            } completion:^(BOOL finished) {
                if(self.orientationDidChanged){
                    self.orientationDidChanged(orientation);
                }
            }];
        }else{
            self.playerView.frame = toFrame;
            [self.superView addSubview:self.playerView];
            if(self.orientationDidChanged){
                self.orientationDidChanged(orientation);
            }
        }
    }
}

/**
 强制转屏
 
 @param orientation 设备朝向
 */
//- (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation{
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        SEL selector  = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        // 从2开始是因为前两个参数已经被selector和target占用
//        [invocation setArgument:&orientation atIndex:2];
//        [invocation invoke];
//    }
//}

- (float)screenWidth{
    float width = [UIScreen mainScreen].bounds.size.width;
    if(width > [UIScreen mainScreen].bounds.size.height){
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

/**
 屏幕适配 -> 适用于修正iPad屏幕旋转造成的屏幕宽高变换
 
 @return 屏幕高度
 */
- (float)screenHeight{
    float height = [UIScreen mainScreen].bounds.size.height;
    if(height < [UIScreen mainScreen].bounds.size.width){
        height = [UIScreen mainScreen].bounds.size.width;
    }
    return height;
}

@end
