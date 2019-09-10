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
    if(url == nil || [url isKindOfClass:[NSNull class]]){
        url = @"";
    }
    AVPUrlSource * source = [[AVPUrlSource alloc]init];
    source.playerUrl = [NSURL URLWithString:url];
    [self.player setUrlSource:source];
    [self.player prepare];
}

/**
 开始播放
 */
- (void)play{
    [self.player start];
}

/**
 暂停播放
 */
- (void)pause{
    [self.player pause];
}

/**
 停止播放
 */
- (void)stop{
    [self.player stop];
}

/**
 销毁播放器
 */
- (void)destroy{
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
    [self.player reset];
}

/**
 重新加载。比如网络超时时，可以重新加载。
 */
- (void)reload{
    [self.player reload];
}

/**
 跳转到指定时间
 
 @param time 跳转时间
 @param handler 完成回调
 */
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^) (NSTimeInterval seekTime))handler{
    self.seekTime = time;
    self.seekTimeBlock = handler;
    [self.player seekToTime:time seekMode:AVP_SEEKMODE_INACCURATE];
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
    MEPLog(@"播放错误");
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
            if(self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayerDidEnded:)]){
                [self.delegate mediaPlayerDidEnded:self];
            }
            break;
        case AVPEventLoadingStart:
//            缓冲开始
            if(self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayerWillStartLoading:)]){
                [self.delegate mediaPlayerWillStartLoading:self];
            }
            break;
        case AVPEventSeekEnd:
//            跳转完成
     
            if(self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:seekEnd:)]){
                [self.delegate mediaPlayer:self seekEnd:self.seekTime];
            }
            if(self.seekTimeBlock){
                self.seekTimeBlock(self.seekTime);
            }
            break;
        case AVPEventLoopingStart:
//            循环播放开始
            break;
        default:
            break;
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
