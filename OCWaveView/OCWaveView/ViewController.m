//
//  ViewController.m
//  OCWaveView
//
//  Created by 我是五高你敢信 on 2017/2/15.
//  Copyright © 2017年 我是五高你敢信. All rights reserved.
//

#import "ViewController.h"

#import "ViewController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController ()

@property (nonatomic, strong) CAShapeLayer *sinLayer;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) CGFloat waveWidth;
@property (nonatomic, assign) CGFloat waveHeight;
@property (nonatomic, assign) CGFloat waveMid;
@property (nonatomic, assign) CGFloat angularSpeed;
@property (nonatomic, assign) CGFloat amplitude;


@property (nonatomic, assign) CGFloat phase;
@property (nonatomic, assign) CGFloat phaseShift;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubView];
    [self startLoading];
}

//MARK:懒加载
- (CAShapeLayer *)sinLayer {
    if (!_sinLayer) {
        _sinLayer = [CAShapeLayer layer];
        _sinLayer.backgroundColor = [UIColor clearColor].CGColor;
        _sinLayer.fillColor = [UIColor whiteColor].CGColor;
        _sinLayer.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    }return _sinLayer;
}

//MARK:布局界面
- (void)setupSubView {
    
    self.waveHeight = SCREEN_HEIGHT * 0.5;
    self.waveWidth = SCREEN_WIDTH;
    self.waveMid = self.waveWidth * 0.5;
    self.angularSpeed = 0.3;
    self.amplitude = self.waveHeight * 0.3;
    
    self.phaseShift = 8;
    
    self.view.layer.mask = self.sinLayer;
}

//MARK: 开始动画
- (void)startLoading {
    [_displayLink invalidate];
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWave:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    CGPoint position = self.sinLayer.position ;
    position.y = position.y - SCREEN_HEIGHT - 10;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 10.0;
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = NO;
    animation.fromValue = [NSValue valueWithCGPoint:self.sinLayer.position];
    animation.toValue = [NSValue valueWithCGPoint:position];
    
    [self.sinLayer addAnimation:animation forKey:@"positionWave"];
}

- (void)updateWave:(CADisplayLink *)displayLink {
    self.phase += self.phaseShift;
    self.sinLayer.path = [self bezierPathWithWave].CGPath;
}

//MARK: 绘制正弦路径
- (UIBezierPath *)bezierPathWithWave {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat endX = 0;
    
    for (CGFloat x = 0; x < self.waveWidth + 1; x++) {
        endX = x;
        CGFloat y = 0;
        y = _amplitude * sinf(_angularSpeed * (360.0 / _waveWidth * (x * M_PI / 180.0)) + _phase * M_PI / 180.0) + _amplitude;
        if (x == 0 ) {
            [path moveToPoint:CGPointMake(x, y)];
        }else {
            [path addLineToPoint:CGPointMake(x, y)];
        }
        
    }
    
    CGFloat endY = SCREEN_HEIGHT + 10;
    [path addLineToPoint:CGPointMake(endX, endY)];
    [path addLineToPoint:CGPointMake(0, endY)];
    return path;
}




@end
