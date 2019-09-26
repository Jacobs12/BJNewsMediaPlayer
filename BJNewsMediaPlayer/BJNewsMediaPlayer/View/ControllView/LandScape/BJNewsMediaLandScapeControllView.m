//
//  BJNewsMediaLandScapeControllView.m
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/10.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import "BJNewsMediaLandScapeControllView.h"

@interface BJNewsMediaLandScapeControllView ()

@property (nonatomic,strong) IBOutlet UIView * bottomView;
@property (nonatomic,strong) IBOutlet UIView * bgView;

@end

@implementation BJNewsMediaLandScapeControllView

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    if([BJNewsMediaUtils isHaveSafeArea]){
//        self.backButtonLeading.constant = [BJNewsMediaUtils statusBarHeight] - 20;
//        self.bottomViewLeading.constant = [BJNewsMediaUtils statusBarHeight] - 20;
//        self.bottomViewTrailing.constant = [BJNewsMediaUtils bottomSafeAreaHeight];
//    }else{
//
//    }
//}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

/**
 因iOS10 旋转后不能自动layout，所以手动敲代码

 @param frame frame description
 */
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGPoint center = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0);
    float timeWidth = 70.0 * BJNEWS_MEDIA_SCALE;
    float bottomArea = 0;
    if([BJNewsMediaUtils isHaveSafeArea] == YES){
        bottomArea = [BJNewsMediaUtils bottomSafeAreaHeight];
    }
    self.bgView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.bottomView.frame = CGRectMake([BJNewsMediaUtils statusBarHeight] - 20, frame.size.height - 44, frame.size.width, 44);
//    顶部
    self.backButton.frame = CGRectMake([BJNewsMediaUtils statusBarHeight] - 20, 20, 44, 44);
    self.titleLabel.frame = CGRectMake(self.backButton.frame.origin.x + self.backButton.bounds.size.width, self.backButton.frame.origin.y, 0.6 * frame.size.width, self.backButton.bounds.size.height);
//    中间
    self.playButton.frame = CGRectMake(0, 0, 44, 44);
    self.replayButton.frame = CGRectMake(0, 0, 44, 44);
    self.loadingView.frame = CGRectMake(0, 0, 26.0 * BJNEWS_MEDIA_SCALE, 26.0 * BJNEWS_MEDIA_SCALE);
    NSLog(@"self.loadingView.frame.size.width%f",self.loadingView.frame.size.width);
    self.playButton.center = center;
    self.replayButton.center = center;
    self.loadingView.center = center;
//    底部
    self.muteButton.frame = CGRectMake(0, 0, 44, 44);
    self.timeLabel.frame = CGRectMake(self.muteButton.frame.origin.x + self.muteButton.bounds.size.width, 0, timeWidth, 44);
    self.screenButton.frame = CGRectMake(frame.size.width - 44 - bottomArea,0 , 44, 44);
    self.totalLabel.frame = CGRectMake(self.screenButton.frame.origin.x - timeWidth, 0,timeWidth, 44);
    self.slider.frame = CGRectMake(self.timeLabel.frame.origin.x + self.timeLabel.bounds.size.width - 18, 0, self.totalLabel.frame.origin.x - (self.timeLabel.frame.origin.x + self.timeLabel.bounds.size.width) + 18 * 2, 44);
}

/**
 全屏按钮点击
 
 @param sender 全屏按钮
 */
- (IBAction)screenButtonClick:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(controllView:screenButtonClick:)]){
        [self.delegate controllView:self screenButtonClick:NO];
    }
}

@end
