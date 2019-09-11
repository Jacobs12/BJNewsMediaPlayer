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

static BJNewsMediaPlayerView * player_view = nil;

@interface BJNewsMediaPlayerView () <BJNewsMediaPlayerDelegate>

@property (nonatomic,strong) NSMutableArray * controllArray;
@property (nonatomic,strong) BJNewsMediaBaseControllView * controllView;

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

/**
 切换播放视图
 
 @param view 播放视图
 */
- (void)moveToView:(UIView *)view type:(MEPControllViewType)type{
    self.containerView = view;
    [view addSubview:self];
    self.player.playerView = self;
    if(self.controllView){
        [self.controllView removeFromSuperview];
    }
    self.controllView = [self controllViewWithType:type];
    if(self.controllView){
        [self addSubview:self.controllView];
    }
    [self redraw];
}

/**
 @brief 刷新view，例如view size变化时。
 */
- (void)redraw{
    self.frame = self.containerView.bounds;
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
    
}

/**
 开始加载回调，loading开始转圈
 
 @param mediaPlayer 播放器
 */
- (void)mediaPlayerWillStartLoading:(BJNewsMediaPlayer *)mediaPlayer{
    if(self.controllView){
        [self.controllView setPlayState:MCPlayStateLoading];
    }
}

/**
 结束加载回调，loading结束转圈
 
 @param mediaPlayer 播放器
 */
- (void)mediaPlayerDidStopLoading:(BJNewsMediaPlayer *)mediaPlayer{
    if(self.controllView){
        [self.controllView setPlayState:MCPlayStatePlaying];
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

@end
