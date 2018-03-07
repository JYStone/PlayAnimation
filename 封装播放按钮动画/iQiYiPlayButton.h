//
//  iQiYiPlayButton.h
//  TimeLine
//
//  Created by jy on 2018/3/2.
//  Copyright © 2018年 M. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, iQiYiPlayButtonState) {
    iQiYiPlayButtonStatePlay,
    iQiYiPlayButtonStatePause
};

@interface iQiYiPlayButton : UIButton

/** 通过setter方式控制按钮动画
    设置iQiYiPlayButtonStatePlay 显示播放按钮
    设置iQiYiPlayButtonStatePause 显示暂停按钮
 */
@property (nonatomic, assign) iQiYiPlayButtonState buttonState;

/** 创建方法 */
- (instancetype)initWithFrame:(CGRect)frame state:(iQiYiPlayButtonState)state;
@end
