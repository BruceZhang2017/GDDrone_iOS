//
//  ViewController.h
//  GDDrone-JL
//
//  Created by admin on 2018/7/12.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraParamView.h"


@interface ViewController : UIViewController
singleton_interface(ViewController)
@property (nonatomic, weak) CameraParamView *cameraParamView;   //相机参数面板
@property (nonatomic,assign) BOOL isTcpConnected;
@property (nonatomic,assign) BOOL noTFisRecording; //录像状态

-(void)openRealStream;
-(void)stopRealTimeMediaPlay;
-(void)resetCameraParam;
-(void)startLocalRecord;
-(void)stopLocalRecord;
@end

