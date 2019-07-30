//
//  CameraParamView.h
//  TestDemo
//
//  Created by admin on 2018/12/7.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CameraParamViewDelegate <NSObject>
-(void)brightnessSliderValueChanged:(int)value;
-(void)exposureSliderValueChanged:(int)value;
-(void)contrastSliderValueChanged:(int)value;
-(void)whiteBalanceSliderValueChanged:(int)value;
@end

@interface CameraParamView : UIView

@property (nonatomic, strong) id<CameraParamViewDelegate> cameraParamViewDelegate;

@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, weak) UILabel *brightnessLab;
@property (nonatomic, weak) UILabel *brightnessValueLab;
@property (nonatomic, weak) UISlider *brightnessSlider;

@property (nonatomic, weak) UILabel *exposureLab;
@property (nonatomic, weak) UILabel *exposureValueLab;
@property (nonatomic, weak) UISlider *exposureSlider;

@property (nonatomic, weak) UILabel *contrastLab;
@property (nonatomic, weak) UILabel *contrastValueLab;
@property (nonatomic, weak) UISlider *contrastSlider;

@property (nonatomic, weak) UILabel *whiteBalanceLab;
@property (nonatomic, weak) UILabel *whiteBalanceValueLab;
@property (nonatomic, weak) UISlider *whiteBalanceSlider;

@property (nonatomic, weak) UIColor *mianColor;
@property (nonatomic, weak) UIColor *minimumTrackColor;

@end
