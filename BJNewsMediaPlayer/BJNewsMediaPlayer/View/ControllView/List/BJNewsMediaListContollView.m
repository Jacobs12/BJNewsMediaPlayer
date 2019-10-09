//
//  BJNewsMediaListContollView.m
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/10.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import "BJNewsMediaListContollView.h"

@interface BJNewsMediaListContollView (){
    NSArray * _imagesArray;
}

@end

@implementation BJNewsMediaListContollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    self.timeBgView.layer.cornerRadius = 2.0;
    self.timeBgView.layer.masksToBounds = YES;
    
    self.liveBgView.layer.cornerRadius = 3.0;
    self.liveBgView.layer.masksToBounds = YES;
    
//    self.liveBgView.backgroundColor = [BJNewsMediaUtils colorWithHex:0xD12D2B alpha:0.9];

}

- (void)hideControllViewAnimated:(BOOL)isAnimate{
    
}

/**
 设置播放源属性 视频/直播/回放
 
 @param sourceType 播放源属性
 */
- (void)setVideoSourceType:(MCSourceType)sourceType{
    [super setSourceType:sourceType];
    if(sourceType == MCSourceTypeVideo){
        if(self.liveImageView.isAnimating){
            [self.liveImageView stopAnimating];
        }
        self.liveBgView.hidden = YES;
        self.timeBgView.hidden = NO;
    }else if (sourceType == MCSourceTypeLive){
        self.liveImageView.image = [UIImage imageNamed:@"live_00005.png"];
        self.liveBgView.backgroundColor = [BJNewsMediaUtils colorWithHex:0xD12D2B alpha:1.0];
        self.liveLabel.text = @"直播中";
        self.timeBgView.hidden = YES;
        dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_HIGH), ^{
            if(self->_imagesArray == nil){
                NSMutableArray * imageArray = [[NSMutableArray alloc]init];
                for(NSInteger i=0;i<16;i++){
                    NSString * name = [NSString stringWithFormat:@"live_000%02ld.png",(long)i];
                    [imageArray addObject:[UIImage imageNamed:name]];
                }
                self->_imagesArray = [NSArray arrayWithArray:imageArray];
            }else{
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.liveImageView.animationImages = self->_imagesArray;
                self.liveImageView.animationDuration = 0.75;
                self.liveImageView.animationRepeatCount = 0;
                [self.liveImageView startAnimating];
            });
        });
    }else if (sourceType == MCSourceTypePlayback){
        if(self.liveImageView.isAnimating){
            [self.liveImageView stopAnimating];
        }
        self.liveImageView.image = [UIImage imageNamed:@"bjnews_media_playback"];
        self.liveLabel.text = @"回放";
        self.liveBgView.backgroundColor = [BJNewsMediaUtils colorWithHex:0x5D73FF alpha:0.9];
        self.timeBgView.hidden = NO;
    }
}

/**
 刷新播放进度
 
 @param progress 播放进度
 @param duration 当前播放时间
 @param totalDuration 总播放时间
 */
- (void)updateProgress:(float)progress duration:(NSTimeInterval)duration totalDuration:(NSTimeInterval)totalDuration{
    float surplus = totalDuration - duration;
    if(surplus < 0){
        surplus = 0;
    }
    NSString * text = [self convertTimeSecond:surplus / 1000];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",text];
}

@end
