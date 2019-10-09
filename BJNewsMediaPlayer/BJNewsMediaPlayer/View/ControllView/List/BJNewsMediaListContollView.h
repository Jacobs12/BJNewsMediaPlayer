//
//  BJNewsMediaListContollView.h
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/10.
//  Copyright © 2019 新京报社. All rights reserved.
//


#import "BJNewsMediaBaseControllView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BJNewsMediaListContollView : BJNewsMediaBaseControllView

@property (nonatomic,strong) IBOutlet UIView * timeBgView;

@property (nonatomic,strong) IBOutlet UIImageView * liveImageView;
@property (nonatomic,strong) IBOutlet UIView * liveBgView;
@property (nonatomic,strong) IBOutlet UILabel * liveLabel;

@end

NS_ASSUME_NONNULL_END
