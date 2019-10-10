//
//  BJNewsMediaPlayerView.m
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/10.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import "BJNewsMediaPlayerView.h"
#import "BJNewsMediaListContollView.h"
#import "BJNewsMediaShortVideoControllView.h"
#import "BJNewsMediaLandScapeControllView.h"
#import "BJNewsMediaPortraitControllView.h"
#import "BJNewsMediaPreviewControllView.h"
#import "BJNewsMediaOrientationManager.h"

static BJNewsMediaPlayerView * player_view = nil;

@interface BJNewsMediaPlayerView () <BJNewsMediaPlayerDelegate,BJNewsMeidaBaseControllViewDelegate>

/**
 控制面板数组
 */
@property (nonatomic,strong) NSMutableArray * controllArray;

/**
 当前控制面板
 */
@property (nonatomic,strong) BJNewsMediaBaseControllView * controllView;

/**
 屏幕旋转控制
 */
@property (nonatomic,strong) BJNewsMediaOrientationManager * orientationManager;

/**
 原始的容器view
 */
@property (nonatomic,strong) UIView * containerView;

/**
 当前的父视图
 */
@property (nonatomic,strong) UIView * baseView;

/**
 App恢复运行时，视频是否继续播放
 */
@property (nonatomic,assign) BOOL isContinuePlay;

/**
 视频预览图片
 */
@property (nonatomic,strong) UIImageView * coverImageView;

@end

@implementation BJNewsMediaPlayerView

+ (BJNewsMediaPlayerView *)defaultView{
    if(player_view == nil){
        player_view = [[BJNewsMediaPlayerView alloc]init];
        player_view.backgroundColor = [UIColor blackColor];
    }
    return player_view;
}

- (instancetype)init{
    self = [super init];
    if(self){
        [self addNotifications];
    }
    return self;
}

#pragma mark - 接收通知

- (void)addNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerApplicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerApplicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)playerApplicationWillResignActive:(NSNotification *)noti{
    if(_player && _player.isPlaying){
        self.isContinuePlay = YES;
    }else{
        self.isContinuePlay = NO;
    }
    if(_player){
        [self.player pause];
    }
}

- (void)playerApplicationDidBecomeActive:(NSNotification *)noti{
    if(self.isContinuePlay && _player){
        [self.player play];
    }
}

#pragma mark - getter

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

- (UIImageView *)coverImageView{
    if(_coverImageView == nil){
        _coverImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _coverImageView.hidden = YES;
        _coverImageView.backgroundColor = [UIColor orangeColor];
    }
    return _coverImageView;
}

#pragma mark - View

/**
 切换播放视图
 
 @param view 播放视图
 */
- (void)moveToView:(UIView *)view controllViewtype:(MEPControllViewType)controllType sourceType:(MCSourceType)sourceType{
    self.sourceType = sourceType;
    self.containerView = view;
    self.baseView = self.containerView;
    [view addSubview:self];
    self.player.playerView = self;
    if(self.controllView){
        [self.controllView removeFromSuperview];
    }
    self.controllView = [self controllViewWithType:controllType];
    if(self.controllView){
        [self addSubview:self.controllView];
        [self insertSubview:self.coverImageView belowSubview:self.controllView];
    }
    [self resetControllViewWithPlayer:self.player];
    [self redraw];
}

/**
 切换控制面板

 @param view 父视图
 @param controllType 类型
 */
- (void)switchFullScreenModeToView:(UIView *)view controllType:(MEPControllViewType)controllType{
    self.baseView = view;
    self.player.playerView = self;
    [self replaceControllViewWithType:controllType];
    if(controllType == MEPControllViewTypePortrait){
        [self.orientationManager scaleToPortraitWithView:self completionHandler:^{
            [self redraw];
        }];
        [self redraw];
    }else if (controllType == MEPControllViewTypeLandScape){
//            横屏全屏
//        self.orientationManager.playerView = self;
//        self.orientationManager.superView = self.baseView;
//        [self.orientationManager setFullScreen:YES interfaceOrientation:UIInterfaceOrientationLandscapeRight fromFrame:self.frame toFrame:view.bounds animated:YES completion:^(CGRect toFrame) {
////            [weak_self.container setNeedsStatusBarAppearanceUpdate];
////            [UIViewController attemptRotationToDeviceOrientation];
//        }];
        [self.orientationManager rotateToLandScapeWithView:self completionHandler:^{
            
        }];
        [self redraw];
    }else if (controllType == MEPControllViewTypePreview){
        [self.orientationManager resumeWithView:self toView:self.baseView completionHandler:^{
            [self redraw];
        }];
    }
}

- (void)replaceControllViewWithType:(MEPControllViewType)controllType{
    if(self.controllView){
        [self.controllView removeFromSuperview];
    }
    self.controllView = [self controllViewWithType:controllType];
    if(self.controllView){
        [self addSubview:self.controllView];
        [self insertSubview:self.coverImageView belowSubview:self.controllView];
    }
    [self resetControllViewWithPlayer:self.player];
}

- (void)resetControllViewWithPlayer:(BJNewsMediaPlayer *)player{
    [self.controllView refreshControllViewWithPlayer:player];
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
    self.coverImageView.frame = self.bounds;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.player redraw];
    });
}

/**
 显示预览图

 @param isShow 是否显示
 */
- (void)showCoverImage:(BOOL)isShow{
    if(isShow){
        if(self.coverImageView.window == nil){
            [self addSubview:self.coverImageView];
        }
        if(self.controllView){
            [self insertSubview:self.coverImageView belowSubview:self.controllView];
        }
        self.coverImageView.hidden = NO;
    }else{
        self.coverImageView.hidden = YES;
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
    [controllView setVideoSourceType:self.sourceType];
    controllView.title = self.title;
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
    [self showCoverImage:YES];
    self.url = url;
    [self.player playWithUrl:url];
}

/**
 设置标题、预览图
 
 @param title 标题
 @param coverImage 预览图
 */
- (void)setPlayerTitle:(NSString *)title coverImage:(NSString *)coverImage{
    [self setPlayerTitle:title coverImage:coverImage videoSize:CGSizeZero];
}

/**
 设置标题、预览图、视频大小
 
 @param title 标题
 @param coverImage 预览图
 @param videoSize 视频大小
 */
- (void)setPlayerTitle:(NSString *)title coverImage:(NSString *)coverImage videoSize:(CGSize)videoSize{
    self.title = title;
    self.controllView.title = title;
    self.coverImage = coverImage;
    self.videoSize = videoSize;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:coverImage] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
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
    [self showCoverImage:NO];
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
    if(self.controllView){
        if(progress > self.controllView.bufferProgress.progress){
            [self.controllView updateBufferProgress:progress animate:YES];
        }
    }
}

/**
 播放状态更新
 
 @param mediaPlayer 播放器
 @param playState 播放状态
 */
- (void)mediaPlayer:(BJNewsMediaPlayer *)mediaPlayer didUpdatePlayState:(BJNewsMediaPlayState)playState{
    if(self.controllView){
        [self.controllView updatePlayState:playState withMediaPlayer:mediaPlayer];
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
    isMute = !self.player.isMuted;
    [self.player setMuteMode:isMute completionHandler:^(BOOL isMuted) {
        [controllView setMuteMode:isMuted];
    }];
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
        if(width - height > -10){
            UIView * view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
            [self switchFullScreenModeToView:view controllType:MEPControllViewTypeLandScape];
        }else{
//            竖屏全屏
            UIView * view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
            [self switchFullScreenModeToView:view controllType:MEPControllViewTypePortrait];
        }
    }else{
        UIView * view = self.containerView;
        [self switchFullScreenModeToView:view controllType:MEPControllViewTypePreview];
    }
}

/**
 跳转到指定的播放进度回调
 
 @param controllView 控制面板
 @param progress 指定的播放进度
 */
- (void)controllView:(BJNewsMediaBaseControllView *)controllView seekToProgress:(float)progress{
    if(self.player.state == BJNewsMediaPlayStateError){
        NSLog(@"视频源或网络错误，无法跳转至指定播放时间");
        return;
    }
    NSTimeInterval duration = self.player.totalDuration * progress;
    NSLog(@"%f",duration);
    [self.player play];
    [self.player seekToTime:duration completionHandler:^(NSTimeInterval seekTime) {
        
    }];
}

#pragma mark - 销毁播放器

/**
 销毁播放器
 */
- (void)destroy{
    if(_player){
        [_player destroy];
        _player = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [self removeFromSuperview];
    player_view = nil;
}

@end
