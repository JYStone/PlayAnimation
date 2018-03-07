//
//  YouKuPlayButton.h
//  TimeLine
//
//  Created by jy on 2018/3/6.
//  Copyright © 2018年 M. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YouKuPlayButtonState) {
    YouKuPlayButtonStatePlay,
    YouKuPlayButtonStatePause
};
@interface YouKuPlayButton : UIButton
/** 通过setter方法控制按钮动画 */
@property (nonatomic, assign) YouKuPlayButtonState buttonState;

/** 创建方法 */
- (instancetype)initWithFrame:(CGRect)frame buttonstate:(YouKuPlayButtonState)state;
@end
