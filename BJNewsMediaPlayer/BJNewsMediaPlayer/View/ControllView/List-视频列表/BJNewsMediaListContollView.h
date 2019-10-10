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

/**
 剩余时间背景
 */
@property (nonatomic,strong) IBOutlet UIView * timeBgView;

/**
 直播动画view
 */
@property (nonatomic,strong) IBOutlet UIImageView * liveImageView;

/**
 直播背景颜色
 */
@property (nonatomic,strong) IBOutlet UIView * liveBgView;

/**
 直播标题
 */
@property (nonatomic,strong) IBOutlet UILabel * liveLabel;

@end

NS_ASSUME_NONNULL_END
