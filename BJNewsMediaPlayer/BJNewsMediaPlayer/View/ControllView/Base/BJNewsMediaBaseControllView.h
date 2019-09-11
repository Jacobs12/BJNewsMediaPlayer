//
//  BJNewsMediaBaseControllView.h
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/10.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@property (nullable,weak,nonatomic) id <BJNewsMeidaBaseControllViewDelegate>delegate;

@property (nonatomic,strong) IBOutlet UIButton * playButton;
@property (nonatomic,strong) IBOutlet UIButton * replayButton;
@property (nonatomic,strong) IBOutlet UIButton * muteButton;
@property (nonatomic,strong) IBOutlet UILabel * timeLabel;
@property (nonatomic,strong) IBOutlet UILabel * totalLabel;
@property (nonatomic,strong) IBOutlet UIButton * screenButton;
@property (nonatomic,strong) IBOutlet UIView * loadingView;

@property (nonatomic,assign) MCPlayState state;

- (void)setPlayState:(MCPlayState)state;

- (void)updateProgress:(float)progress duration:(NSTimeInterval)duration totalDuration:(NSTimeInterval)totalDuration;

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

@end

NS_ASSUME_NONNULL_END
