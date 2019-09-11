//
//  ViewController.m
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/10.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import "ViewController.h"
#import "BJNewsMediaPlayerView.h"

@interface ViewController ()

@property (nonatomic,strong) IBOutlet UIView * playerView;
@property (nonatomic,strong) BJNewsMediaPlayerView * player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.player = [BJNewsMediaPlayerView defaultView];
    self.player.container = self;
    [self.player moveToView:self.playerView type:MEPControllViewTypePreview];
    [self.player playWithUrl:@"https://test-bjnews.oss-cn-beijing.aliyuncs.com/video/2019/09/04/4833278034796609767.mp4"];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.player moveToView:self.view type:MEPControllViewTypePreview];
//    });
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if(self.player.superview == self.playerView){
        [self.player redraw];
    }
}

////必须返回YES
- (BOOL)shouldAutorotate{
    return NO;
}
////旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

////状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
}
////状态栏显示／隐藏
-(BOOL)prefersStatusBarHidden{
//    if(_isHideStatusBar == NO){
//        return NO;
//    }else{
//        return YES;
//    }
    return NO;
}

- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
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
