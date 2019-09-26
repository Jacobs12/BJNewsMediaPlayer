//
//  ViewController.m
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/10.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import "ViewController.h"
#import "BJNewsMediaPlayerView.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL _isStatusBarHidden;
}

@property (nonatomic,strong) IBOutlet UIView * playerView;
@property (nonatomic,strong) BJNewsMediaPlayerView * player;
@property (nonatomic,strong) IBOutlet UITableView * tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    self.player = [BJNewsMediaPlayerView defaultView];
    [self.player moveToView:self.playerView type:MEPControllViewTypePreview];
    [self.player playWithUrl:@"https://test-bjnews.oss-cn-beijing.aliyuncs.com/video/2019/09/04/4833278034796609767.mp4"];
//    [self.player playWithUrl:@"http://tb-video.bdstatic.com/tieba-smallvideo-transcode-cae/3721866_1fa5e31aad50cf3eb3b9dd3288cebdae_0_cae.mp4"];
    __weak typeof(self) weak_self = self;
//    self.player.screenWillRotateBlock = ^id _Nonnull(BOOL isPortrait) {
//        self->_isStatusBarHidden = isPortrait;
//        NSLog(@"sadasdasdasd");
//        return weak_self;
//    };
    self.playerView.frame = CGRectMake(0, 0, 375, 211);
    [self.player redraw];
    self.tableView.tableHeaderView = self.playerView;
    
    
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0);
}

//- (void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    if(self.player.superview == self.playerView){
//        [self.player redraw];
//    }
//}

- (BOOL)shouldAutorotate{
    return NO;
}
//////旋转方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//////状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
//////状态栏显示／隐藏
-(BOOL)prefersStatusBarHidden{
    return YES;
    if(_isStatusBarHidden == NO){
        return NO;
    }else{
        return YES;
    }
    return YES;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    return cell;
}

@end
