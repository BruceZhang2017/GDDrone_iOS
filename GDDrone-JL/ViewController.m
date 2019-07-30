//
//  ViewController.m
//  GDDrone-JL
//
//  Created by admin on 2018/7/12.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ViewController.h"
#import "JLMediaPlayerView.h"
#import <DFUnits/DFNotice.h>
#import "SDKLib.h"
#import "AppInfoGeneral.h"
#import "PhotoEffect.h"
#import "RecordIng.h"
#import "Masonry.h"
#import "AlbumViewController.h"
#import "JoystickView.h"
#import "FlyCtrlModel.h"
#import "FlyInfoModel.h"
#import "FlyLockModel.h"
#import "FlyStateModel.h"
#import "ThumbnailClass.h"
#import "FlyFollowModel.h"
#import "FlyHolverModel.h"
#import "takeoffOrLandingModel.h"
//#import "CameraParamView.h"

#import "MindViewController.h"
#import "SettingsViewController.h"
#import "UIColor+HexColor.h"
#import "UserDefaultsUtil.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<JoystickChangeDelegate,CameraParamViewDelegate, UIAlertViewDelegate, CLLocationManagerDelegate>{
    //拍照相关
    NSInteger     rateInter;    //码流
    NSInteger     widthInter;
    //视频缩略图
    ThumbnailClass *thumb;
    NSString       *ffPaths;
    JLFFCodecFrame  *ffDecode;
    

    //录像相关
    int height;         //视频高
    int width;          //视频宽
    //摄像状态
    BOOL isRecording;

    
    //播放状态
    BOOL            isplaying;
    DFTips          *tipsView;
    
    NSTimer *flyCtrlTimer;
    NSTimer *flyFollowTimer;
    NSTimer *wifiStatusTimer; // WIFI状态定时器
    
    unsigned char flyType; // 无人机模式
    unsigned char flyStatus; //
    int latitude;
    int longitude;
    
    BOOL bFlayStatus; // NO: 未起飞 YES: 起飞
    BOOL bHomeWard;
    
    CLLocationManager * _locationManager;
    
    BOOL temSwitch; // 开关临时变量
    
}

@property (nonatomic, strong) JLMediaPlayerView *playerView;
@property (nonatomic, weak) UIButton *snapshotBtn;
@property (nonatomic, strong) PhotoEffect *photoEffectView; //拍照效果
@property (nonatomic, weak) UIButton *recordBtn;            //录像
@property (nonatomic, weak) RecordIng *recordStateView;     //录像状态
@property (nonatomic, weak) UIButton *joystickSwitchBtn;    //遥感开关
@property (nonatomic, weak) UIButton *moreBtn;              //更多
@property (nonatomic, weak) UIButton *gsensorBtn;           //重力感应
@property (nonatomic, weak) UIButton *cameraParamBtn;       //参数相机
@property (nonatomic, weak) UIButton *galleryBtn;           //相册
@property (nonatomic, weak) UIButton *settingBtn;           //设置

@property (nonatomic, weak) UIView *topBarView;
@property (nonatomic, weak) UIView *topBarView1;
@property (nonatomic, weak) UIView *topBarView2;
@property (nonatomic, weak) UIView *topBarView3;
@property (nonatomic, weak) UIView *topBarView4;
@property (nonatomic, weak) UIView *topBarView5;
@property (nonatomic, weak) UIButton *wifiStateBtn;     //wifi状态
@property (nonatomic, weak) UIImageView *batteryStateView;   //电量
@property (nonatomic, weak) UILabel *heightLabel;           //到起飞点高度
@property (nonatomic, weak) UILabel *stateLabel;            //飞机状态
@property (nonatomic, weak) UILabel *distanceLabel;            //到起飞点距离
@property (nonatomic, weak) UILabel *speedVLabel;            //垂直速度
@property (nonatomic, weak) UILabel *speedHLabel;            //水平速度
@property (nonatomic, weak) UIImageView *planetImageView;    //卫星
@property (nonatomic, weak) UILabel *planetLabel;    //卫星数量
@property (nonatomic, weak) UILabel *nLabel;    //地磁北极
@property (nonatomic, weak) UILabel *eLabel;    //地磁南极
@property (nonatomic, weak) UILabel *rollLabel;    // roll
@property (nonatomic, weak) UILabel *patchLabel;    // patch
@property (nonatomic, weak) UILabel *yawLabel;    // yaw
@property (nonatomic, weak) UIImageView *lockImageView;    //锁

@property (nonatomic, weak) UIView *bottomBarView;
@property (nonatomic, weak) UISwitch *mSwitch;
@property (nonatomic, weak) UIButton *takeoffOrLandingBtn; //
@property (nonatomic, weak) UIButton *turnbackBtn; // 一键返航
@property (nonatomic, weak) UIButton *speedBtn; // 加速度

@property (nonatomic, strong) UIImage *batteryImg0,*batteryImg1,*batteryImg2,*batteryImg3;

@property (nonatomic, strong) JoystickView *directionJoystickView;
@property (nonatomic, strong) JoystickView *oilJoystickView;

@property (nonatomic,assign) BOOL isStreamOpened;   //流是否打开

@property (nonatomic,strong) dispatch_source_t tcpConnectTimer;

@property (nonatomic, assign) int heartPacketCount;
@property (nonatomic, assign) BOOL isLowBattery; //低压

@end

@implementation ViewController
singleton_implementation(ViewController)
- (void)loadView {
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:kBounds];
//    bgView.image = [UIImage imageNamed:@"gd_bg"];
//    bgView.backgroundColor = kRGBColorInteger(50,50,50);//72
    bgView.backgroundColor = [UIColor colorWithHexString:@"#323232"];//72
    self.view = bgView;
    self.view.userInteractionEnabled = YES;
}

- (void)viewDidLoad {
    NSLog(@"viewDidLoad...");
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //视频画面View
    _playerView = [[JLMediaPlayerView alloc] initWithFrame:kBounds];
    [self.view addSubview:self.playerView];
    
    //joystickView
    [self oilJoystickView];
    [self directionJoystickView];
    
    //main View
    [self snapshotBtn];
    [self photoEffectView];
    [self recordBtn];
    [self recordStateView];
    [self joystickSwitchBtn];
    [self moreBtn];
    [self gsensorBtn];
    [self cameraParamBtn];
    [self galleryBtn];
    [self settingBtn];
    
    //topBarView
    [self topBarView];
    [self topBarView1];
    [self topBarView2];
    [self topBarView3];
    [self topBarView4];
    [self topBarView5];
    [self heightLabel];
    [self distanceLabel];
    [self speedHLabel];
    [self speedVLabel];
    [self planetImageView];
    [self planetLabel];
    [self nLabel];
    [self eLabel];
    [self rollLabel];
    [self patchLabel];
    [self yawLabel];
    [self wifiStateBtn];
    [self lockImageView];
    [self batteryStateView];
    [self stateLabel];

    //bottomBarView
    [self bottomBarView];
    [self mSwitch];
    [self takeoffOrLandingBtn];
    [self turnbackBtn];
    [self speedBtn];
    
    //
    [self cameraParamView];
    
    [self addNotice];
    
    //init thumb
    thumb = [[ThumbnailClass alloc] init];
    //thumb.delegate = self;
    
    if ([[JLCtpCaChe sharedInstance] realTimeMsgDict]) {
        rateInter = [[[JLCtpCaChe sharedInstance] realTimeMsgDict][@"h"] integerValue];
        widthInter = [[[JLCtpCaChe sharedInstance] realTimeMsgDict][@"w"] integerValue];
    }else{
        rateInter = 720;
        widthInter = 1280;
    }
    
    _oilJoystickView.hidden = YES;
    _directionJoystickView.hidden = YES;
    
    _cameraParamBtn.hidden = NO;
    _cameraParamView.hidden = YES;
    
    [self initBatteryImg];
    self.isLowBattery = NO;
    //
    dispatch_resume(self.tcpConnectTimer);
    
}


-(void)initBatteryImg{
    _batteryImg0 = [UIImage imageNamed:@"gd_battery_0"];
    _batteryImg1 = [UIImage imageNamed:@"gd_battery_1"];
    _batteryImg2 = [UIImage imageNamed:@"gd_battery_2"];
    _batteryImg3 = [UIImage imageNamed:@"gd_battery_3"];
}

-(void)addNotice{
    
    [DFNotice add:@"WIFI_SSID_MATCH" Action:@selector(wifiSsidNotice:) Own:self];
//    [DFNotice add:@"STA_VIEWCONTROLLER_DISMISS" Action:@selector(viewWillAppear:) Own:self];
    //接入设备后通知
    [DFNotice add:DV_APP_ACCESS Action:@selector(appAccessNotice:) Own:self];
    
    //CTP断开通知
   // [DFNotice add:DV_TCP_TIMEOUT Action:@selector(dvTcpDisConnectedNotice:) Own:self];
    
    //心跳包间隔通知
    [DFNotice add:DV_KEEP_INTERVAL Action:@selector(heartPacketIntervalNotice:) Own:self];
    
    //心跳包回复通知
    [DFNotice add:DV_KEEP_ALIVE Action:@selector(heartPacketResponeNotice:) Own:self];

    //收到了描述文档
    [DFNotice add:@"DEV_DESC_TXT" Action:@selector(deviceDescriptionTxtNotice:) Own:self];
    
    //拍照通知
    [DFNotice add:DV_PHOTO_CTRL Action:@selector(shootPhotos:) Own:self];//拍照通知
    //拍照成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPhotoSuccess:) name:JLFFDECODESU object:nil];
    //拍照失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPhotoFailed:) name:JLFFDECODEFA object:nil];
    //录像
    [DFNotice add:DV_VIDEO_CTRL Action:@selector(videoControlNote:) Own:self];
    
    //程序运行
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveAction) name:UIApplicationDidBecomeActiveNotification object:nil];
    //进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundAction) name:UIApplicationWillEnterForegroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeFlyCtrlTimer) name:UIApplicationWillTerminateNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundAction) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //自定义命令回复,飞机状态通知
    [DFNotice add:DV_GENERIC_CMD Action:@selector(genericCmdNote:) Own:self];
    
    //亮度获取回复通知
    [DFNotice add:DV_PHOTO_BRIGHTNESS Action:@selector(brightnessCmdNote:) Own:self];
    
    //曝光度获取回复通知
    [DFNotice add:DV_PHOTO_EXP Action:@selector(exposureCmdNote:) Own:self];
    
    //对比度获取回复通知
    [DFNotice add:DV_PHOTO_CONTRAST Action:@selector(contrastCmdNote:) Own:self];
    
    //白平衡获取回复通知
    [DFNotice add:DV_WHITE_BALANCE Action:@selector(whiteBalanceCmdNote:) Own:self];
    //将SD卡状态命令作为设备主动向手机通知的命令
   // [DFNotice add:DV_SD_STATUS Action:@selector(deviceInitiativeMsgNote:) Own:self];
    
   //实时流已打开通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realStreamOpenedNote:) name:DV_RT_STREAM_OPENED object:nil];
    
    
   // [DFNotice add:DV_TCP_CONNECTED Action:@selector(connectSecceed:) Own:self];


}

//app进入前台
-(void)applicationDidBecomeActiveAction{
    NSLog(@"applicationDidBecomeActiveNotification...");
    
  //  [self startWifiStatusTimer];
}

//程序将进入后台
-(void)applicationWillEnterForegroundAction{
//    [self removeFlyCtrlTimer];
//    [self removeWifStatusTimer];
}


//app将要推出
-(void)applicationDidEnterBackgroundAction{
    NSLog(@"applicationDidEnterBackgroundAction...");
    if(_noTFisRecording){
        [self stopLocalRecord];
    }
}




//打开图传
-(void)openRealStream{
    NSLog(@"openRealStream...");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self openForntRealStream];
        
        //初始化设备设置
       // [self initDeviceSetting];
    });
}

//打开图传
-(void)openForntRealStream{
    
    // 打开实时流播放
    NSDictionary *targetDict;
    NSDictionary *decDict = [AppInfoGeneral getDevComfigDictionary];
    if (decDict==nil) {
       // return ;
    }
    
     targetDict = @{@"format":@"1",@"w":@"1280",@"h":@"720",@"fps":@"30",@"net_type":@""};
    
    //打开前视
    [self.playerView jlRealTimeMediaPlayWith:MEDIA_FRONT WithDictionary:targetDict];
    isplaying = YES;
    
}

-(void)realStreamOpenedNote:(NSNotification *)notice{
    NSLog(@"realStreamOpenedNote...");
    //[self initDeviceSetting];
    self.isStreamOpened = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//1
        //初始化设备设置
        [self initDeviceSetting];
    });
}

-(void)stopRealTimeMediaPlay{
    [self.playerView jlRealTimeStreamStop];
}

-(void)startFlyCtrlTimer{
    NSLog(@"startFlyCtrlTimer...");

    if(flyCtrlTimer == nil){
        flyCtrlTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(sendFlyCtrData) userInfo:nil repeats:YES];
    }
    [flyCtrlTimer fire];
}

-(void)removeFlyCtrlTimer{
    
    if(flyCtrlTimer != nil){
        [flyCtrlTimer invalidate];
        flyCtrlTimer = nil;
    }
}

-(void)startFlyFollowTimer{
    NSLog(@"startFlyFollowTimer...");
    
    if(flyFollowTimer == nil){
        flyFollowTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(sendFlyFollowData) userInfo:nil repeats:YES];
    }
    [flyFollowTimer fire];
}

-(void)removeFlyFollowTimer{
    
    if(flyFollowTimer != nil){
        [flyFollowTimer invalidate];
        flyFollowTimer = nil;
    }
}

-(void)sendFlyCtrData{
    NSLog(@"发送遥感数据");
     [[JLCtpSender sharedInstanced] dvGenericCommandWith:[[FlyCtrlModel sharedInstance] getFlyCtrlData] Topic:@"GENERIC_CMD"];
}

-(void)sendFlyFollowData {
    NSLog(@"发送跟随模式");
    FlyFollowModel *followModel = [[FlyFollowModel alloc] init]; //10000000
    NSDictionary *dic = [followModel getFlyfollowData:latitude longitude:longitude];
    
    [[JLCtpSender sharedInstanced] dvGenericCommandWith:dic  Topic:@"GENERIC_CMD"];
}


-(void)startWifiStatusTimer{
    if(wifiStatusTimer == nil){
        wifiStatusTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updataWifiStatus) userInfo:nil repeats:YES];
    }
    [wifiStatusTimer fire];
}

-(void)removeWifStatusTimer{
    if(wifiStatusTimer != nil){
        [wifiStatusTimer invalidate];
        wifiStatusTimer = nil;
    }
}


-(void)updataWifiStatus{
    int wifiSignalStrength = [self getWifiSignalStrength];
    NSLog(@"wifiSignalStrength:%d",wifiSignalStrength);
    
    if(wifiSignalStrength == 0){
        
    }else if(wifiSignalStrength == 1){
        
    }else if(wifiSignalStrength == 2){
        
    }else if(wifiSignalStrength == 3){
        
    }
    
}




- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    [self.recordStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recordBtn.mas_right).with.offset(10);
        make.centerY.equalTo(self.recordBtn.mas_centerY).with.offset(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    [self.snapshotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recordBtn.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    [self.joystickSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.snapshotBtn.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    [self.gsensorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moreBtn.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [self.cameraParamBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gsensorBtn.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    
    [self.galleryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
        make.left.equalTo(self.view.mas_left).with.offset(5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
        make.right.equalTo(self.view.mas_right).with.offset(-5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [self.topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(48);
    }];
    [self.topBarView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView.mas_top).with.offset(0);
        make.left.equalTo(self.topBarView.mas_left).with.offset(0);
        make.width.mas_equalTo([[UIScreen mainScreen] bounds].size.width / 5);
        make.height.mas_equalTo(48);
    }];
    [self.topBarView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView.mas_top).with.offset(0);
        make.left.equalTo(self.topBarView1.mas_right).with.offset(0);
        make.width.mas_equalTo([[UIScreen mainScreen] bounds].size.width / 5);
        make.height.mas_equalTo(48);
    }];
    [self.topBarView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView.mas_top).with.offset(0);
        make.left.equalTo(self.topBarView2.mas_right).with.offset(0);
        make.width.mas_equalTo([[UIScreen mainScreen] bounds].size.width / 5);
        make.height.mas_equalTo(48);
    }];
    [self.topBarView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView.mas_top).with.offset(0);
        make.left.equalTo(self.topBarView3.mas_right).with.offset(0);
        make.width.mas_equalTo([[UIScreen mainScreen] bounds].size.width / 5);
        make.height.mas_equalTo(48);
    }];
    [self.topBarView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView.mas_top).with.offset(0);
        make.right.equalTo(self.topBarView.mas_right).with.offset(0);
        make.left.equalTo(self.topBarView4.mas_right).offset(0);
        make.height.mas_equalTo(48);
    }];
    [self.heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBarView1.mas_left);
        make.right.equalTo(self.topBarView1.mas_right);
        make.top.equalTo(self.topBarView1.mas_top).offset(8);
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBarView1.mas_left);
        make.right.equalTo(self.topBarView1.mas_right);
        make.bottom.equalTo(self.topBarView1.mas_bottom).offset(-8);
    }];
    [self.speedVLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBarView2.mas_left);
        make.right.equalTo(self.topBarView2.mas_right);
        make.top.equalTo(self.topBarView2.mas_top).offset(8);
    }];
    [self.speedHLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBarView2.mas_left);
        make.right.equalTo(self.topBarView2.mas_right);
        make.bottom.equalTo(self.topBarView2.mas_bottom).offset(-8);
    }];
    [self.planetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView3.mas_top).offset(4);
        make.width.height.mas_equalTo(30);
        make.centerX.equalTo(self.topBarView3.mas_centerX).offset(- 20);
    }];
    [self.planetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBarView3.mas_left);
        make.centerX.equalTo(self.planetImageView.mas_centerX);
        make.top.equalTo(self.planetImageView.mas_bottom).offset(2);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(10);
    }];
    [self.nLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView3.mas_top).offset(12);
        make.left.equalTo(self.planetImageView.mas_right).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(10);
    }];
    [self.eLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nLabel.mas_bottom).offset(3);
        make.left.equalTo(self.planetImageView.mas_right).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(10);
    }];
    [self.rollLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView4.mas_top).offset(2);
        make.centerX.equalTo(self.topBarView4.mas_centerX);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(10);
    }];
    [self.patchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rollLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.topBarView4.mas_centerX);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(10);
    }];
    [self.yawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.patchLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.topBarView4.mas_centerX);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(10);
    }];
    [self.lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView5.mas_top).offset(2);
        make.centerX.equalTo(self.topBarView5.mas_centerX);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    [self.wifiStateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lockImageView.mas_left).with.offset(-10);
        make.centerY.equalTo(self.lockImageView.mas_centerY);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    [self.batteryStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lockImageView.mas_right).with.offset(10);
        make.centerY.equalTo(self.lockImageView.mas_centerY).with.offset(0);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topBarView5.mas_bottom).with.offset(-5);
        make.centerX.equalTo(self.topBarView5.mas_centerX).with.offset(0);
        make.height.mas_equalTo(10);
    }];
    
    //bottomBarView
    [self.bottomBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.width.mas_equalTo(40*4+10*3 + 50);
        make.height.mas_equalTo(40);
    }];
    [self.mSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomBarView.mas_left).with.offset(0);
        make.centerY.equalTo(self.bottomBarView.mas_centerY).with.offset(0);
        //make.width.mas_equalTo(50);
        //make.height.mas_equalTo(40);
    }];
    [self.takeoffOrLandingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mSwitch.mas_right).with.offset(10);
        make.centerY.equalTo(self.bottomBarView.mas_centerY).with.offset(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    [self.turnbackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.takeoffOrLandingBtn.mas_right).with.offset(10);
        make.centerY.equalTo(self.bottomBarView.mas_centerY).with.offset(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    [self.speedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.turnbackBtn.mas_right).with.offset(10);
        make.centerY.equalTo(self.bottomBarView.mas_centerY).with.offset(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    //
    [self.cameraParamView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(350);//250
        make.height.mas_equalTo(200);
    }];
}


-(void)connectTcp{
    //回来之时将检查WiFi名称是否匹配
    NSString *ssid = [AppInfoGeneral currentSSID];
    if (ssid) {
//        if ([ssid hasPrefix:WIFI_PREFIX]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WIFI_SSID_MATCH" object:@0];
            [[JLDV16SDK shareInstanced] setTcpIp:@"192.168.1.1"];
            [[JLCtpSender sharedInstanced] didConnectToAddress:DV_TCP_ADDRESS withPort:DV_TCP_PORT];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WIFI_SSID_MATCH" object:@2];
    }
}


/**
 修改播放的清晰度对应UI
 
 @param height 视频高
 */
-(void)videoFrameMsgChange:(int )height{
    
}

#pragma mark 拍照
-(UIButton*)snapshotBtn{
    if(_snapshotBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gd_snapshot"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(snapshotBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _snapshotBtn = btn;
    }
    return _snapshotBtn;
}

BOOL canShoot = YES;
BOOL isPlayerSnapShoting;
-(void)snapshotBtnClickAction{
    if([self.playerView playStatus] != IJKMPMoviePlaybackStatePlaying)
        return;
    if(_noTFisRecording){
        //播放器抓拍
        if(!isPlayerSnapShoting){
            isPlayerSnapShoting = YES;
            [self playerSnapshot];
            [self.photoEffectView kacha];
            isPlayerSnapShoting = NO;
        }
       
        return;
    }
    if ([[JLCtpCaChe sharedInstance] SD_Status] == NO) {
        //                [DFUITools showText:kDV_TXT(@"TF卡不在线，拍摄失败") onView:self delay:1];
        //                return;
    
        [DFNotice add:DV_VIDEO_DATA_STREAM Action:@selector(noTFPhotoDataCallBlack:) Own:self];
        //[self.photoEffectView kacha];
        canShoot = YES;
    }else{
        [[JLCtpSender sharedInstanced] dvPhotoControl];
        canShoot = NO;
    }
    
}

-(void)playerSnapshot{
    UIImage *picImg = [self.playerView snapshotInternalOnIOS7AndLater];
    NSData *data = UIImageJPEGRepresentation(picImg, 1);
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
    [dfm setDateFormat:@"yyyyMMddHHmmssSSS"];//[dfm setDateFormat:@"yyyyMMddHHmmss"];
    NSString *nowStr = [dfm stringFromDate:nowDate];
    NSString *uuidStr = [[JLCtpCaChe sharedInstance] devUUID];
    NSString *nameStr = [NSString stringWithFormat:@"%@_%@_%@",nowStr,uuidStr,[NSString stringWithFormat:@"JPEG_NO_TF_IMG.JPG"]];
    
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    basePath = [basePath stringByAppendingPathComponent:@"device_image"];
    basePath = [basePath stringByAppendingPathComponent:nameStr];
    
    [DFFile createPath:basePath];
    [DFFile writeData:data fillFile:basePath];
}

#pragma mark <-- 保存无卡的拍照的数据
-(void)noTFPhotoDataCallBlack:(NSNotification *)note{
    NSData *data=note.object;
    if((int)[[JLCtpCaChe sharedInstance] videoStreamType]==0){
        [DFNotice remove:DV_VIDEO_DATA_STREAM Own:self];
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
        [dfm setDateFormat:@"yyyyMMddHHmmss"];
        NSString *nowStr = [dfm stringFromDate:nowDate];
        NSString *uuidStr = [[JLCtpCaChe sharedInstance] devUUID];
        NSString *nameStr = [NSString stringWithFormat:@"%@_%@_%@",nowStr,uuidStr,[NSString stringWithFormat:@"JPEG_NO_TF_IMG.JPG"]];
        
        NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        basePath = [basePath stringByAppendingPathComponent:@"device_image"];
        basePath = [basePath stringByAppendingPathComponent:nameStr];
        
        [DFFile createPath:basePath];
        [DFFile writeData:data fillFile:basePath];
        
    }else{
        NSData *headData = [data subdataWithRange:NSMakeRange(4, 1)];
        NSInteger headInteger = [DFTools dataToInt:headData];
        
        if(headInteger==103){
            [DFNotice remove:DV_VIDEO_DATA_STREAM Own:self];
            NSDictionary *dict = @{@"height":[NSString stringWithFormat:@"%ld",(long)rateInter],@"width":[NSString stringWithFormat:@"%ld",(long)widthInter],@"name":[NSString stringWithFormat:@"H264_NO_TF_IMG.JPG"]};
            [DFAction subTask:^{
                //拍照效果
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.photoEffectView kacha];
                });
                
                //异步执行，避免UI线程卡死
                if(ffDecode == nil){
                    ffDecode = [[JLFFCodecFrame alloc] init];
                }
                [ffDecode jlFFonFrameCodeWith:data withDict:dict];
            }];
        }
    }
}

//拍照回调
-(void)shootPhotos:(NSNotification *)note{
    canShoot = YES;
}
#pragma mark ---拍照成功回调
-(void)getPhotoSuccess:(NSNotification *)note{
    NSDictionary *dict = note.object;
    if ([dict[@"filename"] hasSuffix:@".MOV"]) {
        return;
    }
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
    [dfm setDateFormat:@"yyyyMMddHHmmssSSS"];//[dfm setDateFormat:@"yyyyMMddHHmmss"];
    NSString *nowStr = [dfm stringFromDate:nowDate];
    NSString *uuidStr = [[JLCtpCaChe sharedInstance] devUUID];
    NSString *nameStr = [NSString stringWithFormat:@"%@_%@_%@",nowStr,uuidStr,dict[@"filename"]];
    
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    basePath = [basePath stringByAppendingPathComponent:@"device_image"];
    basePath = [basePath stringByAppendingPathComponent:nameStr];
    
    [DFFile createPath:basePath];
    [DFFile writeData:dict[@"image"] fillFile:basePath];
    
    //删掉不必要文件
    NSString *pathDelete = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *deleteFile = [NSString stringWithFormat:@"Medias/Thumbnails/%@",dict[@"filename"]];
    pathDelete = [pathDelete stringByAppendingPathComponent:deleteFile];
    [DFFile removePath:pathDelete];
}

#pragma mark ---拍照失败回调
-(void)getPhotoFailed:(NSNotification *)note{
    NSLog(@"---getPhotoFailed---");
}

#pragma mark --拍照效果
-(PhotoEffect *)photoEffectView{
    if(_photoEffectView == nil){
        _photoEffectView = [[PhotoEffect alloc] init];
    }
    return _photoEffectView;
}


#pragma mark --录像
-(UIButton *)recordBtn{
    if(_recordBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gd_record"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(recordBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _recordBtn = btn;
    }
    return _recordBtn;
}

-(void)recordBtnClickAction{
    if([self.playerView playStatus] != IJKMPMoviePlaybackStatePlaying)
        return;
    if ([[JLCtpCaChe sharedInstance] SD_Status] == NO) {
        if (_noTFisRecording == NO) {
            
//            if(ppBtn.isHidden == NO){
//                [DFUITools showText:kDV_TXT(@"请先打开实时流") onView:self delay:1];
//                return;
//            }
            
            [self startLocalRecord];
        }else{
            [self stopLocalRecord];
        }
    }else{
        tipsView = [DFUITools showHUDOnWindowWithLabel:kDV_TXT(@"设备处理中")];
        
        if (isRecording == NO) {
            
            [[JLCtpSender sharedInstanced] dvVideoControlWithStatus:1];
            isRecording = YES;
            
        }else{
            
            
            [[JLCtpSender sharedInstanced] dvVideoControlWithStatus:0];
            isRecording = NO;
        }
    }
}

-(void)startLocalRecord{
    if(_noTFisRecording||[self.playerView playStatus] != IJKMPMoviePlaybackStatePlaying){
        return;
    }
    if(self.isLowBattery){
        [DFUITools showText:kDV_TXT(@"低压禁止录像") onView:self.view delay:1.0];
        return;
    }
    
    [_recordBtn setImage:[UIImage imageNamed:@"gd_record_sel"] forState:UIControlStateNormal];
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
    [dfm setDateFormat:@"yyyyMMddHHmmss"];
    NSString *nowStr = [dfm stringFromDate:nowDate];
    NSString *uuidStr = [[JLCtpCaChe sharedInstance] devUUID];
    NSString *mypath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *thePath = [NSString stringWithFormat:@"device_video/%@_%@.MOV",nowStr,uuidStr];
    mypath = [mypath stringByAppendingPathComponent:thePath];
    [DFFile createPath:mypath];
    ffPaths = mypath;
    
    switch (rateInter) {
        case 1080:{
            height = 1080;
            width = 1920;
        }break;
            
        case 720:{
            height = 720;
            width = 1280;
        }break;
            
        case 480:{
            height = 480;
            width = 640;
        }break;
            
        default:
            break;
    }
    
    
    NSDictionary *targetdict = @{@"width":[NSString stringWithFormat:@"%d",width],@"height":[NSString stringWithFormat:@"%d",height],@"audioRate":[[JLCtpCaChe sharedInstance] videoMsgDict][@"rate"],@"videoRate":[[JLCtpCaChe sharedInstance] videoMsgDict][@"fps"]};
    
    NSLog(@"targetdict:%@",targetdict);
    
    [[JLMovEncapsulator sharedInstanced] jlinitWithConfigurations:targetdict];
    [[JLMovEncapsulator sharedInstanced] jlcreateWithPath:mypath];
    _noTFisRecording=YES;
    isRecording = YES;
    [self.recordStateView start];
    
    // [DFNotice add:DV_PCM_DATA Action:@selector(noTFCardPcmDataCallBlack:) Own:self];
    [DFNotice add:DV_VIDEO_DATA_STREAM Action:@selector(noTFCardVideoDataCallBlack:) Own:self];
}

-(void)stopLocalRecord{
    if(!_noTFisRecording||[self.playerView playStatus] != IJKMPMoviePlaybackStatePlaying)
        return;
    [_recordBtn setImage:[UIImage imageNamed:@"gd_record"] forState:UIControlStateNormal];
    [[JLMovEncapsulator sharedInstanced]jlClose];
    //
    [thumb getVideosThumbnailWith:ffPaths];//获取视频缩略图
    _noTFisRecording=NO;
    isRecording = NO;
    [self.recordStateView stop];
    
    [DFNotice remove:DV_PCM_DATA Own:self];
    [DFNotice remove:DV_VIDEO_DATA_STREAM Own:self];
}

#pragma mark 遥感开关
-(UIButton*)joystickSwitchBtn{
    if(_joystickSwitchBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gd_joystick_switch"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(joystickSwitchBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _joystickSwitchBtn = btn;
    }
    return _joystickSwitchBtn;
}

BOOL isJoystickSwitchON;
-(void)joystickSwitchBtnClickAction{
    isJoystickSwitchON = !isJoystickSwitchON;
    if(isJoystickSwitchON){
        [_mSwitch setHidden:NO];
        [_joystickSwitchBtn setImage:[UIImage imageNamed:@"gd_joystick_switch_sel"] forState:UIControlStateNormal];
        //开启控制Timer
        [self removeFlyFollowTimer];
        [self startFlyCtrlTimer];
        _oilJoystickView.hidden = NO;
        _directionJoystickView.hidden = NO;
    }else{
        [_mSwitch setHidden:YES];
        [_joystickSwitchBtn setImage:[UIImage imageNamed:@"gd_joystick_switch"] forState:UIControlStateNormal];
        [self removeFlyCtrlTimer];
        _oilJoystickView.hidden = YES;
        _directionJoystickView.hidden = YES;
        
        [self closeGsensor];
        
        [_mSwitch setOn:false];
        if (_moreBtn.isSelected) {
            [_moreBtn setSelected:NO];
            [_locationManager stopUpdatingLocation];
        }
        bFlayStatus = NO;
        [[JLCtpSender sharedInstanced] dvGenericCommandWith:[[takeoffOrLandingModel new] takeoffOrLandingData: 0x04] Topic:@"GENERIC_CMD"];
        [_takeoffOrLandingBtn setImage:[UIImage imageNamed:@"gd_takeoff"] forState:UIControlStateNormal];
        [_takeoffOrLandingBtn setImage:[UIImage imageNamed:@"gd_takeoff_h"] forState:UIControlStateHighlighted];
        bHomeWard = NO;
    }
}


#pragma mark <- 保存无卡的h264/jpg数据
- (void)noTFCardVideoDataCallBlack:(NSNotification *)note{
    NSData *data = note.object;
    if(_noTFisRecording==YES){
        [[JLMovEncapsulator sharedInstanced] jlWirteDataToEncapsulator:data WithType:1];
    }
    NSLog(@"noTFCardVideoDataCallBlack...");
}

#pragma mark 录像状态
-(RecordIng *)recordStateView{
    if(_recordStateView == nil){
        RecordIng * recState = [[RecordIng alloc] initWithFrame:CGRectMake(60, 60, 60, 40)];
        [self.view addSubview:recState];
        _recordStateView = recState;
    }
    return _recordStateView;
}

-(void)videoControlNote:(NSNotification *)note{
    
    NSDictionary *noteDict = [note object];
    if ([noteDict[@"op"] isEqualToString:@"NOTIFY"]) {
        NSDictionary *parmDict = noteDict[@"param"];
        
        if ([parmDict[@"status"] isEqualToString:@"0"]) {
            isRecording = NO;
            [self.recordStateView stop];
        }else{
            [self.recordStateView start];
            isRecording = YES;
        }
    }
}

#pragma mark --更多
-(UIButton *)moreBtn{
    if(_moreBtn == nil){
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"follow_h"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _moreBtn = btn;
    }
    return _moreBtn;
}

BOOL isAllViewHide = NO;
-(void)moreBtnAction {
    
    if (_moreBtn.isSelected) {
        [self removeFlyFollowTimer];
        if (_mSwitch.isHidden == false) {
            [self joystickSwitchBtnClickAction];
        }
        [_moreBtn setSelected:NO];
        [_locationManager stopUpdatingLocation];
    } else {
        [_moreBtn setSelected:YES];
        [self startLocation];
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(isAllViewHide){
        self.recordBtn.hidden = NO;
        self.snapshotBtn.hidden = NO;
        self.joystickSwitchBtn.hidden = NO;
        self.galleryBtn.hidden = NO;
        
        
        self.moreBtn.hidden = NO;
        self.gsensorBtn.hidden = NO;
        self.cameraParamBtn.hidden = NO;
        self.settingBtn.hidden = NO;
        
        self.topBarView.hidden = NO;
        self.bottomBarView.hidden = NO;
        
        isAllViewHide = NO;
    }
}


#pragma mark -- 重力感应
-(UIButton *)gsensorBtn{
    if(_gsensorBtn == nil){
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gd_gsensor"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(gsensorBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _gsensorBtn = btn;
    }
    return _gsensorBtn;
}

BOOL isGSensorOn = NO;
-(void)gsensorBtnClickAction{
    if(!isJoystickSwitchON) return;
    isGSensorOn = !isGSensorOn;
    if(isGSensorOn){
        [_gsensorBtn setImage:[UIImage imageNamed:@"gd_gsensor_sel"] forState:UIControlStateNormal];
        [self.directionJoystickView startGSensor];
    }else{
        [_gsensorBtn setImage:[UIImage imageNamed:@"gd_gsensor"] forState:UIControlStateNormal];
        [self.directionJoystickView stopGSensor];
    }
}

-(void)closeGsensor{
    if(isGSensorOn){
        [_gsensorBtn setImage:[UIImage imageNamed:@"gd_gsensor"] forState:UIControlStateNormal];
        [self.directionJoystickView stopGSensor];
        isGSensorOn = NO;
    }
}

#pragma mark --相机参数
-(UIButton *)cameraParamBtn{
    if(_cameraParamBtn == nil){
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gd_camera_param"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cameraParamClickAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _cameraParamBtn = btn;
    }
    return _cameraParamBtn;
}

BOOL isCameraParamBtnOn;
-(void)cameraParamClickAction{
    isCameraParamBtnOn = !isCameraParamBtnOn;
    if(isCameraParamBtnOn){
        [_cameraParamBtn setImage:[UIImage imageNamed:@"gd_camera_param_sel"] forState:UIControlStateNormal];
        _cameraParamView.hidden = NO;
    }else{
        [_cameraParamBtn setImage:[UIImage imageNamed:@"gd_camera_param"] forState:UIControlStateNormal];
        _cameraParamView.hidden = YES;
    }
}



#pragma mark --相册
-(UIButton *)galleryBtn{
    if(_galleryBtn == nil){
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gd_gallery"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gd_gallery_h"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(galleryBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _galleryBtn = btn;
    }
    return _galleryBtn;//
}

-(void)galleryBtnClickAction{
    if(_noTFisRecording) return;
    [self.navigationController pushViewController:[AlbumViewController sharedAlbumViewController] animated:YES];
}

#pragma mark --设置
-(UIButton *)settingBtn{
    if(_settingBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gd_setting"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gd_setting_h"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(settingBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _settingBtn = btn;
    }
    return _settingBtn;
}

-(void)settingBtnClickAction{
    if(_noTFisRecording) return;
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

#pragma mark --topBar
-(UIView *)topBarView{
    if(_topBarView == nil){
        UIView *uiview = [[UIView alloc] init];
        [uiview setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]];
       // [uiview setBackgroundColor:[UIColor colorWithHexString:@"#323232"]];
        [self.view addSubview:uiview];
        _topBarView = uiview;
    }
    return _topBarView;
}

-(UIView *)topBarView1{
    if(_topBarView1 == nil){
        UIView *uiview = [[UIView alloc] init];
        [_topBarView addSubview:uiview];
        _topBarView1 = uiview;
    }
    return _topBarView1;
}

-(UIView *)topBarView2{
    if(_topBarView2 == nil){
        UIView *uiview = [[UIView alloc] init];
        [_topBarView addSubview:uiview];
        _topBarView2 = uiview;
    }
    return _topBarView2;
}

-(UIView *)topBarView3{
    if(_topBarView3 == nil){
        UIView *uiview = [[UIView alloc] init];
        [_topBarView addSubview:uiview];
        _topBarView3 = uiview;
    }
    return _topBarView3;
}

-(UIView *)topBarView4{
    if(_topBarView4 == nil){
        UIView *uiview = [[UIView alloc] init];
        [_topBarView addSubview:uiview];
        _topBarView4 = uiview;
    }
    return _topBarView4;
}

-(UIView *)topBarView5{
    if(_topBarView5 == nil){
        UIView *uiview = [[UIView alloc] init];
        [_topBarView addSubview:uiview];
        _topBarView5 = uiview;
    }
    return _topBarView5;
}

#pragma mark --wifi状态
-(UIButton *)wifiStateBtn{
    if(_wifiStateBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gd_wifi_0"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(wifiBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        [self.topBarView5 addSubview:btn];
        _wifiStateBtn = btn;
    }
    return _wifiStateBtn;
}

-(void)wifiBtnClickAction{
    [self reConnectTcp];
}

#pragma mark --电量状态
-(UIImageView *)batteryStateView{
    if(_batteryStateView == nil){
        UIImageView *iv = [[UIImageView alloc] init];
        [iv setImage:[UIImage imageNamed:@"gd_battery_3"]];
        [self.topBarView5 addSubview:iv];
        _batteryStateView = iv;
    }
    return _batteryStateView;
}

#pragma mark --高度
-(UILabel*)heightLabel{
    if(_heightLabel == nil){
        UILabel *lab = [[UILabel alloc] init];
        NSString *str = [NSString stringWithFormat:@"%@: 0m",kDV_TXT(@"高度")];
        [lab setText:str];
        [lab setTextAlignment:NSTextAlignmentCenter];
        //[lab setAdjustsFontSizeToFitWidth:YES];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setFont:[UIFont systemFontOfSize:8]];
        [self.topBarView1 addSubview:lab];
        _heightLabel = lab;
    }
    return _heightLabel;
}

-(UILabel*)distanceLabel{
    if(_distanceLabel == nil){
        UILabel *lab = [[UILabel alloc] init];
        NSString *str = [NSString stringWithFormat:@"%@: 0m",kDV_TXT(@"distance")];
        [lab setText:str];
        [lab setTextAlignment:NSTextAlignmentCenter];
        //[lab setAdjustsFontSizeToFitWidth:YES];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setFont:[UIFont systemFontOfSize:8]];
        [self.topBarView1 addSubview:lab];
        _distanceLabel = lab;
    }
    return _distanceLabel;
}

-(UILabel*)speedVLabel{
    if(_speedVLabel == nil){
        UILabel *lab = [[UILabel alloc] init];
        NSString *str = [NSString stringWithFormat:@"%@: 0m/s",kDV_TXT(@"Speed V")];
        [lab setText:str];
        [lab setTextAlignment:NSTextAlignmentCenter];
        //[lab setAdjustsFontSizeToFitWidth:YES];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setFont:[UIFont systemFontOfSize:8]];
        [self.topBarView2 addSubview:lab];
        _speedVLabel = lab;
    }
    return _speedVLabel;
}

-(UILabel*)speedHLabel{
    if(_speedHLabel == nil){
        UILabel *lab = [[UILabel alloc] init];
        NSString *str = [NSString stringWithFormat:@"%@: 0m/s",kDV_TXT(@"Speed H")];
        [lab setText:str];
        [lab setTextAlignment:NSTextAlignmentCenter];
        //[lab setAdjustsFontSizeToFitWidth:YES];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setFont:[UIFont systemFontOfSize:8]];
        [self.topBarView2 addSubview:lab];
        _speedHLabel = lab;
    }
    return _speedHLabel;
}

-(UIImageView*)planetImageView{
    if(_planetImageView == nil){
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImage:[UIImage imageNamed:@"weixing"]];
        [self.topBarView3 addSubview:imageView];
        _planetImageView = imageView;
    }
    return _planetImageView;
}

-(UILabel*)planetLabel{
    if(_planetLabel == nil){
        UILabel *lab = [[UILabel alloc] init];
        NSString *str = @"0";
        [lab setText:str];
        [lab setTextAlignment:NSTextAlignmentCenter];
        //[lab setAdjustsFontSizeToFitWidth:YES];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setFont:[UIFont systemFontOfSize:8]];
        [self.topBarView3 addSubview:lab];
        _planetLabel = lab;
    }
    return _planetLabel;
}

-(UILabel*)nLabel{
    if(_nLabel == nil){
        UILabel *lab = [[UILabel alloc] init];
        NSString *str = [NSString stringWithFormat:@"%@: 0.0",kDV_TXT(@"N")];
        [lab setText:str];
        [lab setTextAlignment:NSTextAlignmentCenter];
        //[lab setAdjustsFontSizeToFitWidth:YES];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setFont:[UIFont systemFontOfSize:8]];
        [self.topBarView3 addSubview:lab];
        _nLabel = lab;
    }
    return _nLabel;
}

-(UILabel*)eLabel{
    if(_eLabel == nil){
        UILabel *lab = [[UILabel alloc] init];
        NSString *str = [NSString stringWithFormat:@"%@: 0.0",kDV_TXT(@"E")];
        [lab setText:str];
        [lab setTextAlignment:NSTextAlignmentCenter];
        //[lab setAdjustsFontSizeToFitWidth:YES];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setFont:[UIFont systemFontOfSize:8]];
        [self.topBarView3 addSubview:lab];
        _eLabel = lab;
    }
    return _eLabel;
}

-(UILabel*)rollLabel{
    if(_rollLabel == nil){
        UILabel *lab = [[UILabel alloc] init];
        NSString *str = [NSString stringWithFormat:@"%@: 0.0",kDV_TXT(@"Roll")];
        [lab setText:str];
        [lab setTextAlignment:NSTextAlignmentCenter];
        //[lab setAdjustsFontSizeToFitWidth:YES];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setFont:[UIFont systemFontOfSize:8]];
        [self.topBarView4 addSubview:lab];
        _rollLabel = lab;
    }
    return _rollLabel;
}

-(UILabel*)patchLabel{
    if(_patchLabel == nil){
        UILabel *lab = [[UILabel alloc] init];
        NSString *str = [NSString stringWithFormat:@"%@: 0.0",kDV_TXT(@"Patch")];
        [lab setText:str];
        [lab setTextAlignment:NSTextAlignmentCenter];
        //[lab setAdjustsFontSizeToFitWidth:YES];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setFont:[UIFont systemFontOfSize:8]];
        [self.topBarView4 addSubview:lab];
        _patchLabel = lab;
    }
    return _patchLabel;
}

-(UIImageView*)lockImageView{
    if(_lockImageView == nil){
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImage:[UIImage imageNamed:@"锁"]];
        [self.topBarView5 addSubview:imageView];
        _lockImageView = imageView;
    }
    return _lockImageView;
}

-(UILabel*)yawLabel{
    if(_yawLabel == nil){
        UILabel *lab = [[UILabel alloc] init];
        NSString *str = [NSString stringWithFormat:@"%@: 0.0",kDV_TXT(@"Yaw")];
        [lab setText:str];
        [lab setTextAlignment:NSTextAlignmentCenter];
        //[lab setAdjustsFontSizeToFitWidth:YES];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setFont:[UIFont systemFontOfSize:8]];
        [self.topBarView4 addSubview:lab];
        _yawLabel = lab;
    }
    return _yawLabel;
}

#pragma mark --状态
-(UILabel*)stateLabel{
    if(_stateLabel == nil){
        UILabel *lab = [[UILabel alloc] init];
        [lab setTextAlignment:NSTextAlignmentLeft];
        [lab setAdjustsFontSizeToFitWidth:YES];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setFont:[UIFont systemFontOfSize:8]];
        //点击链接wifi
        lab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wifiBtnClickAction)];
        [lab addGestureRecognizer:tapGesture];
        
        [self.topBarView5 addSubview:lab];
        _stateLabel = lab;
    }
    return _stateLabel;
}


#pragma mark --bottomBarView
-(UIView*)bottomBarView{
    if(_bottomBarView == nil){
        UIView *uiview = [[UIView alloc] init];
//        [uiview setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:uiview];
        _bottomBarView = uiview;
    }
    return _bottomBarView;
}

-(UISwitch*)mSwitch{
    if(_mSwitch == nil){
        UISwitch *s = [[UISwitch alloc] init];
        [s setHidden:YES];
        [s setOnTintColor:[UIColor blackColor]];
        [s addTarget:self action:@selector(valueChangedWithSender:) forControlEvents:UIControlEventValueChanged];
        [_bottomBarView addSubview:s];
        _mSwitch = s;
    }
    return _mSwitch;
}

- (void)valueChangedWithSender: (UISwitch *) s {
    if (self.mSwitch.isOn == NO) {
        [self showLockAlertView];
    } else {
        [[JLCtpSender sharedInstanced] dvGenericCommandWith:[[FlyLockModel new] flylockData: 0] Topic:@"GENERIC_CMD"];
    }
}

#pragma mark --takeoffOrLandingBtn
-(UIButton*)takeoffOrLandingBtn{
    if(_takeoffOrLandingBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gd_takeoff"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gd_takeoff_h"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(takeoffOrLandingClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBarView addSubview:btn];
        _takeoffOrLandingBtn = btn;
    }
    return _takeoffOrLandingBtn;
}

-(void)takeoffOrLandingClick:(UIButton *) sender {
    if (bFlayStatus == NO) {
        bFlayStatus = YES;
        [[JLCtpSender sharedInstanced] dvGenericCommandWith:[[takeoffOrLandingModel new] takeoffOrLandingData: 0x01] Topic:@"GENERIC_CMD"];
        [_takeoffOrLandingBtn setImage:[UIImage imageNamed:@"gd_takeoff_landing"] forState:UIControlStateNormal];
        [_takeoffOrLandingBtn setImage:[UIImage imageNamed:@"gd_takeoff_landing_h"] forState:UIControlStateHighlighted];
    } else {
        bFlayStatus = NO;
        [[JLCtpSender sharedInstanced] dvGenericCommandWith:[[takeoffOrLandingModel new] takeoffOrLandingData: 0x02] Topic:@"GENERIC_CMD"];
        [_takeoffOrLandingBtn setImage:[UIImage imageNamed:@"gd_takeoff"] forState:UIControlStateNormal];
        [_takeoffOrLandingBtn setImage:[UIImage imageNamed:@"gd_takeoff_h"] forState:UIControlStateHighlighted];
    }
}

#pragma mark --turnbackBtn
-(UIButton*)turnbackBtn{
    if(_turnbackBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gd_voyage_home"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gd_voyage_home_h"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(voyageHomeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBarView addSubview:btn];
        _turnbackBtn = btn;
    }
    return _turnbackBtn;
}

-(void)voyageHomeBtnClick{
    if (bHomeWard) {
        bHomeWard = NO;
        [[JLCtpSender sharedInstanced] dvGenericCommandWith:[[FlyHolverModel new] getFlyHolverData] Topic:@"GENERIC_CMD"];
    } else {
        bHomeWard = YES;
        [[JLCtpSender sharedInstanced] dvGenericCommandWith:[[takeoffOrLandingModel new] takeoffOrLandingData: 0x08] Topic:@"GENERIC_CMD"];
    }
}

#pragma mark --speedBtn
NSString  *speedLevelValue = kSpeedLevelValueThree;
-(UIButton*)speedBtn{
    if(_speedBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        speedLevelValue = [[NSUserDefaults standardUserDefaults] stringForKey:kSpeedLevelKey];
        if([kSpeedLevelValueOne isEqual:speedLevelValue]){
            [btn setImage:[UIImage imageNamed:@"gd_speed_l"] forState:UIControlStateNormal];
        }else if([kSpeedLevelValueTwo isEqual:speedLevelValue]){
            [btn setImage:[UIImage imageNamed:@"gd_speed_m"] forState:UIControlStateNormal];
        }else if([kSpeedLevelValueThree isEqual:speedLevelValue]){
            [btn setImage:[UIImage imageNamed:@"gd_speed_h"] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:@"gd_speed_h"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:kSpeedLevelValueThree forKey:kSpeedLevelKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [btn addTarget:self action:@selector(speedBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBarView addSubview:btn];
        _speedBtn = btn;
    }
    return _speedBtn;
}

-(void)speedBtnClick{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    speedLevelValue = [userDefaults objectForKey:kSpeedLevelKey];
    if( [kSpeedLevelValueOne isEqualToString:speedLevelValue]){
        [_speedBtn setImage:[UIImage imageNamed:@"gd_speed_m"] forState:UIControlStateNormal];
        speedLevelValue = kSpeedLevelValueTwo;
        //[[FlyCtrlModel sharedInstance] setSpeedMiddle];
    }else if([kSpeedLevelValueTwo isEqualToString:speedLevelValue]){
        [_speedBtn setImage:[UIImage imageNamed:@"gd_speed_h"] forState:UIControlStateNormal];
        speedLevelValue = kSpeedLevelValueThree;
        //[[FlyCtrlModel sharedInstance] setSpeedHigh];
    }else if([kSpeedLevelValueThree isEqualToString:speedLevelValue]){
        [_speedBtn setImage:[UIImage imageNamed:@"gd_speed_l"] forState:UIControlStateNormal];
        speedLevelValue = kSpeedLevelValueOne;
        //[[FlyCtrlModel sharedInstance] setSpeedLow];
    }
    [userDefaults setObject:speedLevelValue forKey:kSpeedLevelKey];
    AudioServicesPlaySystemSound(1519);
}


-(JoystickView*)oilJoystickView{
    if(_oilJoystickView == nil){
        JoystickView * joystickView = [[JoystickView alloc] initWithFrame:CGRectMake(10, kHeight-250-10, 250, 250)];
       // joystickView.backgroundColor = [UIColor darkGrayColor];
        [joystickView setJoystickTag:kOilJoystick];
        [joystickView setPanelBackgroundImage:[UIImage imageNamed:@"JoystickView_OilPanel"]];
        joystickView.delegate = self;
        [self.view addSubview: joystickView];
        _oilJoystickView = joystickView;
    }
    return _oilJoystickView;
}

-(JoystickView*)directionJoystickView{
    if(_directionJoystickView == nil){
        JoystickView * joystickView = [[JoystickView alloc] initWithFrame:CGRectMake(kWidth-250-10, kHeight-250-10, 250, 250)];
        //joystickView.backgroundColor = [UIColor darkGrayColor];
        [joystickView setJoystickTag:kDirectionJoystick];
        [joystickView setPanelBackgroundImage:[UIImage imageNamed:@"JoystickView_DirectionPanel"]];
        joystickView.delegate = self;
        [self.view addSubview: joystickView];
        _directionJoystickView = joystickView;
    }
    return _directionJoystickView;
}

-(CameraParamView*)cameraParamView{
    if(_cameraParamView == nil){
        CameraParamView *aView = [[CameraParamView alloc] init];
        //圆角
        //        aView.layer.cornerRadius = 8;
        //        aView.layer.masksToBounds = YES;
        
        aView.backgroundColor = [UIColor lightGrayColor];
        aView.cameraParamViewDelegate = self;
        
        [self.view addSubview:aView];
        _cameraParamView = aView;
    }
    return _cameraParamView;
}


int zeroFrameRateCount = 0;
int reconnectNum = 0;

-(dispatch_source_t) tcpConnectTimer{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));//
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1*NSEC_PER_SEC, 0 *NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        
        
        if(!self.isTcpConnected){
            reconnectNum ++;
            
            if(reconnectNum == 6){//6
                reconnectNum = 0;
                NSLog(@"tcp 重连接");
                [self reConnectTcp];
                
            }
        }else{
            
            //心跳包处理
            if(self.playerView != nil){
                
                if(self.playerView.frameRate == 0){
                    if(zeroFrameRateCount<8){//5
                        zeroFrameRateCount++;
                    }else{
                        if(self.isTcpConnected && self.isStreamOpened){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self dvTcpDisConnectedNotice:nil];
                            });
                        }
                        zeroFrameRateCount = 0;
                    }
                }else{
                    zeroFrameRateCount = 0;
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //帧率模拟wifi强度
                    [self updateSpuriousWifiSignalStrengthWithFrameRate:self.playerView.frameRate];
                    NSLog(@"frameRate:%d",self.playerView.frameRate);
                    self.playerView.frameRate = 0;
                    
                    //发送自定义心跳包
                    [[JLCtpSender sharedInstanced] dvDidSendHeartBeat];
                    
                });
                
                //获取飞控新数据命令
                if(self.isStreamOpened){
                    [[JLCtpSender sharedInstanced] dvGenericCommandWith:[[FlyStateModel new] getFlyStatusData] Topic:@"GENERIC_CMD"];
                }
            }
        }
    });
    _tcpConnectTimer = timer;
    return _tcpConnectTimer;
}

-(void)rePlayRealtimeStream{
    NSLog(@"重启图传");
    [self.playerView jlRealTimeStreamStop];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self openForntRealStream];
    });
    
}

-(void)reConnectTcp{
    NSLog(@"重连tcp");
    [[JLCtpSender sharedInstanced] desConnectedCTP];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[JLDV16SDK shareInstanced] setTcpIp:@"192.168.1.1"];
        [[JLCtpSender sharedInstanced] didConnectToAddress:DV_TCP_ADDRESS withPort:DV_TCP_PORT];
    });
}


-(void)destoryAPP{
    [[JLCtpSender sharedInstanced] desConnectedCTP];
    //退到后台时，停掉播放器
    [[NSNotificationCenter defaultCenter] postNotificationName:APP_DV_UNACTIVE object:nil];
    
    //释放解析udp包内容工具
    [[JLMediaStreamManager sharedInstance] destoryPlayerManager];
    [[JLMediaPlayBlack sharedInstance] jlMediaPlayBlackOver];
}

-(void)updateSpuriousWifiSignalStrengthWithFrameRate:(int)frameRate{
    if(frameRate > 21){
        [_wifiStateBtn setImage:[UIImage imageNamed:@"gd_wifi_4"] forState:UIControlStateNormal];
    }else if(frameRate > 14){
         [_wifiStateBtn setImage:[UIImage imageNamed:@"gd_wifi_3"] forState:UIControlStateNormal];
    }else if(frameRate > 7){
         [_wifiStateBtn setImage:[UIImage imageNamed:@"gd_wifi_2"] forState:UIControlStateNormal];
    }else if(frameRate == 0){
         [_wifiStateBtn setImage:[UIImage imageNamed:@"gd_wifi_0"] forState:UIControlStateNormal];
    }
}


#pragma mark --获取wifi强度
/**
 获取wifi强度
 @return 3: 强 ，2：中， 1：弱 ，无
 */
-(int)getWifiSignalStrength{
    UIApplication *app =[UIApplication sharedApplication];
    // iphoneX状态栏和其他iPhone设备不同，变化比较大
    //判断是否是iPhoneX
    if([[app valueForKeyPath:@"_statusBar"] isKindOfClass:
        NSClassFromString(@"UIStatusBar_Modern")]){
        NSString *wifiEntry =[[[
                                [app valueForKey:@"statusBar"]
                                valueForKey:@"_statusBar"]
                               valueForKey:@"_currentAggregatedData"]
                              valueForKey:@"_wifiEntry"];
        int signalStrength =[[wifiEntry valueForKey:@"_displayValue"]intValue];
        return signalStrength;
    }
    else{
        NSArray *subviews =[[[app valueForKey:@"statusBar"]
                             valueForKey:@"foregroundView"]subviews];
        NSString *dataNetworkItemView = nil;
        for(id subview in subviews){
            if([subview isKindOfClass:
                [NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]){
                dataNetworkItemView = subview;
                break;
            }
        }
        int signalStrength =[[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];
        return signalStrength;
    }
}


#pragma mark 获取相机参数
-(void)getCameraParam{
    
//    [[JLCtpSender sharedInstanced] dvGenericCommandWith:@{@"op":@"GET"} Topic:@"PHOTO_BRIGHTNESS"];
    
//    [[JLCtpSender sharedInstanced] dvGenericCommandWith:@{@"op":@"GET"} Topic:@"PHOTO_EXP"];
//
//    [[JLCtpSender sharedInstanced] dvGenericCommandWith:@{@"op":@"GET"} Topic:@"PHOTO_CONTRAST"];
//
//    [[JLCtpSender sharedInstanced] dvGenericCommandWith:@{@"op":@"GET"} Topic:@"WHITE_BALANCE"];
}




#pragma JoystickChangeDelegate implememt
-(void)joystickValueChangedX:(int)valueX Y:(int)valueY Tag:(int)joystickTag flag: (BOOL)flag{
//    NSLog(@"valueX:%d,valueY:%d,tag:%d",valueX,valueY,joystickTag);
    if (_moreBtn.isSelected && flag) {
        [self moreBtnAction];
    }
    if(joystickTag == kOilJoystick){
        [FlyCtrlModel sharedInstance].yaw = valueX;
        [FlyCtrlModel sharedInstance].throttle = valueY;
        
//        int serialdata1 = 256-(valueY+1000)*16/125;//256-(valueY+1000)*256/2000;
//        NSLog(@"serialdata[1]:%d",serialdata1);

    }else if(joystickTag == kDirectionJoystick){
        [FlyCtrlModel sharedInstance].roll = valueX;
        [FlyCtrlModel sharedInstance].pitch = valueY;
    }
    
}



#pragma CameraParamViewDelegate implememt
-(void)brightnessSliderValueChanged:(int)value{
    [self doBrightnessChange:value];
}
-(void)doBrightnessChange:(int)value{
    _cameraParamView.brightnessValueLab.text = [NSString stringWithFormat:@"%d",value];
    _cameraParamView.brightnessSlider.value = value;
    
    int cmdValue = value;
    
    NSDictionary *dictionary = @{@"op":@"PUT",@"param":@{@"brightness":[NSString stringWithFormat:@"%d",cmdValue]}};
    [[JLCtpSender sharedInstanced] dvGenericCommandWith:dictionary Topic:@"PHOTO_BRIGHTNESS"];
    
    //数据持久化
    [UserDefaultsUtil setValue:value forKey:kBrightnessKey];
    
}


-(void)exposureSliderValueChanged:(int)value{
    [self doExposureChange:value];
}
-(void)doExposureChange:(int)value{
    _cameraParamView.exposureValueLab.text = [NSString stringWithFormat:@"%d",value];
    _cameraParamView.exposureSlider.value = value;
    
    int cmdValue = 0;
    cmdValue = value;
    
    NSDictionary *dictionary = @{@"op":@"PUT",@"param":@{@"exp":[NSString stringWithFormat:@"%d",cmdValue]}};
    [[JLCtpSender sharedInstanced] dvGenericCommandWith:dictionary Topic:@"PHOTO_EXP"];
    
    [UserDefaultsUtil setValue:value forKey:kExposureKey];
}


-(void)contrastSliderValueChanged:(int)value{
    [self doContrastChange:value];
}
-(void)doContrastChange:(int)value{
    _cameraParamView.contrastValueLab.text = [NSString stringWithFormat:@"%d",value];
    _cameraParamView.contrastSlider.value = value;
    
    int cmdValue = value;
    NSDictionary *dictionary = @{@"op":@"PUT",@"param":@{@"contrast":[NSString stringWithFormat:@"%d",cmdValue]}};
    NSLog(@"contrastValue:%d",cmdValue);
    [[JLCtpSender sharedInstanced] dvGenericCommandWith:dictionary Topic:@"PHOTO_CONTRAST"];
    
    [UserDefaultsUtil setValue:value forKey:kContrastKey];
}


-(void)whiteBalanceSliderValueChanged:(int)value{
    [self doWhiteBalanceChange:value];
}
-(void)doWhiteBalanceChange:(int)value{
    int cmdValue = 0;
    NSString* str;
    
    if(value == 0){
        cmdValue = 5;
        str = kDV_TXT(@"自动");
    }else if(value == 1){
        cmdValue = 1;
        str = kDV_TXT(@"阴天");
    }else if(value == 2){
        cmdValue = 0;
        str = kDV_TXT(@"日光");
    }else if(value == -1){
        cmdValue = 3;
        str = kDV_TXT(@"荧光灯");
    }else if(value == -2){
        cmdValue = 2;
        str = kDV_TXT(@"钨丝灯");
    }
    
    _cameraParamView.whiteBalanceValueLab.text = [NSString stringWithFormat:@"%@",str];
    _cameraParamView.whiteBalanceSlider.value = value;
    
    NSDictionary *dictionary = @{@"op":@"PUT",@"param":@{@"wbl":[NSString stringWithFormat:@"%d",cmdValue]}};
    [[JLCtpSender sharedInstanced] dvGenericCommandWith:dictionary Topic:@"WHITE_BALANCE"];
    
    [UserDefaultsUtil setValue:value forKey:kWhiteBalanceKey];
}


#pragma mark --通知
-(void)wifiSsidNotice:(NSNotification *)notice{
    NSLog(@"wifiSsidNotice...");
    NSObject *obj = notice.object;
    NSString *ssid = [AppInfoGeneral currentSSID];
    if ([obj isEqual:@0]) {
        NSString *wifiName;
        if ([DV_TCP_ADDRESS isEqualToString:@"192.168.1.1"]) {
            wifiName = [ssid stringByReplacingOccurrencesOfString:WIFI_PREFIX withString:@""];
        }else{
            wifiName = DV_TCP_ADDRESS;
        }
    }else{
      
    }
}

-(void)appAccessNotice:(NSNotification*)notice{
    NSLog(@"appAccessNotice...");
    NSDictionary *dict = notice.object;
    if ([dict[@"errno"] intValue] != 0) {
        NSDictionary *parDict = dict[@"param"];
        NSString *str = [NSString stringWithFormat:@"ERROR TYPE:%@",dict[@"errno"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:parDict[@"msg"] message:str delegate:nil cancelButtonTitle:kDV_TXT(@"确认") otherButtonTitles:nil, nil];
        alert.tag = -1;
        [alert show];
        return;
    }
    
    //NSString *str = [NSString stringWithFormat:@" %@:%@",kDV_TXT(@"状态"),kDV_TXT(@"在线")];
    //_stateLabel.text = str;
    self.isTcpConnected = YES;
 
//    //初始化设备设置
//    [self initDeviceSetting];
    
    //初始化相机参数设置
    [self initCameraParam];
    
    //连接图传
    [self openRealStream];
}

-(void)initDeviceSetting{
    //关闭录像时间水印
//    [[JLCtpSender sharedInstanced] dvVideoDateSetWithStatus:0];

    //修改心跳包
//    [[JLCtpSender sharedInstanced] dvReSetHeartSend:1 WithTimeOut:1 TimeOutFrequency:8 WithType:YES];//3
    
    //test
    //停掉原有心跳包
    [[JLCtpSender sharedInstanced] dvDidStopSendHeartBeat];
    
    
//  [self getCameraParam];
    
    //初始化相机参数
    //[self initCameraParam];
}

#pragma mark -- 初始化相机参数
-(void)initCameraParam{
    int brt = [UserDefaultsUtil getValueForKey:kBrightnessKey];
    [self doBrightnessChange:brt];
    [self doExposureChange:[UserDefaultsUtil getValueForKey:kExposureKey]];
    [self doContrastChange:[UserDefaultsUtil getValueForKey:kContrastKey]];
    [self doWhiteBalanceChange:[UserDefaultsUtil getValueForKey:kWhiteBalanceKey]];
}

#pragma mark -- 相机参数恢复默认值
-(void)resetCameraParam{
    [self doBrightnessChange:0];
    [self doExposureChange:0];
    [self doContrastChange:256];
    [self doWhiteBalanceChange:0];
}


-(void)dvTcpDisConnectedNotice:(NSNotification *)notice{
    NSLog(@"dvTcpDisConnectedNotice...");
    
    [DFUITools showText:@"连接已断开" onView:self.view delay:3];
    
    //NSString *str = [NSString stringWithFormat:@" %@:%@",kDV_TXT(@"状态"),kDV_TXT(@"离线")];
    //_stateLabel.text = str;
    
    //如果还在录像关闭录像
    if(_noTFisRecording){
        [self stopLocalRecord];
    }
    
    
    if(self.playerView != nil){
        [self.playerView jlRealTimeStreamStop];
    }
    
    //再次断开连接
    //[self destoryAPP];
    
    self.isTcpConnected = NO;
    self.isStreamOpened = NO;
    //主线程判断
    NSLog(@"isMainThread:%d",NSThread.currentThread.isMainThread);

}


-(void)heartPacketIntervalNotice:(NSNotification *)notice{
    NSLog(@"heartPacketIntervalNotice...");

}

-(void)heartPacketResponeNotice:(NSNotification *)notice{
    NSLog(@"heartPacketResponeNotice...");
    self.heartPacketCount = 0;
}

-(void)deviceDescriptionTxtNotice:(NSNotification*)notice{
    NSLog(@"deviceDescriptionTxtNotice...");
    //[self openRealStream];
}

NSDictionary *responseStatusDict;
NSDictionary *flightStatusDict;
bool isSnapShotValid = true;
int handHeldMatchFlag;
int tempRecordFlag = -1;
-(void)genericCmdNote:(NSNotification*)notice {
    NSLog(@"genericCmdNote...");
    NSDictionary *dict = notice.object;
    NSLog(@"kdict count:%d",(int)[dict count]);
    
    NSObject *obj = [dict objectForKey:@"param"];
    if([obj isKindOfClass:[NSDictionary class]]){
        responseStatusDict = (NSDictionary*)[dict objectForKey:@"param"];
        if(responseStatusDict.count >= 7){
            flightStatusDict = responseStatusDict;
            NSString *cmdStr = flightStatusDict[@"D3"];
            if ([cmdStr intValue] == 0x64) {
                return;
            } else if ([cmdStr intValue] == 0x65) {
                int height = [flightStatusDict[@"D16"] intValue] | ([flightStatusDict[@"D17"] intValue] << 8);
                _heightLabel.text = [NSString stringWithFormat:@"Height: %.1fm", height * 0.1f];
                int distance = [flightStatusDict[@"D13"] intValue] | ([flightStatusDict[@"D14"] intValue] << 8);
                _distanceLabel.text = [NSString stringWithFormat:@"Distance: %.1fm", distance * 0.1f];
                int speedV = [flightStatusDict[@"D18"] intValue];
                _speedVLabel.text = [NSString stringWithFormat:@"speed V: %.1fm/s", speedV * 0.1f];
                int speedH = [flightStatusDict[@"D15"] intValue];
                _speedHLabel.text = [NSString stringWithFormat:@"speed H: %.1fm/s", speedH * 0.1f];
                int planet = [flightStatusDict[@"D19"] intValue];
                _planetLabel.text = [NSString stringWithFormat:@"%d", planet];
                int latitude = [flightStatusDict[@"D25"] intValue] | ([flightStatusDict[@"D26"] intValue] << 8) | ([flightStatusDict[@"D27"] intValue] << 16) | ([flightStatusDict[@"D28"] intValue] << 24);
                _eLabel.text = [NSString stringWithFormat:@"E: %.2f", latitude * 0.0000001f];
                int longitude = [flightStatusDict[@"D21"] intValue] | ([flightStatusDict[@"D22"] intValue] << 8) | ([flightStatusDict[@"D23"] intValue] << 16) | ([flightStatusDict[@"D24"] intValue] << 24);
                _nLabel.text = [NSString stringWithFormat:@"N: %.2f", longitude * 0.0000001f];
                int roll = [flightStatusDict[@"D6"] intValue] | ([flightStatusDict[@"D7"] intValue] << 8);
                _rollLabel.text = [NSString stringWithFormat:@"Roll: %.1f", roll * 0.1f];
                int pitch = [flightStatusDict[@"D8"] intValue] | ([flightStatusDict[@"D9"] intValue] << 8);
                _patchLabel.text = [NSString stringWithFormat:@"Pitch: %.1f", pitch * 0.1f];
                int yaw = [flightStatusDict[@"D10"] intValue] | ([flightStatusDict[@"D11"] intValue] << 8);
                _yawLabel.text = [NSString stringWithFormat:@"Yaw: %.1f", yaw * 0.1f];
                int lock = [flightStatusDict[@"D12"] intValue] & 0x0f;
                flyType = ([flightStatusDict[@"D12"] intValue] >> 4) & 0x0f;
                flyStatus = [flightStatusDict[@"D12"] intValue] & 0x0f;
                NSArray * arrFlyType = @[@"", @"悬停模式", @"起飞模式", @"降落模式", @"返航模式",@"航点模式", @"跟随模式", @"环绕模式", @"自稳模式" ];
                NSArray * arrFlyStatus = @[@"已上锁", @"已解锁未起飞", @"已解锁已起飞", @"失控返航", @"一级返航", @"二级返航", @"一键返航", @"低压降落", @"一键降落", @"一键起飞", @"陀螺仪校准", @"磁力计校准"];
                if ((int)flyType >=0 && (int)flyType < arrFlyType.count && (int)flyStatus >= 0 && (int)flyStatus < arrFlyStatus.count) {
                    _stateLabel.text = [NSString stringWithFormat:@"状态：%@ %@", arrFlyType[(int)flyType], arrFlyStatus[(int)flyStatus]];
                }
                
                if (lock == 0) {
                    _lockImageView.image = [UIImage imageNamed:@"锁"];
                } else if (lock == 1 || lock == 2) {
                    _lockImageView.image = [UIImage imageNamed:@"锁1"];
                }
                int battery = [flightStatusDict[@"D29"] intValue];
                if(battery > 40){//满电
                    [_batteryStateView setImage:_batteryImg3];
                    self.isLowBattery = NO;
                }else if(battery == 1){//低压
                    [_batteryStateView setImage:_batteryImg0];
                    self.isLowBattery = YES;
                    if(_noTFisRecording){
                        [self stopLocalRecord];
                    }
                }else if(battery > 36){//两格
                    [_batteryStateView setImage:_batteryImg2];
                    self.isLowBattery = NO;
                }else{//一格
                    [_batteryStateView setImage:_batteryImg1];
                    self.isLowBattery = NO;
                }
                
                return;
            } else if ([cmdStr intValue] == 0xA0) {
                int value = [flightStatusDict[@"D6"] intValue];
                if (value == 0x01) {
                    NSLog(@"拍照。。。");
                    isSnapShotValid = false;
                    
                    [self snapshotBtnClickAction];
                    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(snapShotDelayOperation) userInfo:nil repeats:NO];
                } else if (value == 0x02) {
                    //录像
                    [self hasOneRecordSignal];
                    
                } else if (value == 0x04) {
                    [self hasOneRecordSignal];
                }
                return;
            }
            
            //特殊字节1
            NSString *statusStr1 = flightStatusDict[@"D9"];
            int status1 = [statusStr1 intValue];
            
            //特殊字节3
            NSString *statusStr3 = flightStatusDict[@"D11"];
            int status3 = [statusStr3 intValue];
            
            //手持遥控器对码 Flag = 1
            handHeldMatchFlag = (status3 >> 1) & 1;
            NSLog(@"handHeldMatchFlag:%d",handHeldMatchFlag);
            
            //拍照录像
            uint8_t snapshotFlag = (status1 >> 1) & 1;
            NSLog(@"ljw snapshotFlag：%d",snapshotFlag);
    
            //拍照
            if(snapshotFlag == 1 && isSnapShotValid){
                NSLog(@"拍照。。。");
                isSnapShotValid = false;
                
                [self snapshotBtnClickAction];
                [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(snapShotDelayOperation) userInfo:nil repeats:NO];
            }
            
            //录像
            uint8_t recordFlag = (status1 >> 2) & 1;
            NSLog(@"ljw recordFlag：%d",recordFlag);
            
            //录像方式2
            if(tempRecordFlag == -1){
                tempRecordFlag = recordFlag;
            }
            if(recordFlag != tempRecordFlag){
                [self hasOneRecordSignal];
                tempRecordFlag = recordFlag;
            }
        }
    }
}


-(void)hasOneRecordSignal {
    //排除因遥控关机复位收到的错误信号
    
    if(_noTFisRecording){
        NSLog(@"取消录像...");
        [self stopLocalRecord];
    }else{
        NSLog(@"开始录像...");
        [self startLocalRecord];
    }
}

-(void)snapShotDelayOperation{
    isSnapShotValid = true;
}

//亮度获取命令的回复数据
-(void)brightnessCmdNote:(NSNotification*)notice{
    NSLog(@"brightnessCmdNote...");
    NSDictionary *dict = notice.object;
    NSLog(@"brightnessDict= %@", dict);
    //_cameraParamView.brightnessSlider.value

}

//曝光度获取命令的回复数据
-(void)exposureCmdNote:(NSNotification*)notice{
    NSLog(@"exposureCmdNote...");
    NSDictionary *dict = notice.object;
    NSLog(@"exposureDict= %@", dict);
}

//对比度获取命令的回复数据
-(void)contrastCmdNote:(NSNotification*)notice{
    NSLog(@"contrastCmdNote...");
    NSDictionary *dict = notice.object;
    NSLog(@"contrastDict= %@", dict);
}

//白平衡获取命令的回复数据
-(void)whiteBalanceCmdNote:(NSNotification*)notice{
    NSLog(@"whiteBalanceCmdNote...");
    NSDictionary *dict = notice.object;
    NSLog(@"kdict count:%d",(int)[dict count]);
    NSLog(@"whiteBalanceDict= %@", dict);
}

-(void)deviceInitiativeMsgNote:(NSNotification*)notice{

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if(_noTFisRecording){
        NSLog(@"取消录像...");
        [self stopLocalRecord];
    }
    [DFUITools showText:kDV_TXT(@"内存不足") onView:self.view delay:1.5];
}

- (void)showLockAlertView {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"上锁将导致电机急停，飞机下坠，确定要上锁？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        [[JLCtpSender sharedInstanced] dvGenericCommandWith:[[FlyLockModel new] flylockData: 1] Topic:@"GENERIC_CMD"];
    }
}


- (void)startLocation {
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"无法定位");
        return;
    }
    _locationManager = [[CLLocationManager alloc] init];
    
    //期望的经度
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    
    //认证NSLocationAlwaysUsageDescription
    
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {//位置管理对象中有requestAlwaysAuthorization这个方法
        //运行
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager requestAlwaysAuthorization];
    }
    
    _locationManager.delegate = self;
    
    [_locationManager startUpdatingLocation];
    isJoystickSwitchON = NO;
    [self removeFlyCtrlTimer];
    [self startFlyFollowTimer];
}



//获取经纬度和详细地址

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {

    CLLocation *location = [locations lastObject];
    
    NSLog(@"latitude === %g  longitude === %g",location.coordinate.latitude, location.coordinate.longitude);
    
    latitude = location.coordinate.latitude * 10000000;
    longitude= location.coordinate.longitude * 10000000;
    
}


@end
