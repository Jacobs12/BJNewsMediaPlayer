//
//  BJNewsMediaPreviewControllView.m
//  BJNewsMediaPlayer
//
//  Created by wolffy on 2019/9/10.
//  Copyright © 2019 新京报社. All rights reserved.
//

#import "BJNewsMediaPreviewControllView.h"

@implementation BJNewsMediaPreviewControllView

#pragma mark - 按钮点击事件

/**
 全屏按钮点击
 
 @param sender 全屏按钮
 */
- (IBAction)screenButtonClick:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(controllView:screenButtonClick:)]){
        [self.delegate controllView:self screenButtonClick:YES];
    }
}

@end
