//
//  BJNewsMediaPlayerView.m
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/10.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import "BJNewsMediaPlayerView.h"
#import "BJNewsMediaBaseControllView.h"
#import "BJNewsMediaListContollView.h"
#import "BJNewsMediaShortVideoControllView.h"
#import "BJNewsMediaLandScapeControllView.h"
#import "BJNewsMediaPortraitControllView.h"
#import "BJNewsMediaPreviewControllView.h"
#import "BJNewsMediaOrientationManager.h"

static BJNewsMediaPlayerView * player_view = nil;

@interface BJNewsMediaPlayerView () <BJNewsMediaPlayerDelegate,BJNewsMeidaBaseControllViewDelegate>

@property (nonatomic,strong) NSMutableArray * controllArray;
@property (nonatomic,strong) BJNewsMediaBaseControllView * controllView;
@property (nonatomic,strong) BJNewsMediaOrientationManager * orientationManager;

@end

@implementation BJNewsMediaPlayerView

+ (BJNewsMediaPlayerView *)defaultView{
    if(player_view == nil){
        player_view = [[BJNewsMediaPlayerView alloc]init];
    }
    return player_view;
}

- (BJNewsMediaPlayer *)player{
    if(_player == nil){
        _player = [BJNewsMediaPlayer defaultPlayer];
        _player.delegate = self;
    }
    return _player;
}

- (NSMutableArray *)controllArray{
    if(_controllArray == nil){
        _controllArray = [[NSMutableArray alloc]init];
    }
    return _controllArray;
}

- (BJNewsMediaOrientationManager *)orientationManager{
    if(_orientationManager == nil){
        _orientationManager = [[BJNewsMediaOrientationManager alloc]init];
    }
    return _orientationManager;
}

/**
 切换播放视图
 
 @param view 播放视图
 */
- (void)moveToView:(UIView *)view type:(MEPControllViewType)type{
    self.containerView = view;
    self.baseView = self.containerView;
    [view addSubview:self];
    self.player.playerView = self;
    if(self.controllView){
        [self.controllView removeFromSuperview];
    }
    self.controllView = [self controllViewWithType:type];
    if(self.controllView){
        [self addSubview:self.controllView];
    }
    [self resetControllView];
    [self redraw];
}

- (void)switchFullScreenModeToView:(UIView *)view type:(MEPControllViewType)type{
    self.baseView = view;
    if(type == MEPControllViewTypePortrait){
        CGPoint center = [self convertPoint:self.center toView:view];
        self.center = center;
    }else if (type == MEPControllViewTypeLandScape){
//            横屏全屏
        self.orientationManager.playerView = self;
        self.orientationManager.superView = self.baseView;
        [self.orientationManager setFullScreen:YES interfaceOrientation:UIInterfaceOrientationLandscapeLeft fromFrame:self.frame toFrame:view.bounds animated:YES completion:^(CGRect toFrame) {
            [self.container setNeedsStatusBarAppearanceUpdate];
            [UIViewController attemptRotationToDeviceOrientation];
        }];
    }else if (type == MEPControllViewTypePreview){
        self.orientationManager.playerView = self;
        self.orientationManager.superView = self.baseView;
        [self.orientationManager setFullScreen:NO interfaceOrientation:UIInterfaceOrientationPortrait fromFrame:self.frame toFrame:view.bounds animated:YES completion:^(CGRect toFrame) {
            
        }];
    }
    [view addSubview:self];
    self.player.playerView = self;
    if(self.controllView){
        [self.controllView removeFromSuperview];
    }
    self.controllView = [self controllViewWithType:type];
    if(self.controllView){
        [self addSubview:self.controllView];
    }
    [self resetControllView];
    [UIView animateWithDuration:0.2 animations:^{
        [self redraw];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)resetControllView{
    
}

/**
 @brief 刷新view，例如view size变化时。
 */
- (void)redraw{
    self.frame = self.baseView.bounds;
    [self.player redraw];
    if(self.controllView){
        self.controllView.frame = self.bounds;
    }
}

#pragma mark - view

- (BJNewsMediaBaseControllView *)controllViewWithType:(MEPControllViewType)type{
    NSString * nibName = nil;
    if(type == MEPControllViewTypeNone){
        
    }else if (type == MEPControllViewTypeList){
        nibName = @"BJNewsMediaListContollView";
    }else if (type == MEPControllViewTypePortrait){
        nibName = @"BJNewsMediaPortraitControllView";
    }else if (type == MEPControllViewTypeLandScape){
        nibName = @"BJNewsMediaLandScapeControllView";
    }else if (type == MEPControllViewTypeShortVideo){
        nibName = @"BJNewsMediaShortVideoControllView";
    }else if (type == MEPControllViewTypePreview){
        nibName = @"BJNewsMediaPreviewControllView";
    }
    if(nibName == nil){
        return nil;
    }
    BJNewsMediaBaseControllView * controllView = nil;
    for (BJNewsMediaBaseControllView * object in self.controllArray) {
        NSString * class = [NSString stringWithFormat:@"%@",object.class];
        if([class isEqualToString:nibName]){
            controllView = object;
        }
    }
    if(controllView == nil){
        controllView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] firstObject];
        controllView.delegate = self;
        [self.controllArray addObject:controllView];
    }
    return controllView;
}

#pragma mark - 播放控制

/**
 播放网络资源
 
 @param url url description
 */
- (void)playWithUrl:(NSString *)url{
    if(self.controllView){
        [self.controllView setPlayState:MCPlayStateNone];
    }
    self.url = url;
    [self.player playWithUrl:url];
}

#pragma mark - delegate 播放器回调

/**
 播放器已经做好播放准备回调
 
 @param mediaPlayer 播放器
 */
- (void)mediaPlayerDidPrepared:(BJNewsMediaPlayer *)mediaPlayer{
    
}

/**
 开始显示第一帧回调
 
 @param mediaPlayer mediaPlayer description
 */
- (void)mediaPlayerFirstRenderedStart:(BJNewsMediaPlayer *)mediaPlayer{
    
}

/**
 播放完成回调
 
 @param mediaPlayer 播放器
 */
- (void)mediaPlayerDidEnded:(BJNewsMediaPlayer *)mediaPlayer{
    
}

/**
 播放失败回调
 
 @param mediaPlayer 播放器
 */
- (void)mediaPlayer:(BJNewsMediaPlayer *)mediaPlayer failedPlayWithError:(AVPErrorModel *)error{
    if(self.controllView){
        [self.controllView setPlayState:MCPlayStateError];
    }
}

/**
 开始加载回调，loading开始转圈
 
 @param mediaPlayer 播放器
 */
- (void)mediaPlayerWillStartLoading:(BJNewsMediaPlayer *)mediaPlayer{
    if(self.controllView){
        [self.controllView setPlayState:MCPlayStateLoadingStart];
    }
}

/**
 结束加载回调，loading结束转圈
 
 @param mediaPlayer 播放器
 */
- (void)mediaPlayerDidStopLoading:(BJNewsMediaPlayer *)mediaPlayer{
    if(self.controllView){
        [self.controllView setPlayState:MCPlayStateLoadingEnded];
    }
}

/**
 跳转到指定播放时间成功回调
 
 @param mediaPlayer 播放器
 @param seekTime 跳转到的时间
 */
- (void)mediaPlayer:(BJNewsMediaPlayer *)mediaPlayer seekEnd:(NSTimeInterval)seekTime{
    
}

/**
 播放进度回调，更新进度条
 
 @param mediaPlayer 播放器
 @param progress 播放进度
 @param duration 当前时间
 @param totalDuration 总时间
 */
- (void)mediaPlayer:(BJNewsMediaPlayer *)mediaPlayer updateProgress:(float)progress duraion:(NSTimeInterval)duration totalDuration:(NSTimeInterval)totalDuration{
    if(self.controllView){
        [self.controllView updateProgress:progress duration:duration totalDuration:totalDuration];
    }
}

/**
 缓冲进度回调，更新进度条
 
 @param mediaPlayer 播放器
 @param progress 缓冲进度
 */
- (void)mediaPlayer:(BJNewsMediaPlayer *)mediaPlayer updateBufferProgress:(float)progress bufferDuration:(NSTimeInterval)duration{
 
}

/**
 播放状态更新
 
 @param mediaPlayer 播放器
 @param playState 播放状态
 */
- (void)mediaPlayer:(BJNewsMediaPlayer *)mediaPlayer didUpdatePlayState:(BJNewsMediaPlayState)playState{
    if(self.controllView){
        if(playState == BJNewsMediaPlayStatePlaying){
            [self.controllView setPlayState:MCPlayStatePlaying];
        }else if(playState == BJNewsMediaPlayStateEnded){
            [self.controllView setPlayState:MCPlayStateEnded];
        }else if (playState == BJNewsMediaPlayStatePaused){
            [self.controllView setPlayState:MCPlayStatePaused];
        }
    }
}

#pragma mark - delegate 控制面板回调

/**
 播放、暂停按钮点击回调
 
 @param controllView 控制面板
 @param isPlaying 是否是播放事件
 */
- (void)controllView:(BJNewsMediaBaseControllView *)controllView playButtonClick:(BOOL)isPlaying{
    if(isPlaying){
        [self.player play];
    }else{
        [self.player pause];
    }
}

/**
 重新播放按钮点击
 
 @param controllView 控制面板
 @param isError 播放是否出错
 */
- (void)controllView:(BJNewsMediaBaseControllView *)controllView replayButtonClick:(BOOL)isError{
    [self playWithUrl:self.url];
}

/**
 静音按钮点击回调
 
 @param controllView 控制面板
 @param isMute 是否静音
 */
- (void)controllView:(BJNewsMediaBaseControllView *)controllView muteButtonClick:(BOOL)isMute{
    [self.player setMuteMode:isMute];
}

/**
 全屏按钮点击回调
 
 @param controllView 控制面板
 @param isFullScreen 是否全屏
 */
- (void)controllView:(BJNewsMediaBaseControllView *)controllView screenButtonClick:(BOOL)isFullScreen{
    if(self.containerView == nil){
        return;
    }
    if(isFullScreen){
        float width = self.videoSize.width;
        float height = self.videoSize.height;
        if(width < 10 || height < 10){
            width = [self.player videoSize].width;
            height = [self.player videoSize].height;
        }
//        if(width - height > -10){
        if(1){
            UIView * view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
            [self switchFullScreenModeToView:view type:MEPControllViewTypeLandScape];
        }else{
//            竖屏全屏
            UIView * view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
            [self switchFullScreenModeToView:view type:MEPControllViewTypePortrait];
        }
    }else{
        UIView * view = self.containerView;
        [self switchFullScreenModeToView:view type:MEPControllViewTypePreview];
    }
}

@end
