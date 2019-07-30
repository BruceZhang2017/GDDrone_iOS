//
//  JoystickView.m
//  TestDemo
//
//  Created by admin on 2018/7/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "JoystickView.h"


@interface JoystickView()
@property (nonatomic, weak) UIImageView *sliderIv;
@property (nonatomic, weak) UIImageView *panelIv;
@property (nonatomic, assign) int panelRadius; //圆盘面板半径
@property (nonatomic, assign) int jaystickTag;
@property (nonatomic, assign) CGFloat offsetX,offsetY;
@property (nonatomic, assign) CGPoint touchDownPoint;
@property (nonatomic, assign) BOOL isTouchMode;
@property (nonatomic, strong) CMMotionManager *motionManager;//运动服务,加速度数据、陀螺仪数据和磁力计数据
@end

@implementation JoystickView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        //
        UIImageView *sIv = [[UIImageView alloc] init];
        sIv.image = [UIImage imageNamed:@"JoystickView_Slider"];
        self.sliderIv = sIv;
        [self addSubview:self.sliderIv];
        
        UIImageView *pIv = [[UIImageView alloc] init];
        pIv.image = [UIImage imageNamed:@"JoystickView_DirectionPanel"];
        self.panelIv = pIv;
        [self addSubview:self.panelIv];
        
        _isTouchMode = YES;
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(geatureAction:)]];
        
        _motionManager = [[CMMotionManager alloc] init];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    self.panelIv.frame = CGRectMake(0, 0, size.width*0.5, size.height*0.5);
    self.panelRadius = size.width*0.5 / 2 - size.width * 0.1 / 2;
    self.panelIv.center = CGPointMake(self.center.x-self.frame.origin.x,self.center.y-self.frame.origin.y);
    
    self.sliderIv.frame = CGRectMake(0, 0, size.width * 0.1, size.width * 0.1);
    self.sliderIv.center = self.panelIv.center;
}

-(void)setPanelBackgroundImage:(UIImage *)img{
    self.panelIv.image = img;
}
-(void)setJoystickTag:(int)joystickTag{
    self.jaystickTag = joystickTag;
}

CGPoint touchDownPoint;
//CGFloat offsetX,offsetY;
-(void)geatureAction:(UIPanGestureRecognizer *)sender{
    //非触摸模式，退出
    if(!_isTouchMode) return;
    
    CGPoint currTouchPoint = [sender locationInView:self];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        //记录按下点
        touchDownPoint = currTouchPoint;
        //计算按下点到中心点的X，Y距离
        _offsetX = touchDownPoint.x - self.panelIv.center.x;
        _offsetY = touchDownPoint.y - self.panelIv.center.y;
    }
    
    CGPoint currPoint = CGPointMake(currTouchPoint.x - _offsetX, currTouchPoint.y - _offsetY);
    
    //计算currPoint到中心点的距离
    int distance = [self calculateDistanceFromPoint:currPoint ToPoint:self.panelIv.center];
    if(distance > self.panelRadius){
        //计算弧度
        float radian = [self calulateAngleLinePointA:currPoint ToPointO:self.panelIv.center];

        int circumOffetX = cos(radian)*self.panelRadius;
        int circumOffetY = sin(radian)*self.panelRadius;
        
        currPoint.x = self.panelIv.center.x + circumOffetX;
        currPoint.y = self.panelIv.center.y + circumOffetY;
    }
    
    
    self.sliderIv.center = currPoint;
    
    if(sender.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.05 animations:^{
            self.sliderIv.center = self.panelIv.center;
        } completion:^(BOOL finished){
            if([self.delegate respondsToSelector:@selector(joystickValueChangedX:Y:Tag:flag:)]){
                [self.delegate joystickValueChangedX:0 Y:0 Tag:self.jaystickTag flag: YES];
            }
        }];
    }
    
    int valueX = (currPoint.x - self.panelIv.center.x) * 1000 / (_panelRadius);
    int valueY = (currPoint.y - self.panelIv.center.y) * 1000 / (_panelRadius);
//    NSLog(@"valueX:%d,valueY:%d",valueX,valueY);
    if([_delegate respondsToSelector:@selector(joystickValueChangedX:Y:Tag:flag:)]){
        [self.delegate joystickValueChangedX:valueX Y:valueY Tag:self.jaystickTag flag: YES];
    }

}

-(void)startGSensor{
    if (_motionManager && _motionManager.isAccelerometerAvailable) {
        _isTouchMode = NO;
        [_motionManager setAccelerometerUpdateInterval:0.05];
        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            
            int x,y;
            int velocity = 1000;
            
            x = round(accelerometerData.acceleration.y * velocity * -1);
            y = round(accelerometerData.acceleration.x * velocity * -1);
            
            
            float r = sqrt(x * x + y * y);
            
            if (r >= velocity) {
                x = velocity * (x / r);
                y = velocity * (y / r);
            }
            
            if ((x < 100 && x > -100 ) &&(y < 100 && y > -100) ) {
                x = 0;
                y = 0;
            }
            
            NSLog(@"x=%d,y=%d",x,y);
            if([self.delegate respondsToSelector:@selector(joystickValueChangedX:Y:Tag:flag:)]){
                [self.delegate joystickValueChangedX:x Y:y Tag:self.jaystickTag flag:NO];
            }
            
            //移动小球滑块
            CGPoint curPoint;
            curPoint.x = self.panelIv.center.x + x/(float)velocity * self.panelRadius;
            curPoint.y = self.panelIv.center.y + y/(float)velocity * self.panelRadius;
            [UIView animateWithDuration:0.05 animations:^{
                self.sliderIv.center = curPoint;
            }];
        }];
    }
}

-(void)stopGSensor{
    _isTouchMode = YES;
    if (_motionManager && [_motionManager isAccelerometerActive]) {
        if([self.delegate respondsToSelector:@selector(joystickValueChangedX:Y:Tag:flag:)]){
            [self.delegate joystickValueChangedX:0 Y:0 Tag:self.jaystickTag flag:NO];
        }
        [_motionManager stopAccelerometerUpdates];
        self.sliderIv.center = self.panelIv.center;
    }
}


//计算两点距离
-(int)calculateDistanceFromPoint:(CGPoint)pointA ToPoint:(CGPoint) pointB{
    int deltaX = pointB.x-pointA.x;
    int deltaY = pointB.y-pointA.y;
    return sqrtf(deltaX*deltaX + deltaY*deltaY);
}


//计算pointA与PointO形成的直线与水平线之间的夹角
-(float)calulateAngleLinePointA:(CGPoint)pointA ToPointO:(CGPoint) pointO{
    int deltaX = pointA.x-pointO.x;
    int deltaY = pointA.y-pointO.y;
    float distance = sqrtf(deltaX*deltaX + deltaY*deltaY);
    float radian = acos(deltaX / distance);
    return radian * (pointA.y < pointO.y ?  -1 : 1);
}

@end
