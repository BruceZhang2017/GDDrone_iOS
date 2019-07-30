//
//  JoystickView.h
//  TestDemo
//
//  Created by admin on 2018/7/18.
//  Copyright © 2018年 admin. All rights reserved.


#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
@protocol JoystickChangeDelegate <NSObject>
//-1000~1000
-(void)joystickValueChangedX:(int)valueX Y:(int) valueY Tag:(int)tag flag:(BOOL)flag;
@end

@interface JoystickView : UIView

@property (nonatomic, weak) id<JoystickChangeDelegate> delegate;
-(void)setPanelBackgroundImage:(UIImage *)img;
-(void)setJoystickTag:(int)joystickTag;
-(void)startGSensor;
-(void)stopGSensor;
@end
