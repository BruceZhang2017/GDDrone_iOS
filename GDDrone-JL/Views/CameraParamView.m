//
//  CameraParamView.m
//  TestDemo
//
//  Created by admin on 2018/12/7.
//  Copyright © 2018 admin. All rights reserved.
//

#import "CameraParamView.h"
#import "UIColor+HexColor.h"
#import "SDKLib.h"
#import "CameraParamModel.h"
#import "AppInfoGeneral.h"


@interface CameraParamView()
//@property (nonatomic, weak) UILabel *titleLab;
//@property (nonatomic, weak) UILabel *brightnessLab;
//@property (nonatomic, weak) UILabel *brightnessValueLab;
//@property (nonatomic, weak) UISlider *brightnessSlider;
//
//@property (nonatomic, weak) UILabel *exposureLab;
//@property (nonatomic, weak) UILabel *exposureValueLab;
//@property (nonatomic, weak) UISlider *exposureSlider;
//
//@property (nonatomic, weak) UILabel *contrastLab;
//@property (nonatomic, weak) UILabel *contrastValueLab;
//@property (nonatomic, weak) UISlider *contrastSlider;
//
//@property (nonatomic, weak) UILabel *whiteBalanceLab;
//@property (nonatomic, weak) UILabel *whiteBalanceValueLab;
//@property (nonatomic, weak) UISlider *whiteBalanceSlider;
//
//@property (nonatomic, weak) UIColor *mianColor;
//@property (nonatomic, weak) UIColor *minimumTrackColor;

@end


@implementation CameraParamView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)drawRect:(CGRect)rect{
//    int headHeight = size.height/5;
//    int lineHeight = (size.height-headHeight)/4;
    [self drawLinePointA:CGPointMake(0, headHeight) ToPointB:CGPointMake(size.width, headHeight)];
    [self drawLinePointA:CGPointMake(0, headHeight+lineHeight) ToPointB:CGPointMake(size.width, headHeight+lineHeight)];
    [self drawLinePointA:CGPointMake(0, headHeight+2*lineHeight) ToPointB:CGPointMake(size.width, headHeight+2*lineHeight)];
    [self drawLinePointA:CGPointMake(0, headHeight+3*lineHeight) ToPointB:CGPointMake(size.width, headHeight+3*lineHeight)];
    
    [self drawRectangle:CGRectMake(0, 0, size.width, lineHeight-1)];
}

-(void)drawLinePointA:(CGPoint) pointA ToPointB:(CGPoint) pointB{
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //指定直线样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context, 1.0);
    //设置颜色
//    CGContextSetRGBStrokeColor(context, 0.314, 0.486, 0.859, 1.0);
    CGContextSetRGBStrokeColor(context, 0.196, 0.196, 0.196, 1.0);
    //开始绘制
    CGContextBeginPath(context);
    //画笔移动到点(31,170)
    CGContextMoveToPoint(context, pointA.x, pointA.y);//31,70
    //下一点
    CGContextAddLineToPoint(context, pointB.x, pointB.y);
    //绘制完成
    CGContextStrokePath(context);
}

-(void)drawRectangle:(CGRect)rect{
    //创建路径并获取句柄
    CGMutablePathRef path = CGPathCreateMutable();
    //指定矩形
    CGRect rectangle = rect;
    //将矩形添加到路径中
    CGPathAddRect(path,NULL, rectangle);
    //获取上下文
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //将路径添加到上下文
    CGContextAddPath(currentContext, path);
    //设置矩形填充色
    //[[UIColor colorWithRed:0.20f green:0.60f blue:0.80f alpha:1.0f] setFill];
    [_mianColor setFill];
    //矩形边框颜色
    [_mianColor setStroke];
    //边框宽度
    CGContextSetLineWidth(currentContext,1.0f);
    //绘制
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    CGPathRelease(path);
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        //
//        UIImageView *sliderIv = [[UIImageView alloc] init];
//        sliderIv.image = [UIImage imageNamed:@"JoystickView_Slider"];
//        self.sliderIv = sliderIv;
//        [self addSubview:self.sliderIv];
//
//        UIImageView *panelIv = [[UIImageView alloc] init];
//        panelIv.image = [UIImage imageNamed:@"JoystickView_DirectionPanel"];
//        self.panelIv = panelIv;
//        [self addSubview:self.panelIv];
//
//        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(geatureAction:)]];
        
        _mianColor = [UIColor colorWithHexString:@"#17191A"];
        
        
        [self titleLab];
        [self brightnessLab];
        [self brightnessValueLab];
        [self brightnessSlider];
        [self exposureLab];
        [self exposureValueLab];
        [self exposureSlider];
        [self contrastLab];
        [self contrastValueLab];
        [self contrastSlider];
        [self whiteBalanceLab];
        [self whiteBalanceValueLab];
        [self whiteBalanceSlider];
    }
    return self;
}


-(void)setRadius{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    self.layer.masksToBounds = YES;
}

//Title
-(UILabel *)titleLab{
    if(_titleLab == nil){
        UILabel *lab = [[UILabel alloc] init];
        [lab setText:kDV_TXT(@"相机设置")];//@"== Camera Settings =="
        [lab setTextAlignment:NSTextAlignmentCenter];
        //[lab setBackgroundColor:kBlueColor];
        [lab setTextColor:kWhiteColor];
        [self addSubview:lab];
        _titleLab = lab;
    }
    return _titleLab;
}

-(void)setTitleLabFrame{
    int titleLabW = self.frame.size.width;
    int titleLabH = headHeight;
    _titleLab.frame = CGRectMake(0, 0, titleLabW, titleLabH);
}

//亮度
-(UILabel *)brightnessLab{
    if(_brightnessLab == nil){
        UILabel *lab = [[UILabel alloc] init];
        [lab setText:kDV_TXT(@"亮度")];
        [lab setTextAlignment:NSTextAlignmentLeft];
       // [lab setBackgroundColor:kBlueColor];
        [lab setTextColor:kBlackColor];
        [lab setFont:kCameraParamLabFontSize];
        [self addSubview:lab];
        _brightnessLab = lab;
    }
    return _brightnessLab;
}

-(void)setBrightnessLabFrame{
    _brightnessLab.frame = CGRectMake(0, headHeight, paramLabW, lineHeight);
}

-(UILabel *)brightnessValueLab{
    if(_brightnessValueLab == nil){
        UILabel *lab = [[UILabel alloc] init];
        [lab setText:@"0"];
        [lab setTextAlignment:NSTextAlignmentLeft];
        // [lab setBackgroundColor:kBlueColor];
        [lab setTextColor:kBlackColor];
        [lab setFont:kCameraParamLabFontSize];
        [self addSubview:lab];
        _brightnessValueLab = lab;
    }
    return _brightnessValueLab;
}

-(void)setBrightnessValueLabFrame{
    _brightnessValueLab.frame = CGRectMake(paramNameLabW + 5, headHeight, paramLabW, lineHeight);
}

-(UISlider*)brightnessSlider{
    if(_brightnessSlider == nil){
        UISlider *slider = [[UISlider alloc] init];
        slider.minimumValue = -127;
        slider.maximumValue = 127;
        slider.minimumTrackTintColor = kCameraParamSliderMinTrackColor;
        slider.value = 0;
        [slider setContinuous:YES];
        [slider addTarget:self action:@selector(brightnessSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:slider];
        _brightnessSlider = slider;
    }
    return _brightnessSlider;
}

-(void)setBrightnessSliderFrame{
    _brightnessSlider.frame = CGRectMake(paramLabW, headHeight, sliderW, lineHeight);
}

//曝光
-(UILabel *)exposureLab{
    if(_exposureLab == nil){
        UILabel *lab = [[UILabel alloc] init];
        [lab setText:kDV_TXT(@"曝光度")];
        [lab setTextAlignment:NSTextAlignmentLeft];
        // [lab setBackgroundColor:kBlueColor];
        [lab setTextColor:kBlackColor];
        [lab setFont:kCameraParamLabFontSize];
        [self addSubview:lab];
        _exposureLab = lab;
    }
    return _exposureLab;
}


-(void)setExposureLabFrame{
    _exposureLab.frame = CGRectMake(0, headHeight+lineHeight, paramLabW, lineHeight);
}

-(UILabel *)exposureValueLab{
    if(_exposureValueLab == nil){
        UILabel *lab = [[UILabel alloc] init];
        [lab setText:@"0"];
        [lab setTextAlignment:NSTextAlignmentLeft];
        // [lab setBackgroundColor:kBlueColor];
        [lab setTextColor:kBlackColor];
        [lab setFont:kCameraParamLabFontSize];
        [self addSubview:lab];
        _exposureValueLab = lab;
    }
    return _exposureValueLab;
}

-(void)setExposureValueLabFrame{
    _exposureValueLab.frame = CGRectMake(paramNameLabW+5, headHeight+lineHeight, paramLabW, lineHeight);
}

-(UISlider*)exposureSlider{
    if(_exposureSlider == nil){
        UISlider *slider = [[UISlider alloc] init];
        slider.minimumValue = -3;
        slider.maximumValue = 3;
        slider.minimumTrackTintColor = kCameraParamSliderMinTrackColor;
        slider.value = 0;
        [slider setContinuous:YES];
        [slider addTarget:self action:@selector(exposureSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:slider];
        _exposureSlider = slider;
    }
    return _exposureSlider;
}

-(void)setExposureSliderFrame{
    _exposureSlider.frame = CGRectMake(paramLabW, headHeight+lineHeight, sliderW, lineHeight);
}



//对比度
-(UILabel *)contrastLab{
    if(_contrastLab == nil){
        UILabel *lab = [[UILabel alloc] init];
        [lab setText:kDV_TXT(@"对比度")];
        [lab setTextAlignment:NSTextAlignmentLeft];
        // [lab setBackgroundColor:kBlueColor];
        [lab setTextColor:kBlackColor];
        [lab setFont:kCameraParamLabFontSize];
        [self addSubview:lab];
        _contrastLab = lab;
    }
    return _contrastLab;
}

-(void)setContrastLabFrame{
    _contrastLab.frame = CGRectMake(0, headHeight+2*headHeight, paramLabW, lineHeight);
}

-(UILabel *)contrastValueLab{
    if(_contrastValueLab == nil){
        UILabel *lab = [[UILabel alloc] init];
        [lab setText:@"256"];
        [lab setTextAlignment:NSTextAlignmentLeft];
        // [lab setBackgroundColor:kBlueColor];
        [lab setTextColor:kBlackColor];
        [lab setFont:kCameraParamLabFontSize];
        [self addSubview:lab];
        _contrastValueLab = lab;
    }
    return _contrastValueLab;
}

-(void)setContrastValueLabFrame{
    _contrastValueLab.frame = CGRectMake(paramNameLabW+5, headHeight+2*headHeight, paramLabW, lineHeight);
}

-(UISlider*)contrastSlider{
    if(_contrastSlider == nil){
        UISlider *slider = [[UISlider alloc] init];
        slider.minimumValue = 0;
        slider.maximumValue = 500;
        slider.minimumTrackTintColor = kCameraParamSliderMinTrackColor;
        slider.value = 256;
        [slider setContinuous:YES];
        [slider addTarget:self action:@selector(contrastSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:slider];
        _contrastSlider = slider;
    }
    return _contrastSlider;
}

-(void)setContrastSliderFrame{
    _contrastSlider.frame = CGRectMake(paramLabW, headHeight+2*headHeight, sliderW, lineHeight);
}

//白平衡
-(UILabel *)whiteBalanceLab{
    if(_whiteBalanceLab == nil){
        UILabel *lab = [[UILabel alloc] init];
        [lab setText:kDV_TXT(@"白平衡")];
        [lab setTextAlignment:NSTextAlignmentLeft];
        // [lab setBackgroundColor:kBlueColor];
        [lab setTextColor:kBlackColor];
        [lab setFont:kCameraParamLabFontSize];
        [self addSubview:lab];
        _whiteBalanceLab = lab;
    }
    return _whiteBalanceLab;
}

-(void)setWhiteBalanceLabFrame{
    _whiteBalanceLab.frame = CGRectMake(0, headHeight+3*headHeight, paramLabW, lineHeight);
}

-(UILabel *)whiteBalanceValueLab{
    if(_whiteBalanceValueLab == nil){
        UILabel *lab = [[UILabel alloc] init];
        [lab setText:kDV_TXT(@"自动")];
        [lab setTextAlignment:NSTextAlignmentLeft];
        // [lab setBackgroundColor:kBlueColor];
        [lab setTextColor:kBlackColor];
        [lab setFont:kCameraParamLabFontSize];
        [self addSubview:lab];
        _whiteBalanceValueLab = lab;
    }
    return _whiteBalanceValueLab;
}

-(void)setWhiteBalanceValueLabFrame{
    _whiteBalanceValueLab.frame = CGRectMake(paramNameLabW+5, headHeight+3*headHeight, paramLabW, lineHeight);
}

-(UISlider*)whiteBalanceSlider{
    if(_whiteBalanceSlider == nil){
        UISlider *slider = [[UISlider alloc] init];
        slider.minimumValue = -2;
        slider.maximumValue = 2;
        slider.minimumTrackTintColor = kCameraParamSliderMinTrackColor;
        slider.value = 0;
        [slider setContinuous:YES];
        [slider addTarget:self action:@selector(whiteBalanceSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:slider];
        _whiteBalanceSlider = slider;
    }
    return _whiteBalanceSlider;
}

-(void)setWhiteBalanceSliderFrame{
    _whiteBalanceSlider.frame = CGRectMake(paramLabW, headHeight+3*headHeight, sliderW, lineHeight);
}


CGSize size;
CGPoint origin;
int headHeight = 30;
int lineHeight;
int paramLabW;
int paramNameLabW;
int sliderW = 100;
-(void)layoutSubviews{
    [super layoutSubviews];
    [self setRadius];
    
    size = self.frame.size;
    origin = self.frame.origin;
    headHeight = self.frame.size.height/5;
    lineHeight = (size.height-headHeight)/4;
    
    paramLabW = 130;
    paramNameLabW = 70;
    sliderW = self.frame.size.width - paramLabW;
    
    
    //限制最小尺寸
//    CGFloat width = 150,height = 100;
//    if(self.frame.size.width < 150){
//        width = 150;
//    }
//    if(self.frame.size.height< 100){
//        height = 100;
//    }
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
    
    [self setTitleLabFrame];
    [self setBrightnessLabFrame];
    [self setBrightnessValueLabFrame];
    [self setBrightnessSliderFrame];
    [self setExposureLabFrame];
    [self setExposureValueLabFrame];
    [self setExposureSliderFrame];
    [self setContrastLabFrame];
    [self setContrastValueLabFrame];
    [self setContrastSliderFrame];
    [self setWhiteBalanceLabFrame];
    [self setWhiteBalanceValueLabFrame];
    [self setWhiteBalanceSliderFrame];
}

-(void)brightnessSliderValueChanged:(UISlider *)sender{
    //-128~127
    int value = (int)sender.value;
    if([self.cameraParamViewDelegate respondsToSelector:@selector(brightnessSliderValueChanged:)]){
        [self.cameraParamViewDelegate brightnessSliderValueChanged:value];
    }
    
    
//    _brightnessValueLab.text = [NSString stringWithFormat:@"%d",value];
//
//    int cmdValue = value;
//
//    NSDictionary *dictionary = @{@"op":@"PUT",@"param":@{@"brightness":[NSString stringWithFormat:@"%d",cmdValue]}};
//    [[JLCtpSender sharedInstanced] dvGenericCommandWith:dictionary Topic:@"PHOTO_BRIGHTNESS"];
    //[[JLCtpSender sharedInstanced] dvGenericCommandWith:@{@"op":@"GET"} Topic:@"PHOTO_BRIGHTNESS"];
    
    
}

-(void)exposureSliderValueChanged:(UISlider *)sender{
    //-3~3
    int value = (int)sender.value;
    if([self.cameraParamViewDelegate respondsToSelector:@selector(exposureSliderValueChanged:)]){
        [self.cameraParamViewDelegate exposureSliderValueChanged:value];
    }
    
    
//    _exposureValueLab.text = [NSString stringWithFormat:@"%d",value];
//
//    int cmdValue = 0;
//    cmdValue = value;
//
//    NSDictionary *dictionary = @{@"op":@"PUT",@"param":@{@"exp":[NSString stringWithFormat:@"%d",cmdValue]}};
//    [[JLCtpSender sharedInstanced] dvGenericCommandWith:dictionary Topic:@"PHOTO_EXP"];
    
}

-(void)contrastSliderValueChanged:(UISlider *)sender{
    //0~511
    int value = (int)sender.value;
    if([self.cameraParamViewDelegate respondsToSelector:@selector(contrastSliderValueChanged:)]){
        [self.cameraParamViewDelegate contrastSliderValueChanged:value];
    }
    
    
//    _contrastValueLab.text = [NSString stringWithFormat:@"%d",value];
//
//    int cmdValue = value;
//    NSDictionary *dictionary = @{@"op":@"PUT",@"param":@{@"contrast":[NSString stringWithFormat:@"%d",cmdValue]}};
//    [[JLCtpSender sharedInstanced] dvGenericCommandWith:dictionary Topic:@"PHOTO_CONTRAST"];
}

-(void)whiteBalanceSliderValueChanged:(UISlider *)sender{
    //@param Index
    int value = (int)sender.value;
    if([self.cameraParamViewDelegate respondsToSelector:@selector(whiteBalanceSliderValueChanged:)]){
        [self.cameraParamViewDelegate whiteBalanceSliderValueChanged:value];
    }
    
    
//    int cmdValue = 0;
//    NSString* str;
//    
//    if(value == 0){
//        cmdValue = 5;
//        str = kDV_TXT(@"自动");
//    }else if(value == 1){
//        cmdValue = 1;
//        str = kDV_TXT(@"阴天");
//    }else if(value == 2){
//        cmdValue = 0;
//        str = kDV_TXT(@"日光");
//    }else if(value == -1){
//        cmdValue = 3;
//        str = kDV_TXT(@"荧光灯");
//    }else if(value == -2){
//        cmdValue = 2;
//        str = kDV_TXT(@"钨丝灯");
//    }
//    
//    _whiteBalanceValueLab.text = [NSString stringWithFormat:@"%@",str];
//    
//    NSDictionary *dictionary = @{@"op":@"PUT",@"param":@{@"wbl":[NSString stringWithFormat:@"%d",cmdValue]}};
//    [[JLCtpSender sharedInstanced] dvGenericCommandWith:dictionary Topic:@"WHITE_BALANCE"];
}
    
    


@end
