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

/**
 初始化，单例
 若要实现横屏全屏播放,在viewController中实现- (BOOL)shouldAutorotate方法，建议return NO；
 @return 播放器
 */
+ (BJNewsMediaPlayerView *)defaultView;

//@property (nonatomic,copy,nullable) id (^screenWillRotateBlock) (BOOL isPortrait);

/**
 当前播放器
 */
@property (nonatomic,strong) BJNewsMediaPlayer * player;

/**
 视频播放地址
 */
@property (nonatomic,copy) NSString * url;

#pragma mark - 初始化播放器视图

/**
 切换播放视图
 
 @param view 播放视图
 */
- (void)moveToView:(UIView *)view type:(MEPControllViewType)type isLive:(BOOL)isLive;

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

#pragma mark - 视频属性

/**
 是否为直播
 */
@property (nonatomic,assign) BOOL isLive;

/**
 视频标题
 */
@property (nonatomic,copy) NSString * title;

/**
 视频预览图
 */
@property (nonatomic,copy) NSString * coverImage;

/**
 视频宽高
 */
@property (nonatomic,assign) CGSize videoSize;

/**
 设置标题、预览图
 
 @param title 标题
 @param coverImage 预览图
 */
- (void)setPlayerTitle:(NSString *)title coverImage:(NSString *)coverImage;

/**
 设置标题、预览图、视频大小
 
 @param title 标题
 @param coverImage 预览图
 @param videoSize 视频大小
 */
- (void)setPlayerTitle:(NSString *)title coverImage:(NSString *)coverImage videoSize:(CGSize)videoSize;

#pragma mark - 销毁播放器

/**
 销毁播放器
 */
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
