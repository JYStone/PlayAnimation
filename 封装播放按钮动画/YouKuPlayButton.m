//
//  YouKuPlayButton.m
//  TimeLine
//
//  Created by jy on 2018/3/6.
//  Copyright © 2018年 M. All rights reserved.
//

#import "YouKuPlayButton.h"

@interface YouKuPlayButton ()<CAAnimationDelegate>
/** 其他动画时长 */
@property (nonatomic, assign) CGFloat animationDuration;

/** 位移动画时长 */
@property (nonatomic, assign) CGFloat positionDuration;

/** 线条颜色 */
/** 蓝色 */
@property (nonatomic, strong) UIColor *blueColor;
/** 浅蓝色 */
@property (nonatomic, strong) UIColor *lightBlueColor;
/** 红色 */
@property (nonatomic, strong) UIColor *redColor;

/** 是否正在执行动画 */
@property (nonatomic, assign) BOOL isAnimating;
/** 单位宽度 */
@property (nonatomic, assign) CGFloat a;

/** 左侧竖线条 */
@property (nonatomic, strong) CAShapeLayer *leftLineLayer;
/** 右侧竖线条 */
@property (nonatomic, strong) CAShapeLayer *rightLineLayer;
/** 左侧半圆 */
@property (nonatomic, strong) CAShapeLayer *leftCircleLayer;
/** 右侧半圆 */
@property (nonatomic, strong) CAShapeLayer *rightCircleLayer;
/** 红色三角形 */
@property (nonatomic, strong) CALayer *triangleContainer;
@end
@implementation YouKuPlayButton

- (instancetype)initWithFrame:(CGRect)frame buttonstate:(YouKuPlayButtonState)state {
    self = [super initWithFrame:frame];
    if (self) {
        self.a = frame.size.width;
        self.animationDuration = 0.35f;
        self.blueColor = [UIColor colorWithRed:62/255.0 green:157/255.0 blue:254/255.0 alpha:1];
        self.lightBlueColor = [UIColor colorWithRed:87/255.0 green:188/255.0 blue:253/255.0 alpha:1];
        self.redColor = [UIColor colorWithRed:228/255.0 green:35/255.0 blue:6/255.0 alpha:0.8];
        
        /** UI布局 */
        [self createUI];
        if (state == YouKuPlayButtonStatePlay) {
            self.buttonState = state;
        }
    }
    return self;
}

- (void)createUI {
    [self addLeftCircleLayer];
    [self addRightCircleLayer];
    [self addLeftLineLayer];
    [self addRightLineLayer];
    [self addCenterTriangleLayer];
}

/** 添加左侧竖线 */
- (void)addLeftLineLayer {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.2*self.a, 0.9*self.a)];
    [path addLineToPoint:CGPointMake(0.2*self.a, 0.1*self.a)];
    
    self.leftLineLayer = [CAShapeLayer layer];
    self.leftLineLayer.path = path.CGPath;
    self.leftLineLayer.lineWidth = [self lineWidth];
    self.leftLineLayer.fillColor = [UIColor clearColor].CGColor;
    self.leftLineLayer.strokeColor = self.blueColor.CGColor;
    self.leftLineLayer.lineCap = kCALineCapRound;
    self.leftLineLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:self.leftLineLayer];
}

/** 添加右侧竖线 */
- (void)addRightLineLayer {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.8*self.a, 0.1*self.a)];
    [path addLineToPoint:CGPointMake(0.8*self.a, 0.9*self.a)];
    
    self.rightLineLayer = [CAShapeLayer layer];
    self.rightLineLayer.path = path.CGPath;
    self.rightLineLayer.lineWidth = [self lineWidth];
    self.rightLineLayer.fillColor = [UIColor clearColor].CGColor;
    self.rightLineLayer.strokeColor = self.blueColor.CGColor;
    self.rightLineLayer.lineCap = kCALineCapRound;
    self.rightLineLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:self.rightLineLayer];
}

/** 左侧半圆 */
- (void)addLeftCircleLayer {
    CGFloat startAngle = acos(4.0/5) + M_PI_2;
    CGFloat endAngle = startAngle - M_PI;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.a*0.2, self.a*0.9)];
    [path addArcWithCenter:CGPointMake(self.a*0.5, self.a*0.5) radius:self.a*0.5 startAngle:startAngle endAngle:endAngle clockwise:NO];
    
    self.leftCircleLayer = [CAShapeLayer layer];
    self.leftCircleLayer.path = path.CGPath;
    self.leftCircleLayer.lineWidth = [self lineWidth];
    self.leftCircleLayer.fillColor = [UIColor clearColor].CGColor;
    self.leftCircleLayer.strokeColor = self.lightBlueColor.CGColor;
    self.leftCircleLayer.lineCap = kCALineCapRound;
    self.leftCircleLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:self.leftCircleLayer];
}

/** 右侧半圆 */
- (void)addRightCircleLayer {
    CGFloat startAngle = -asin(4.0/5);
    CGFloat endAngle = startAngle - M_PI;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.a*0.8, self.a*0.1)];
    [path addArcWithCenter:CGPointMake(self.a*0.5, self.a*0.5) radius:self.a*0.5 startAngle:startAngle endAngle:endAngle clockwise:NO];
    
    self.rightCircleLayer = [CAShapeLayer layer];
    self.rightCircleLayer.path = path.CGPath;
    self.rightCircleLayer.lineWidth = [self lineWidth];
    self.rightCircleLayer.fillColor = [UIColor clearColor].CGColor;
    self.rightCircleLayer.strokeColor = self.lightBlueColor.CGColor;
    self.rightCircleLayer.lineCap = kCALineCapRound;
    self.rightCircleLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:self.rightCircleLayer];
}

/** 红色三角形 */
- (void)addCenterTriangleLayer {
    self.triangleContainer = [CALayer layer];
    self.triangleContainer.bounds = CGRectMake(0, 0, 0.4*self.a, 0.35*self.a);
    self.triangleContainer.position = CGPointMake(self.a*0.5, self.a*0.55);
    self.triangleContainer.opacity = 0;
    [self.layer addSublayer:self.triangleContainer];
    
    CGFloat b = self.triangleContainer.bounds.size.width;
    CGFloat c = self.triangleContainer.bounds.size.height;
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(0,0)];
    [path1 addLineToPoint:CGPointMake(b/2,c)];
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(b,0)];
    [path2 addLineToPoint:CGPointMake(b/2,c)];
    
    CAShapeLayer *layer1 = [CAShapeLayer layer];
    layer1.path = path1.CGPath;
    layer1.fillColor = [UIColor clearColor].CGColor;
    layer1.strokeColor = self.redColor.CGColor;
    layer1.lineWidth = [self lineWidth];
    layer1.lineCap = kCALineCapRound;
    layer1.lineJoin = kCALineJoinRound;
    layer1.strokeEnd = 1;
    [self.triangleContainer addSublayer:layer1];
    
    CAShapeLayer *layer2 = [CAShapeLayer layer];
    layer2.path = path2.CGPath;
    layer2.fillColor = [UIColor clearColor].CGColor;
    layer2.strokeColor = self.redColor.CGColor;
    layer2.lineWidth = [self lineWidth];
    layer2.lineCap = kCALineCapRound;
    layer2.lineJoin = kCALineJoinRound;
    layer2.strokeEnd = 1;
    [self.triangleContainer addSublayer:layer2];
}

#pragma mark -- 动画方法
/** 执行动画方法 */
- (CABasicAnimation *)strokeEndAnimationFrom:(CGFloat)fromValue to:(CGFloat)toValue onLayer:(CALayer *)layer name:(NSString *)animationName duration:(CGFloat)duration delegate:(id)delegate {
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = duration;
    strokeEndAnimation.fromValue = @(fromValue);
    strokeEndAnimation.toValue = @(toValue);
    strokeEndAnimation.fillMode = kCAFillModeForwards;
    strokeEndAnimation.removedOnCompletion = NO;
    [strokeEndAnimation setValue:animationName forKey:@"animationName"];
    strokeEndAnimation.delegate = delegate;
    [layer addAnimation:strokeEndAnimation forKey:nil];
    return strokeEndAnimation;
}

/** 执行旋转动画 */
- (void)actionRotateAnimationClockwise:(BOOL)clockwise {
    /** 逆时针旋转 */
    CGFloat startAngle = 0.0;
    CGFloat endAngle = -M_PI_2;
    CGFloat duration = 0.75 * self.animationDuration;
    /** 顺时针旋转 */
    if (clockwise) {
        startAngle = -M_PI_2;
        endAngle = 0.0;
        duration = self.animationDuration;
    }
    
    CABasicAnimation *roateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    roateAnimation.duration = duration;/** 持续时间 */
    roateAnimation.fromValue = @(startAngle);
    roateAnimation.toValue = @(endAngle);
    roateAnimation.fillMode = kCAFillModeForwards;
    roateAnimation.removedOnCompletion = NO;
    [roateAnimation setValue:@"roateAnimation" forKey:@"animationName"];
    [self.layer addAnimation:roateAnimation forKey:nil];
}

/** 三角旋转动画 */
- (void)actionTriangleAlphaAnimationFrom:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration{
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.duration = duration; // 持续时间
    alphaAnimation.fromValue = @(from);
    alphaAnimation.toValue = @(to);
    alphaAnimation.fillMode = kCAFillModeForwards;
    alphaAnimation.removedOnCompletion = NO;
    [alphaAnimation setValue:@"alphaAnimation" forKey:@"animationName"];
    [self.triangleContainer addAnimation:alphaAnimation forKey:nil];
}

/** 暂停->播放的动画 */
- (void)showPlayAnimation {
    /** 收直线、放圆弧。直线速度是圆弧的2倍 */
    //收直线、放圆圈；直线的速度是圆圈的2倍
    [self strokeEndAnimationFrom:1 to:0 onLayer:self.leftLineLayer name:nil duration:self.animationDuration/2 delegate:nil];
    [self strokeEndAnimationFrom:1 to:0 onLayer:self.rightLineLayer name:nil duration:self.animationDuration/2 delegate:nil];
    [self strokeEndAnimationFrom:0 to:1 onLayer:self.leftCircleLayer name:nil duration:self.animationDuration delegate:nil];
    [self strokeEndAnimationFrom:0 to:1 onLayer:self.rightCircleLayer name:nil duration:self.animationDuration delegate:nil];
    //开始旋转动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  self.animationDuration/4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self actionRotateAnimationClockwise:false];
    });
    //显示播放三角动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  self.animationDuration/2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self actionTriangleAlphaAnimationFrom:0 to:1 duration:self.animationDuration/2];
    });
}

/** 播放->暂停的动画 */
- (void)showPauseAnimation {
    //先收圆圈，
    [self strokeEndAnimationFrom:1 to:0 onLayer:self.leftCircleLayer name:nil duration:self.animationDuration delegate:nil];
    [self strokeEndAnimationFrom:1 to:0 onLayer:self.rightCircleLayer name:nil duration:self.animationDuration delegate:nil];
    //隐藏播放三角动画
    [self actionTriangleAlphaAnimationFrom:1 to:0 duration:self.animationDuration/2];
    //旋转动画
    [self actionRotateAnimationClockwise:true];
    //收到一半再放直线
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  self.animationDuration/2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self strokeEndAnimationFrom:0 to:1 onLayer:self.leftLineLayer name:nil duration:self.animationDuration/2 delegate:nil];
        [self strokeEndAnimationFrom:0 to:1 onLayer:self.rightLineLayer name:nil duration:self.animationDuration/2 delegate:nil];
    });
}

/** setter 方法控制 */
- (void)setButtonState:(YouKuPlayButtonState)buttonState {
    /** 如果正在执行动画，则停止执行 */
    if (_isAnimating == YES) {
        return;
    }
    _buttonState = buttonState;
    _isAnimating = YES;
    if (buttonState == YouKuPlayButtonStatePlay) {
        [self showPlayAnimation];
    } else if (buttonState == YouKuPlayButtonStatePause) {
        [self showPauseAnimation];
    }
    /** 更新动画执行状态 */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isAnimating = NO;
    });
}
/** 线条宽度 */
- (CGFloat)lineWidth {
    return self.bounds.size.width*0.2;
}
@end
















