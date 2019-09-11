//
//  BJNewsMediaBaseControllView.m
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/10.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import "BJNewsMediaBaseControllView.h"
#import "AILoadingView.h"

@interface BJNewsMediaBaseControllView ()

@property (nonatomic,copy) void (^autoHideBlock) (void);

@property (nonatomic,assign) BOOL isControllViewHidden;

@property (nonatomic,strong) AILoadingView * activity;

@end

@implementation BJNewsMediaBaseControllView

#pragma mark - View

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setReplayMode:NO];
    [self autoHideControllView];
    [self setPlayState:MCPlayStateNone];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.loadingView addSubview:self.activity];
    self.activity.frame = self.loadingView.bounds;
}

- (AILoadingView *)activity{
    if(_activity == nil){
        _activity = [[AILoadingView alloc]initWithFrame:CGRectZero];
        _activity.strokeColor = [UIColor whiteColor];
        _activity.duration = 1.5;
    }
    return _activity;
}

#pragma mark - 播放状态控制

- (void)setPlayState:(MCPlayState)state{
    self.state = state;
    if(state == MCPlayStateNone){
        [self startLoading];
        self.replayButton.hidden = YES;
    }else if(state == MCPlayStatePlaying){
        self.playButton.selected = YES;
        self.replayButton.hidden = YES;
        [self endLoading];
    }else if(state == MCPlayStatePaused){
        self.playButton.selected = NO;
        self.replayButton.hidden = YES;
    }else if (state == MCPlayStateLoadingStart){
        self.playButton.hidden = YES;
        self.replayButton.hidden = YES;
        [self startLoading];
    }else if(state == MCPlayStateLoadingEnded){
        self.replayButton.hidden = YES;
        [self endLoading];
    }else if (state == MCPlayStateEnded){
        [self setReplayMode:YES];
    }else if (state == MCPlayStateError){
        
    }
}

- (void)setReplayMode:(BOOL)isReplay{
    self.playButton.hidden = isReplay;
    self.replayButton.hidden = !isReplay;
}

- (void)updateProgress:(float)progress duration:(NSTimeInterval)duration totalDuration:(NSTimeInterval)totalDuration{
    NSString * time = [self convertTimeSecond:duration / 1000];
    NSString * totalTime = [self convertTimeSecond:totalDuration / 1000];
    self.timeLabel.text = time;
    self.totalLabel.text = totalTime;
}

#pragma mark - setter

/**
 设置是否静音
 
 @param isMute 是否静音
 */
- (void)setMuteMode:(BOOL)isMute{
    self.muteButton.selected = isMute;
}

#pragma mark - View显示控制

/**
 开始加载动画
 */
- (void)startLoading{
    if(self.loadingView.subviews.count >0){
        for (UIView * subView in self.loadingView.subviews) {
            [subView removeFromSuperview];
        }
    }
    self.replayButton.hidden = YES;
    self.playButton.hidden = YES;
    self.loadingView.hidden = NO;
    self.activity.frame = self.loadingView.bounds;
    [self.loadingView addSubview:self.activity];
    [self.activity starAnimation];
}

/**
 结束加载动画
 */
- (void)endLoading{
    [self.activity stopAnimation];
    [self.activity removeFromSuperview];
    _activity = nil;
    self.loadingView.hidden = YES;
}

/**
 将时间转换为字符串
 */
-(NSString *)convertTimeSecond:(NSInteger)timeSecond {
    NSString *theLastTime = nil;
    long second = timeSecond;
    if (timeSecond < 60) {
        theLastTime = [NSString stringWithFormat:@"00:%02zd", second];
    } else if(timeSecond >= 60 && timeSecond < 3600){
        theLastTime = [NSString stringWithFormat:@"%02zd:%02zd", second/60, second%60];
    }
    else if(timeSecond >= 3600){
        theLastTime = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", second/3600, second%3600/60, second%60];
    }
    return theLastTime;
}

#pragma mark - 手势控制

/**
 轻触屏幕，显示控制面板
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self showControllViewAnimated:YES];
    [self autoHideControllView];
}

#pragma mark - 显示、隐藏控制面板

/**
 自动隐藏控制面板
 */
- (void)autoHideControllView{
    [self cancelHideControllView];
    __weak typeof(self) weak_self = self;
    self.autoHideBlock = dispatch_block_create(0, ^{
        [weak_self hideControllViewAnimated:YES];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),self.autoHideBlock);
}

/**
 取消延时隐藏controlView的方法
 */
- (void)cancelHideControllView{
    if (self.autoHideBlock) {
        dispatch_block_cancel(self.autoHideBlock);
    }
}

#pragma mark - 隐藏控制面板相关处理方法

/**
 手动隐藏控制面板

 @param isAnimate 是否动画
 */
- (void)hideControllViewAnimated:(BOOL)isAnimate{
    if(self.state == MCPlayStatePaused){
        return;
    }
    if(isAnimate == NO){
        [self setControllViewHidden:YES];
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self setControllViewAlpha:0.0];
    } completion:^(BOOL finished) {
        [self setControllViewHidden:YES];
        [self setControllViewAlpha:1.0];
    }];
}

/**
 手动显示控制面板

 @param isAnimate 是否动画
 */
- (void)showControllViewAnimated:(BOOL)isAnimate{
    if(isAnimate == NO){
        [self setControllViewHidden:NO];
        [self setControllViewAlpha:1.0];
        return;
    }
    [self setControllViewHidden:NO];
    [UIView animateWithDuration:0.2 animations:^{
        [self setControllViewAlpha:1.0];
    } completion:^(BOOL finished) {
        [self setControllViewAlpha:1.0];
    }];
}

/**
 设置控制面板是否隐藏

 @param isHidden 是否隐藏
 */
- (void)setControllViewHidden:(BOOL)isHidden{
    self.isControllViewHidden = isHidden;
    if(self.state == MCPlayStateLoadingStart || self.state == MCPlayStateEnded){
        self.playButton.hidden = YES;
    }else{
        self.playButton.hidden = isHidden;
    }
    self.muteButton.hidden = isHidden;
    self.timeLabel.hidden = isHidden;
    self.totalLabel.hidden = isHidden;
    self.screenButton.hidden = isHidden;
}

/**
 设置控制面板透明度

 @param alpha 设置控制面板透明度
 */
- (void)setControllViewAlpha:(float)alpha{
    self.playButton.alpha = alpha;
    self.muteButton.alpha = alpha;
    self.timeLabel.alpha = alpha;
    self.totalLabel.alpha = alpha;
    self.screenButton.alpha = alpha;
}

#pragma mark - 按钮点击事件

/**
 播放、暂停按钮点击
 
 @param sender sender description
 */
- (IBAction)playButtonClick:(id)sender{
    [self autoHideControllView];
    BOOL isPlaying = !self.playButton.isSelected;
    if(self.delegate && [self.delegate respondsToSelector:@selector(controllView:playButtonClick:)]){
        [self.delegate controllView:self playButtonClick:isPlaying];
    }
}

/**
 重新播放按钮点击
 
 @param sender sender description
 */
- (IBAction)replayButtonClick:(id)sender{
    [self autoHideControllView];
    BOOL isError = NO;
    if(self.state == MCPlayStateError){
        isError = YES;
    }
    self.replayButton.hidden = YES;
    if(self.delegate && [self.delegate respondsToSelector:@selector(controllView:replayButtonClick:)]){
        [self.delegate controllView:self replayButtonClick:YES];
    }
}

/**
 静音按钮点击
 
 @param sender 静音按钮
 */
- (IBAction)muteButtonClick:(id)sender{
    [self autoHideControllView];
    BOOL isMute = !self.muteButton.isSelected;
    self.muteButton.selected = isMute;
    if(self.delegate && [self.delegate respondsToSelector:@selector(controllView:muteButtonClick:)]){
        [self.delegate controllView:self muteButtonClick:isMute];
    }
}

/**
 全屏按钮点击

 @param sender 全屏按钮
 */
- (IBAction)screenButtonClick:(id)sender{
    
}

@end
