//
//  BJNewsMediaPortraitControllView.m
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/10.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import "BJNewsMediaPortraitControllView.h"

@interface BJNewsMediaPortraitControllView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backButtonTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottom;

@end

@implementation BJNewsMediaPortraitControllView

- (void)layoutSubviews{
    [super layoutSubviews];
    if([UIDevice currentDevice].systemVersion.floatValue < 11.0){
        self.backButtonTop.constant = 20;
        self.bottomViewBottom.constant = 0;
    }else if([BJNewsMediaUtils isHaveSafeArea] == NO){
        self.backButtonTop.constant = 20;
        self.bottomViewBottom.constant = 0;
    }else{
        
    }
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
