//
//  iQiYiPlayButton.m
//  TimeLine
//
//  Created by jy on 2018/3/2.
//  Copyright © 2018年 M. All rights reserved.
//

#import "iQiYiPlayButton.h"
/** 其他动画时长 */
static CGFloat animationDuration = 0.8f;
/** 位移动画时长 */
static CGFloat positionDuration = 0.3f;
/** 线条颜色 */
#define LineColor [UIColor colorWithRed:12/255.0 green:190/255.0 blue:6/255.0 alpha:1]
/** 三角动画名称 */
#define TriangleAnimation @"TriangleAnimation"

/** 右侧直线动画名称 */
#define RightLineAnimation @"RightLineAnimation"

@interface iQiYiPlayButton ()<CAAnimationDelegate>
/** 是否正在执行动画 */
@property (nonatomic, assign) BOOL isAnimating;

/** 左侧竖条 */
@property (nonatomic, strong) CAShapeLayer *leftLineLayer;

/** 三角 */
@property (nonatomic, strong) CAShapeLayer *triangleLayer;

/** 右侧竖条 */
@property (nonatomic, strong) CAShapeLayer *rightLineLayer;

/** 画弧layer */
@property (nonatomic, strong) CAShapeLayer *circleLayer;

@end
@implementation iQiYiPlayButton

- (instancetype)initWithFrame:(CGRect)frame state:(iQiYiPlayButtonState)state {
    self = [super initWithFrame:frame];
    if (self) {
        /** UI布局 */
        [self buildUI];
        if (state == iQiYiPlayButtonStatePlay) {
            self.buttonState = state;
        }
    }
    return self;
}

/** UI布局 */
- (void)buildUI {
    self.buttonState = iQiYiPlayButtonStatePause;
    
    [self addTriangleLayer];
    [self addLeftLineLayer];
    [self addRightLineLayer];
    [self addCircleLayer];
}

/** 添加三角层 */
- (void)addTriangleLayer {
    CGFloat a = self.bounds.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.2, a*0.2)];
    [path addLineToPoint:CGPointMake(a*0.2, 0)];
    [path addLineToPoint:CGPointMake(a, a*0.5)];
    [path addLineToPoint:CGPointMake(a*0.2, a)];
    [path addLineToPoint:CGPointMake(a*0.2, a*0.2)];
    
    self.triangleLayer = [CAShapeLayer layer];
    self.triangleLayer.path = path.CGPath;
    self.triangleLayer.fillColor = [UIColor clearColor].CGColor;

    self.triangleLayer.strokeColor = LineColor.CGColor;
    self.triangleLayer.lineWidth = [self lineWidth];
    self.triangleLayer.lineCap = kCALineCapButt;
    self.triangleLayer.lineJoin = kCALineJoinRound;
    self.triangleLayer.strokeEnd = 0;
    [self.layer addSublayer:self.triangleLayer];
}

/** 添加左侧竖线 */
- (void)addLeftLineLayer {
    CGFloat a = self.bounds.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.2, 0)];
    [path addLineToPoint:CGPointMake(a*0.2, a)];
    
    self.leftLineLayer = [CAShapeLayer layer];
    self.leftLineLayer.path = path.CGPath;
    self.leftLineLayer.fillColor = [UIColor clearColor].CGColor;
    self.leftLineLayer.strokeColor = LineColor.CGColor;
    self.leftLineLayer.lineWidth = [self lineWidth];
    self.leftLineLayer.lineCap = kCALineCapRound;
    self.leftLineLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:self.leftLineLayer];
}

/** 添加右侧竖线层 */
- (void)addRightLineLayer {
    CGFloat a = self.bounds.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.8, a)];
    [path addLineToPoint:CGPointMake(a*0.8, 0)];
    
    self.rightLineLayer = [CAShapeLayer layer];
    self.rightLineLayer.path = path.CGPath;
    self.rightLineLayer.fillColor = [UIColor clearColor].CGColor;
    self.rightLineLayer.strokeColor = LineColor.CGColor;
    self.rightLineLayer.lineWidth = [self lineWidth];
    self.rightLineLayer.lineCap = kCALineCapRound;
    self.rightLineLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:self.rightLineLayer];
    
}

/** 添加弧线过渡弧线层 */
- (void)addCircleLayer {
    CGFloat a = self.bounds.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.8, a*0.8)];
    [path addArcWithCenter:CGPointMake(a*0.5, a*0.8) radius:0.3*a startAngle:0 endAngle:M_PI clockwise:YES];
    
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.path = path.CGPath;
    self.circleLayer.fillColor = [UIColor clearColor].CGColor;
    self.circleLayer.strokeColor = LineColor.CGColor;
    self.circleLayer.lineWidth = [self lineWidth];
    self.circleLayer.lineCap = kCALineCapRound;
    self.circleLayer.lineJoin = kCALineJoinRound;
    self.circleLayer.strokeEnd = 0;
    [self.layer addSublayer:self.circleLayer];
}

/** 执行正向动画 暂停->播放*/
- (void)actionPositiveAnimation {
    /** 开始三角形的动画 */
    [self strokeEndAnimationFrom:0 to:1 onLayer:self.triangleLayer name:TriangleAnimation duration:animationDuration delegate:self];
    
    /** 开始右侧线条动画 */
    [self strokeEndAnimationFrom:1 to:0 onLayer:self.rightLineLayer name:RightLineAnimation duration:animationDuration/4 delegate:self];
    
    /** 开启画弧动画 */
    [self strokeEndAnimationFrom:0 to:1 onLayer:self.circleLayer name:nil duration:animationDuration/4 delegate:self];
    
    /** 开启逆向画弧动画 */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration/4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self circleStartAnimationFrom:0 to:1];
    });
    
    /** 开启左侧线条缩短动画 */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration/2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /** 左侧竖线动画 */
        [self strokeEndAnimationFrom:1 to:0 onLayer:self.leftLineLayer name:nil duration:animationDuration/2 delegate:nil];
    });
}

/** 执行逆向动画 播放->暂停 */
- (void)actionInverseAnimation {
    /** 开始三角动画 */
    [self strokeEndAnimationFrom:1 to:0 onLayer:self.triangleLayer name:TriangleAnimation duration:animationDuration delegate:self];
    
    /** 开始左侧线条动画 */
    [self strokeEndAnimationFrom:0 to:1 onLayer:self.leftLineLayer name:nil duration:animationDuration/2 delegate:nil];
    
    /** 执行画弧动画 */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration/2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self circleStartAnimationFrom:1 to:0];
    });
    
    /** 执行反向画弧和右侧放大动画 */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration*0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /** 右侧竖线动画 */
        [self strokeEndAnimationFrom:0 to:1 onLayer:self.rightLineLayer name:RightLineAnimation duration:animationDuration/4 delegate:self];
        /** 圆弧动画 */
        [self strokeEndAnimationFrom:1 to:0 onLayer:self.circleLayer name:nil duration:animationDuration/4 delegate:nil];
    });
}
/** 通用执行strokeEnd动画 */
- (CABasicAnimation *)strokeEndAnimationFrom:(CGFloat)fromeValue to:(CGFloat)toValue onLayer:(CALayer *)layer name:(NSString *)animationName duration:(CGFloat)duration delegate:(id)delegate {
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = duration;
    strokeEndAnimation.fromValue = @(fromeValue);
    strokeEndAnimation.toValue = @(toValue);
    strokeEndAnimation.fillMode = kCAFillModeForwards;
    strokeEndAnimation.removedOnCompletion = NO;
    [strokeEndAnimation setValue:animationName forKey:@"animationName"];
    strokeEndAnimation.delegate = delegate;
    [layer addAnimation:strokeEndAnimation forKey:nil];
    return strokeEndAnimation;
}

/** 画弧改变起始位置动画 */
- (void)circleStartAnimationFrom:(CGFloat)fromValue to:(CGFloat)toValue {
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    circleAnimation.duration = animationDuration/4;
    circleAnimation.fromValue = @(fromValue);
    circleAnimation.toValue = @(toValue);
    circleAnimation.fillMode = kCAFillModeForwards;
    circleAnimation.removedOnCompletion = NO;
    [self.circleLayer addAnimation:circleAnimation forKey:nil];
}

#pragma mark -- 动画开始/结束代理方法
/** 为了避免动画结束回到原点后会有一个原点显示在屏幕上需要做一些处理，就是改变layer的lineCap属性 */

- (void)animationDidStart:(CAAnimation *)anim {
    NSString *name = [anim valueForKey:@"animationName"];
    BOOL isTriangle = [name isEqualToString:TriangleAnimation];
    BOOL isRightLine = [name isEqualToString:RightLineAnimation];
    
    if (isTriangle) {
        self.triangleLayer.lineCap = kCALineCapRound;
    }else if (isRightLine) {
        self.rightLineLayer.lineCap = kCALineCapRound;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *name = [anim valueForKey:@"animationName"];
    BOOL isTriangle = [name isEqualToString:TriangleAnimation];
    BOOL isRightLine = [name isEqualToString:RightLineAnimation];
    if (_buttonState == iQiYiPlayButtonStatePlay && isRightLine) {
        _rightLineLayer.lineCap = kCALineCapButt;
    } else if (isTriangle) {
        _triangleLayer.lineCap = kCALineCapButt;
    }
}

#pragma mark -- 其他方法
/** 线条宽度，根据按钮的宽度，按比例设置 */
- (CGFloat)lineWidth {
    return self.bounds.size.width * 0.2;
}

#pragma mark -- 竖线动画
/** 暂停->播放竖线动画 */

- (void)linePositiveAnimation {
    CGFloat a = self.bounds.size.width;
    
    // 左侧缩放动画
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    [leftPath moveToPoint:CGPointMake(0.2*a, 0.4*a)];
    [leftPath addLineToPoint:CGPointMake(0.2*a, a)];

    self.leftLineLayer.path = leftPath.CGPath;
    [self.leftLineLayer addAnimation:[self pathAnimationWithDuration:positionDuration/2] forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(positionDuration/2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /** 左侧位移动画 */
        UIBezierPath *leftPath = [UIBezierPath bezierPath];
        [leftPath moveToPoint:CGPointMake(0.2*a, 0.2*a)];
        [leftPath addLineToPoint:CGPointMake(0.2*a, 0.8*a)];

        self.leftLineLayer.path = leftPath.CGPath;
        [self.leftLineLayer addAnimation:[self pathAnimationWithDuration:positionDuration/2] forKey:nil];
        
         /** 右侧竖线缩放动画 */
        UIBezierPath *rightPath = [UIBezierPath bezierPath];
        [rightPath moveToPoint:CGPointMake(a*0.8,a*0.8)];
        [rightPath addLineToPoint:CGPointMake(a*0.8,a*0.2)];
        self.rightLineLayer.path = rightPath.CGPath;
        [self.rightLineLayer addAnimation:[self pathAnimationWithDuration:positionDuration/2] forKey:nil];
    });
}

/** 播放->暂停竖线动画 */
- (void)lineInverseAnimation {
    CGFloat a = self.bounds.size.width;
//    左侧位移动画
    UIBezierPath *leftPath1 = [UIBezierPath bezierPath];
    [leftPath1 moveToPoint:CGPointMake(0.2*a,0.4*a)];
    [leftPath1 addLineToPoint:CGPointMake(0.2*a,a)];
    self.leftLineLayer.path = leftPath1.CGPath;
    [self.leftLineLayer addAnimation:[self pathAnimationWithDuration:positionDuration/2] forKey:nil];
    
    //右侧竖线位移动画
    UIBezierPath *rightPath1 = [UIBezierPath bezierPath];
    [rightPath1 moveToPoint:CGPointMake(0.8*a, 0.8*a)];
    [rightPath1 addLineToPoint:CGPointMake(0.8*a,-0.2*a)];
    self.rightLineLayer.path = rightPath1.CGPath;
    [self.rightLineLayer addAnimation:[self pathAnimationWithDuration:positionDuration/2] forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  positionDuration/2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        //左侧竖线缩放动画
        UIBezierPath *leftPath2 = [UIBezierPath bezierPath];
        [leftPath2 moveToPoint:CGPointMake(a*0.2,0)];
        [leftPath2 addLineToPoint:CGPointMake(a*0.2,a)];
        self.leftLineLayer.path = leftPath2.CGPath;
        [self.leftLineLayer addAnimation:[self pathAnimationWithDuration:positionDuration/2] forKey:nil];
        
        //右侧竖线缩放动画
        UIBezierPath *rightPath2 = [UIBezierPath bezierPath];
        [rightPath2 moveToPoint:CGPointMake(a*0.8,a)];
        [rightPath2 addLineToPoint:CGPointMake(a*0.8,0)];
        self.rightLineLayer.path = rightPath2.CGPath;
        [self.rightLineLayer addAnimation:[self pathAnimationWithDuration:positionDuration/2] forKey:nil];
    });
}
/** 暂停竖线动画 */
/** 通用path动画的方法 */
- (CABasicAnimation *)pathAnimationWithDuration:(CGFloat)duration {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = duration;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    return pathAnimation;
}

#pragma mark -- Setter
- (void)setButtonState:(iQiYiPlayButtonState)buttonState {
    /** 如果正在执行动画 */
    if (_isAnimating == YES) {
        return;
    }
    _buttonState = buttonState;
    

    if (buttonState == iQiYiPlayButtonStatePlay) {
        /** 暂停到播放的过程 */
        self.isAnimating = YES;
        /** 竖线正向动画 */
        [self linePositiveAnimation];
        /** 执行画弧线，画三角动画 */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(positionDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self actionPositiveAnimation];
        });
    } else if (buttonState == iQiYiPlayButtonStatePause) {
        /** 播放到暂停的过程 */
        self.isAnimating = YES;
        /** 先执行画弧、画三角动画 */
        [self actionInverseAnimation];
        /** 再执行竖线位移动画，结束动画要比开始动画快 */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            /** 竖线逆向动画 */
            [self lineInverseAnimation];
        });
    }
    
    /** 更新动画执行状态 */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(positionDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

@end



























