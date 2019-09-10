//
//  BJNewsMediaPlayerView.h
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/10.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BJNewsMediaPlayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface BJNewsMediaPlayerView : UIView

typedef NS_ENUM(NSInteger,MEPControllViewType){
    MEPControllViewTypeNone,         // 无控制面板
    MEPControllViewTypeList,         // 列表是控制面板
    MEPControllViewTypePreview,      // 详情页控制面板
    MEPControllViewTypePortrait,     // 竖屏控制面板
    MEPControllViewTypeLandScape,    // 横屏控制面板
    MEPControllViewTypeShortVideo    // 小视频控制面板
};

+ (BJNewsMediaPlayerView *)defaultView;

@property (nonatomic,strong) BJNewsMediaPlayer * player;

@property (nonatomic,strong) UIView * containerView;

/**
 切换播放视图

 @param view 播放视图
 */
- (void)moveToView:(UIView *)view type:(MEPControllViewType)type;

/**
 @brief 刷新view，例如view size变化时。
 */
- (void)redraw;

#pragma mark - 播放控制

/**
 播放网络资源
 
 @param url url description
 */
- (void)playWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
