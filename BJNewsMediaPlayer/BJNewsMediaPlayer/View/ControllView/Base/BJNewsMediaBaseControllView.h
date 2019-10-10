//
//  BJNewsMediaBaseControllView.h
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/10.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BJNewsMediaUtils.h"
#import "BJNewsMediaPlayer.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BJNewsMeidaBaseControllViewDelegate;

@interface BJNewsMediaBaseControllView : UIView

typedef NS_ENUM(NSInteger,MCPlayState){
    MCPlayStateNone,
    MCPlayStatePaused,
    MCPlayStatePlaying,
    MCPlayStateLoadingStart,
    MCPlayStateLoadingEnded,
    MCPlayStateEnded,
    MCPlayStateError
};

typedef NS_ENUM(NSInteger,MCSourceType){
    MCSourceTypeVideo,     // 普通视频
    MCSourceTypeLive,      // 直播
    MCSourceTypePlayback   // 回放
};

@property (nullable,weak,nonatomic) id <BJNewsMeidaBaseControllViewDelegate>delegate;

#pragma mark - UI属性

/**
 播放按钮
 */
@property (nonatomic,strong) IBOutlet UIButton * playButton;

/**
 重播按钮
 */
@property (nonatomic,strong) IBOutlet UIButton * replayButton;

/**
 返回按钮
 */
@property (nonatomic,strong) IBOutlet UIButton * backButton;

/**
 静音按钮
 */
@property (nonatomic,strong) IBOutlet UIButton * muteButton;

/**
 当前播放时间Label
 */
@property (nonatomic,strong) IBOutlet UILabel * timeLabel;

/**
 总播放时间Label
 */
@property (nonatomic,strong) IBOutlet UILabel * totalLabel;

/**
 标题
 */
@property (nonatomic,strong) IBOutlet UILabel * titleLabel;

/**
 全屏按钮
 */
@property (nonatomic,strong) IBOutlet UIButton * screenButton;

/**
 loading动画
 */
@property (nonatomic,strong) IBOutlet UIView * loadingView;

/**
 滑动条
 */
@property (nonatomic,strong) IBOutlet UISlider * slider;

/**
 缓冲进度条
 */
@property (nonatomic,strong) IBOutlet UIProgressView * bufferProgress;

/**
 错误提示背景
 */
@property (nonatomic,strong) IBOutlet UIView * errorBg;

/**
 错误提示label
 */
@property (nonatomic,strong) IBOutlet UILabel * errorLabel;

/**
 重新加载按钮
 */
@property (nonatomic,strong) IBOutlet UIButton * errorButton;

/**
 错误提示背景
 */
@property (nonatomic,strong) IBOutlet UIImageView * errorImageView;

#pragma mark - 播放相关属性

/**
 播放源属性 视频/直播/回放
 */
@property (nonatomic,assign) MCSourceType sourceType;

/**
 当前播放状态
 */
@property (nonatomic,assign) MCPlayState state;

/**
 总播放时间
 */
@property (nonatomic,assign) NSTimeInterval totalTime;

/**
 标题
 */
@property (nonatomic,copy) NSString * title;

/**
 设置当前播放状态

 @param state 当前播放状态
 */
- (void)setPlayState:(MCPlayState)state;

/**
 设置播放源属性 视频/直播/回放

 @param sourceType 播放源属性
 */
- (void)setVideoSourceType:(MCSourceType)sourceType;

/**
 设置是否播放出错

 @param isError 是否播放出错
 */
- (void)setError:(BOOL)isError;

#pragma mark - 刷新控制面板

/**
 刷新播放进度

 @param progress 播放进度
 @param duration 当前播放时间
 @param totalDuration 总播放时间
 */
- (void)updateProgress:(float)progress duration:(NSTimeInterval)duration totalDuration:(NSTimeInterval)totalDuration;

/**
 更新缓冲进度

 @param progress 缓冲进度
 */
- (void)updateBufferProgress:(float)progress animate:(BOOL)isAnimated;

/**
  初始化/更新控制面板
 */
- (void)refreshControllViewWithPlayer:(BJNewsMediaPlayer *)player;

/**
 初始化/更新控制面板
 */
- (void)updatePlayState:(BJNewsMediaPlayState)playState withMediaPlayer:(BJNewsMediaPlayer *)mediaPlayer;

/**
 设置是否静音

 @param isMute 是否静音
 */
- (void)setMuteMode:(BOOL)isMute;

/**
 开始加载动画
 */
- (void)startLoading;

/**
 结束加载动画
 */
- (void)endLoading;

/**
 手动隐藏控制面板
 
 @param isAnimate 是否动画
 */
- (void)hideControllViewAnimated:(BOOL)isAnimate;

/**
 手动显示控制面板
 
 @param isAnimate 是否动画
 */
- (void)showControllViewAnimated:(BOOL)isAnimate;

/**
 设置控制面板是否隐藏
 
 @param isHidden 是否隐藏
 */
- (void)setControllViewHidden:(BOOL)isHidden;

/**
 设置控制面板透明度
 
 @param alpha 设置控制面板透明度
 */
- (void)setControllViewAlpha:(float)alpha;

/**
 将时间转换为字符串
 */
-(NSString *)convertTimeSecond:(NSInteger)timeSecond;

#pragma mark - 按钮点击事件

/**
 播放、暂停按钮点击
 
 @param sender sender description
 */
- (IBAction)playButtonClick:(id)sender;

/**
 重新播放按钮点击

 @param sender sender description
 */
- (IBAction)replayButtonClick:(id)sender;

/**
 静音按钮点击

 @param sender 静音按钮
 */
- (IBAction)muteButtonClick:(id)sender;

/**
 全屏按钮点击
 
 @param sender 全屏按钮
 */
- (IBAction)screenButtonClick:(id)sender;

@end

#pragma mark - 代理

@protocol BJNewsMeidaBaseControllViewDelegate <NSObject>

/**
 播放、暂停按钮点击回调
 
 @param controllView 控制面板
 @param isPlaying 是否是播放事件
 */
- (void)controllView:(BJNewsMediaBaseControllView *)controllView playButtonClick:(BOOL)isPlaying;

/**
 重新播放按钮点击

 @param controllView 控制面板
 @param isError 播放是否出错
 */
- (void)controllView:(BJNewsMediaBaseControllView *)controllView replayButtonClick:(BOOL)isError;

/**
 静音按钮点击回调

 @param controllView 控制面板
 @param isMute 是否静音
 */
- (void)controllView:(BJNewsMediaBaseControllView *)controllView muteButtonClick:(BOOL)isMute;

/**
 全屏按钮点击回调
 
 @param controllView 控制面板
 @param isFullScreen 是否全屏
 */
- (void)controllView:(BJNewsMediaBaseControllView *)controllView screenButtonClick:(BOOL)isFullScreen;

/**
 跳转到指定的播放进度回调

 @param controllView 控制面板
 @param progress 指定的播放进度
 */
- (void)controllView:(BJNewsMediaBaseControllView *)controllView seekToProgress:(float)progress;

@end

NS_ASSUME_NONNULL_END
