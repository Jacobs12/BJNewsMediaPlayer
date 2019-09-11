//
//  BJNewsMediaBaseControllView.m
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/10.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import "BJNewsMediaBaseControllView.h"

@implementation BJNewsMediaBaseControllView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setPlayState:(MCPlayState)state{
    if(state == MCPlayStatePlaying){
        self.playButton.selected = YES;
    }else if(state == MCPlayStatePaused){
        self.playButton.selected = NO;
    }else if (state == MCPlayStateLoading){

    }else if (state == MCPlayStateEnded){
        
    }
}

- (void)updateProgress:(float)progress duration:(NSTimeInterval)duration totalDuration:(NSTimeInterval)totalDuration{
    NSString * time = [self convertTimeSecond:duration / 1000];
    NSString * totalTime = [self convertTimeSecond:totalDuration / 1000];
    self.timeLabel.text = time;
    self.totalLabel.text = totalTime;
}

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

@end
