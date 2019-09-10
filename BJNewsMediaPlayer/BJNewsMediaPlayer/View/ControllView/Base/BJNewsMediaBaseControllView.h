//
//  BJNewsMediaBaseControllView.h
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/10.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJNewsMediaBaseControllView : UIView

@property (nonatomic,strong) IBOutlet UIButton * playButton;
@property (nonatomic,strong) IBOutlet UIButton * muteButton;
@property (nonatomic,strong) IBOutlet UILabel * timeLabel;
@property (nonatomic,strong) IBOutlet UILabel * totalLabel;
@property (nonatomic,strong) IBOutlet UIButton * screenButton;

- (void)setPlayState:(BOOL)isPlaying;

- (void)updateProgress:(float)progress duration:(NSTimeInterval)duration totalDuration:(NSTimeInterval)totalDuration;

@end

NS_ASSUME_NONNULL_END
