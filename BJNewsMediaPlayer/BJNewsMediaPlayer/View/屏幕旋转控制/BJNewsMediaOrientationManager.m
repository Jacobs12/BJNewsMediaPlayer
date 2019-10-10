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

/**
 播放器旋转至横屏
 
 @param rotateView 要旋转的view
 @param handler 完成回调
 */
- (void)rotateToLandScapeWithView:(UIView *)rotateView completionHandler:(void (^)(void))handler{
    UIView * toView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    UIView * blackView = [[UIView alloc]initWithFrame:toView.bounds];
    blackView.backgroundColor = [UIColor blackColor];
    [toView addSubview:blackView];
    
    [toView addSubview:rotateView];
//     若要实现横屏全屏播放,在viewController中实现- (BOOL)shouldAutorotate方法，建议return NO；
    [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeRight;
    [UIView animateWithDuration:0.3 animations:^{
        rotateView.frame = CGRectMake(0, 0, [self screenHeight], [self screenWidth]);
        rotateView.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
        rotateView.center = CGPointMake([self screenWidth] / 2.0, [self screenHeight] / 2.0);
    } completion:^(BOOL finished) {
        [blackView removeFromSuperview];
        if(handler){
            handler();
        }
    }];
}

/**
 播放器切换到竖屏全屏播放
 
 @param scaleView 缩放的view
 @param handler 完成回调
 */
- (void)scaleToPortraitWithView:(UIView *)scaleView completionHandler:(void (^) (void))handler{
    UIView * toView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
//    先将View移动superView对应的位置
    CGPoint center = [scaleView convertPoint:scaleView.center toView:toView];
//
    UIView * tempView = [[UIView alloc]initWithFrame:scaleView.bounds];
    tempView.center = CGPointMake(center.x, center.y);
    tempView.layer.masksToBounds = YES;
    [toView addSubview:tempView];
    
    scaleView.frame = toView.bounds;

    [tempView addSubview:scaleView];
    scaleView.center = CGPointMake(tempView.bounds.size.width / 2.0, tempView.bounds.size.height / 2.0);

    [UIView animateWithDuration:0.3 animations:^{
        tempView.frame = toView.bounds;
        scaleView.center = CGPointMake(tempView.bounds.size.width / 2.0, tempView.bounds.size.height / 2.0);
    } completion:^(BOOL finished) {
        [toView addSubview:scaleView];
        scaleView.center = CGPointMake(toView.bounds.size.width / 2.0, toView.bounds.size.height / 2.0);
        [tempView removeFromSuperview];
    }];
}

/**
 恢复播放器原先位置
 
 @param resumeView 要恢复的view
 @param toView 恢复到superView
 @param handler 完成回调
 */
- (void)resumeWithView:(UIView *)resumeView toView:(UIView *)toView completionHandler:(void (^) (void))handler{
    if(UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) == NO){
//        竖屏全屏恢复到预览模式
        [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
        [toView addSubview:resumeView];
        [UIView animateWithDuration:0.3 animations:^{
//            必须是修改transform在前，修改frame在后
            resumeView.transform = CGAffineTransformMakeRotation(0);
            resumeView.frame = toView.bounds;
            for (UIView * subView in resumeView.subviews) {
                subView.frame = toView.bounds;
            }
        } completion:^(BOOL finished) {
            if(handler){
                handler();
            }
        }];
    }else{
        UIView * windowView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
        CGPoint center = [toView convertPoint:toView.center toView:windowView];
        if(toView.superview == windowView){
            center = toView.center;
        }

        UIView * tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, resumeView.bounds.size.width, resumeView.bounds.size.height)];
        tempView.layer.masksToBounds = YES;
        [windowView addSubview:tempView];
        tempView.backgroundColor = [UIColor blackColor];

        [tempView addSubview:resumeView];
        resumeView.center = CGPointMake(tempView.bounds.size.width / 2.0, tempView.bounds.size.height / 2.0);
        
        [UIView animateWithDuration:0.3 animations:^{
            tempView.frame = toView.bounds;
            tempView.center = CGPointMake(center.x, center.y);
            resumeView.center = CGPointMake(tempView.bounds.size.width / 2.0, tempView.bounds.size.height / 2.0);
            for (UIView * subView in resumeView.subviews) {
                subView.frame = resumeView.bounds;
            }
        } completion:^(BOOL finished) {
            resumeView.bounds = toView.bounds;
            [toView addSubview:resumeView];
            [tempView removeFromSuperview];
            if(handler){
                handler();
            }
        }];
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
