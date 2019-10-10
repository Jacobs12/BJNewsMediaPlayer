//
//  BJNewsMediaPlayer.m
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/10.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import "BJNewsMediaPlayer.h"

static BJNewsMediaPlayer * media_player = nil;

@interface BJNewsMediaPlayer () <AVPDelegate>

@end

@implementation BJNewsMediaPlayer

+ (BJNewsMediaPlayer *)defaultPlayer{
    if(media_player == nil){
        [AliPlayer setLogCallbackInfo:LOG_LEVEL_NONE callbackBlock:^(AVPLogLevel logLevel, NSString *strLog) {
            
        }];
        media_player = [[BJNewsMediaPlayer alloc]init];
    }
    return media_player;
}

- (AliPlayer *)player{
    if(_player == nil){
        _player = [[AliPlayer alloc]init];
        _player.delegate = self;
        _player.autoPlay = NO;
        _player.volume = 1.0f;
    }
    return _player;
}

/**
 设置播放视图

 @param playerView playerView description
 */
- (void)setPlayerView:(UIView *)playerView{
    _playerView = playerView;
    self.player.playerView = playerView;
}

#pragma mark - 播放器控制

/**
 播放网络资源
 
 @param url url description
 */
- (void)playWithUrl:(NSString *)url{
    if(_player){
        [_player stop];
    }
    [self setPlayState:BJNewsMediaPlayStateNone];
    if(url == nil || [url isKindOfClass:[NSNull class]]){
        url = @"";
    }
    self.url = url;
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLUserAllowedCharacterSet]];
    AVPUrlSource * source = [[AVPUrlSource alloc]init];
    source.playerUrl = [NSURL URLWithString:url];
    [self.player setUrlSource:source];
    [self.player prepare];
}

/**
 开始播放
 */
- (void)play{
    if(self.state != BJNewsMediaPlayStateLoading && self.state != BJNewsMediaPlayStateError){
        [self setPlayState:BJNewsMediaPlayStatePlaying];
    }
    [self.player start];
}

/**
 暂停播放
 */
- (void)pause{
    if(self.state != BJNewsMediaPlayStateLoading && self.state != BJNewsMediaPlayStateError){
        [self setPlayState:BJNewsMediaPlayStatePaused];
    }
    [self.player pause];
}

/**
 停止播放
 */
- (void)stop{
    [self setPlayState:BJNewsMediaPlayStateEnded];
    [self.player stop];
}

/**
 销毁播放器
 */
- (void)destroy{
    [self setPlayState:BJNewsMediaPlayStateNone];
    _player.playerView = nil;
    _player.delegate = nil;
    _player = nil;
    [self stop];
    [self.player destroy];
    media_player = nil;
}

/**
 重置播放器
 */
- (void)reset{
    [self setPlayState:BJNewsMediaPlayStateNone];
    [self.player reset];
}

/**
 重新加载。比如网络超时时，可以重新加载。
 */
- (void)reload{
    [self setPlayState:BJNewsMediaPlayStateNone];
    [self.player reload];
}

/**
 @brief 刷新view，例如view size变化时。
 */
-(void)redraw{
    [self.player redraw];
}

/**
 跳转到指定时间
 
 @param time 跳转时间
 @param handler 完成回调
 */
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^) (NSTimeInterval seekTime))handler{
    self.seekTime = time;
    self.seekTimeBlock = handler;
//    [self pause];
    int64_t duration = time;
    NSLog(@"seek to time:%lld",duration);
    [self.player seekToTime:duration seekMode:AVP_SEEKMODE_ACCURATE];
}

/**
 设置是否静音
 
 @param isMute 是否静音
 */
- (void)setMuteMode:(BOOL)isMute{
    [self.player setMuted:isMute];
}

- (void)setPlayState:(BJNewsMediaPlayState)state{
    self.state = state;
    if(self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:didUpdatePlayState:)]){
        [self.delegate mediaPlayer:self didUpdatePlayState:self.state];
    }
}

#pragma mark - getter

/**
 是否已经静音
 
 @return 是否已经静音
 */
- (BOOL)isMuted{
    BOOL isMuted = self.player.isMuted;
    return isMuted;
}

/**
 判断是否正在播放
 
 @return 是否正在播放
 */
- (BOOL)isPlaying{
    BOOL isPlaying = NO;
    if(self.state == BJNewsMediaPlayStatePlaying){
        isPlaying = YES;
    }
    return isPlaying;
}

/**
 获取视频时长
 
 @return 视频时长
 */
- (NSTimeInterval)totalDuration{
    NSTimeInterval time = self.player.duration;
    return time;
}

/**
 获取当前时间
 
 @return 当前时间
 */
- (NSTimeInterval)duration{
    NSTimeInterval duration = self.player.currentPosition;
    return duration;
}

/**
 获取播放进度
 
 @return 播放进度
 */
- (float)progress{
    NSTimeInterval totalDuration = self.player.duration;
    NSTimeInterval duration = self.player.currentPosition;
    float progress = 0;
    if(totalDuration != 0){
        progress = duration / totalDuration;
    }
    return progress;
}

/**
 获取缓冲进度
 
 @return 缓冲i进度
 */
- (float)bufferProgress{
    NSTimeInterval totalDuration = self.player.duration;
    NSTimeInterval duration = self.player.bufferedPosition;
    float progress = 0;
    if(totalDuration != 0){
        progress = duration / totalDuration;
    }
    return progress;
}

/**
 获取视频分辨率大小
 
 @return 视频分辨率大小
 */
- (CGSize)videoSize{
    CGSize size = CGSizeMake(self.player.width, self.player.height);
    return size;
}

#pragma mark - player delegate 播放器播放状态回调

/**
 播放错误回调

 @param player 播放器
 @param errorModel 错误信息
 */
- (void)onError:(AliPlayer *)player errorModel:(AVPErrorModel *)errorModel{
    if(player){
        [player stop];
    }
    [self setPlayState:BJNewsMediaPlayStateError];
    if(self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:failedPlayWithError:)]){
        [self.delegate mediaPlayer:self failedPlayWithError:errorModel];
    }
    NSString * log = [NSString stringWithFormat:@"播放错误:%@",self.url];
    MEPLog(log);
}

/**
 播放器事件回调

 @param player 播放器
 @param eventType 播放器事件类型
 */
- (void)onPlayerEvent:(AliPlayer *)player eventType:(AVPEventType)eventType{
    switch (eventType) {
        case AVPEventPrepareDone:
//           准备完成
            if(self.state == BJNewsMediaPlayStatePaused){
                
            }else{
                [self play];
            }
            if(self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayerDidPrepared:)]){
                [self.delegate mediaPlayerDidPrepared:self];
            }
            break;
        case AVPEventAutoPlayStart:
//            自动播放开始事件
            break;
        case AVPEventFirstRenderedStart:
//            首帧显示
            if(self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayerFirstRenderedStart:)]){
                [self.delegate mediaPlayerFirstRenderedStart:self];
            }
            break;
        case AVPEventCompletion:
//            播放完成
            [self setPlayState:BJNewsMediaPlayStateEnded];
            if(self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayerDidEnded:)]){
                [self.delegate mediaPlayerDidEnded:self];
            }
            break;
        case AVPEventLoadingStart:
//            缓冲开始
            [self setPlayState:BJNewsMediaPlayStateLoading];
            if(self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayerWillStartLoading:)]){
                [self.delegate mediaPlayerWillStartLoading:self];
            }
            break;
//            缓冲结束
        case AVPEventLoadingEnd:
            [self setPlayState:BJNewsMediaPlayStatePlaying];
            [self play];
            if(self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayerDidStopLoading:)]){
                [self.delegate mediaPlayerDidStopLoading:self];
            }
            break;
        case AVPEventSeekEnd:
//            跳转完成
            [self seekTimeEnd];
            break;
        case AVPEventLoopingStart:
//            循环播放开始
            break;
        default:
            break;
    }
}

/**
 跳转完成处理
 */
- (void)seekTimeEnd{
    float dt = self.seekTime - self.player.currentPosition;
    if(dt > 5000 || dt < -5000){
        [self seekToTime:self.seekTime completionHandler:self.seekTimeBlock];
        return;
    }
    [self play];
    if(self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:seekEnd:)]){
        [self.delegate mediaPlayer:self seekEnd:self.seekTime];
    }
    if(self.seekTimeBlock){
        self.seekTimeBlock(self.seekTime);
    }
}

/**
 播放进度回调，更新进度条

 @param player 播放器
 @param position 当前时间
 */
- (void)onCurrentPositionUpdate:(AliPlayer *)player position:(int64_t)position{
    if(self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:updateProgress:duraion:totalDuration:)]){
        double duration = position;
        double totalDuration = player.duration;
        float progress = 0.0f;
        if(totalDuration != 0){
            progress = duration / totalDuration;
        }
        [self.delegate mediaPlayer:self updateProgress:progress duraion:duration totalDuration:totalDuration];
    }
}

/**
 视频缓存位置回调

 @param player 播放器
 @param position 当前缓冲进度
 */
- (void)onBufferedPositionUpdate:(AliPlayer *)player position:(int64_t)position{
    if(self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:updateBufferProgress:bufferDuration:)]){
        double duration = position;
        double totalDuration = player.duration;
        float progress = 0.0f;
        if(totalDuration != 0){
            progress = duration / totalDuration;
        }
        [self.delegate mediaPlayer:self updateBufferProgress:progress bufferDuration:duration];
    }
}

@end
