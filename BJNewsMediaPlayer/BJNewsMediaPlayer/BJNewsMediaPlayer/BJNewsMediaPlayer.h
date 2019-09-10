//
//  BJNewsMediaPlayer.h
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/10.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunPlayer/AliListPlayer.h>

NS_ASSUME_NONNULL_BEGIN

#define IS_MEPLOG_PRINT 1
#define MEPLog(info) if(IS_MEPLOG_PRINT){NSLog(@"Path:%s==line:%d==Info:%@",__PRETTY_FUNCTION__,__LINE__,info);}

@protocol BJNewsMediaPlayerDelegate;

/**
 播放功能的基本流程如下：
 创建播放器->设置事件监听->创建播放源->准备播放器->准备成功后开始播放->播放控制->释放播放器。
 */
@interface BJNewsMediaPlayer : NSObject

+ (BJNewsMediaPlayer *)defaultPlayer;

@property (nonatomic,strong) AliPlayer * player;

@property(nullable,nonatomic,weak) id<BJNewsMediaPlayerDelegate> delegate;

@property (nonatomic,strong) UIView * playerView;

@property (nullable,nonatomic,copy) void (^seekTimeBlock) (NSTimeInterval seekTime);

#pragma mark - 播放器属性

/**
 即将跳转的时间
 */
@property (nonatomic,assign) NSTimeInterval seekTime;

#pragma mark - 播放器控制

/**
 播放网络资源

 @param url url description
 */
- (void)playWithUrl:(NSString *)url;

/**
 开始播放
 */
- (void)play;

/**
 暂停播放
 */
- (void)pause;

/**
 停止播放
 */
- (void)stop;

/**
 销毁播放器
 */
- (void)destroy;

/**
 重置播放器
 */
- (void)reset;

/**
 重新加载。比如网络超时时，可以重新加载。
 */
- (void)reload;

/**
 跳转到指定时间

 @param time 跳转时间
 @param handler ja完成回调
 */
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^) (NSTimeInterval seekTime))handler;

@end

#pragma mark - =====================delegate

@protocol BJNewsMediaPlayerDelegate <NSObject>

/**
 播放器已经做好播放准备回调

 @param mediaPlayer 播放器
 */
- (void)mediaPlayerDidPrepared:(BJNewsMediaPlayer *)mediaPlayer;

/**
 开始显示第一帧回调

 @param mediaPlayer mediaPlayer description
 */
- (void)mediaPlayerFirstRenderedStart:(BJNewsMediaPlayer *)mediaPlayer;

/**
 播放完成回调

 @param mediaPlayer 播放器
 */
- (void)mediaPlayerDidEnded:(BJNewsMediaPlayer *)mediaPlayer;

/**
 开始加载回调，loading开始转圈

 @param mediaPlayer 播放器
 */
- (void)mediaPlayerWillStartLoading:(BJNewsMediaPlayer *)mediaPlayer;

/**
 结束加载回调，loading结束转圈

 @param mediaPlayer 播放器
 */
- (void)mediaPlayerDidStopLoading:(BJNewsMediaPlayer *)mediaPlayer;

/**
 跳转到指定播放时间成功回调

 @param mediaPlayer 播放器
 @param seekTime 跳转到的时间
 */
- (void)mediaPlayer:(BJNewsMediaPlayer *)mediaPlayer seekEnd:(NSTimeInterval)seekTime;

/**
 播放进度回调，更新进度条

 @param mediaPlayer 播放器
 @param progress 播放进度
 @param duration 当前时间
 @param totalDuration 总时间
 */
- (void)mediaPlayer:(BJNewsMediaPlayer *)mediaPlayer updateProgress:(float)progress duraion:(NSTimeInterval)duration totalDuration:(NSTimeInterval)totalDuration;

/**
 缓冲进度回调，更新进度条
 
 @param mediaPlayer 播放器
 @param progress 缓冲进度
 */
- (void)mediaPlayer:(BJNewsMediaPlayer *)mediaPlayer updateBufferProgress:(float)progress bufferDuration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
