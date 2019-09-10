//
//  ViewController.m
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/10.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import "ViewController.h"
#import "BJNewsMediaPlayer.h"

@interface ViewController () <BJNewsMediaPlayerDelegate>

@property (nonatomic,strong) IBOutlet UIView * playerView;
@property (nonatomic,strong) BJNewsMediaPlayer * player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.player = [BJNewsMediaPlayer defaultPlayer];
    self.player.delegate = self;
    self.player.playerView = self.playerView;
    [self.player playWithUrl:@"https://test-bjnews.oss-cn-beijing.aliyuncs.com/video/2019/09/04/4833278034796609767.mp4"];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.player redraw];
}

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
 开始加载回调，loading开始转圈
 
 @param mediaPlayer 播放器
 */
- (void)mediaPlayerWillStartLoading:(BJNewsMediaPlayer *)mediaPlayer{
    
}

/**
 结束加载回调，loading结束转圈
 
 @param mediaPlayer 播放器
 */
- (void)mediaPlayerDidStopLoading:(BJNewsMediaPlayer *)mediaPlayer{
    
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
    
}

/**
 缓冲进度回调，更新进度条
 
 @param mediaPlayer 播放器
 @param progress 缓冲进度
 */
- (void)mediaPlayer:(BJNewsMediaPlayer *)mediaPlayer updateBufferProgress:(float)progress bufferDuration:(NSTimeInterval)duration{
    
}

@end
