//
//  JLMediaPlayerView.m
//  DV16Flying
//
//  Created by jieliapp on 2017/5/19.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "JLMediaPlayerView.h"
#import "SDKLib.h"
#import <DFUnits/DFUnits.h>
#import "AppInfoGeneral.h"



@interface JLMediaPlayerView(){
    
    NSString            *dataPath;
    NSString            *pcmPath;
    NSTimer             *timeOutTimer;
    
    NSInteger           timeOutAction;
}

@end

@implementation JLMediaPlayerView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self stepUIView];
        
    }
    
    return self;
}


-(void)stepUIView{

    const char *sdp = "tcp://127.0.0.1:1433";
    
    _sdpcontext = [NSString stringWithUTF8String:sdp];
    _operationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:_operationView];
    
    _animaView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 25.0 , self.frame.size.height/2 - 25.0, 50.0, 50.0)];
    [self addSubview:_animaView];
    _animaView.hidden = YES;
    
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
    
    
}



-(void)onClickPlay{
    
    
    [self.ffmVC prepareToPlay];
    
    
}


-(void)onClickPause{
    
    [self.ffmVC pause];
    
}

/**
 设置播放器接下来要播放的SDP
 
 @param sdp sdp
 */
-(void)stepUpPlayerSDP:(NSString *)sdp{
    
    _sdpcontext = sdp;
    
}


/**
 播放实时流
 
 @param type 前视/后视
 @param dict 参数字典
 
 视频参数配置：
 
 format: 实时流格式（0：JPEG，1：H264）
 
 w: 实时流宽度
 
 h: 实时流高度
 
 fps: 实时流帧率
 
 net_type 1：UDP 0：TCP 实时流传输类型TCP/UDP
 */
-(void)jlRealTimeMediaPlayWith:(NSInteger) type WithDictionary:(NSDictionary *)dict{
    
//    //设置流超时时间
//    [[JLMediaStreamManager sharedInstance] jlUdpStreamTimeOut:60];
//    NSLog(@"设置流超时时间");
    
    //启动等待动画
    _animaView.hidden = NO;
    [_animaView startAnimating];
    
    //准备ijk播放器
    //    [self onClickClear];
    [self destoryUIView];
    [self installMovieNotificationObservers];
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [self ijkOptionSet:options];
    
    if (_ffmVC == nil) {
         self.ffmVC = [[IJKFFMoviePlayerController alloc] initWithContentURLString:self.sdpcontext withOptions:options];
        [self.ffmVC prepareToPlay];
    }else{
        [_ffmVC play];
    }
   
    UIView *playerView = [_ffmVC view];
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    playerView.frame = self.bounds;
    [self insertSubview:playerView atIndex:1 ];
    self.autoresizesSubviews = YES;
    NSString *states = [AppInfoGeneral getValueForKey:JL_VIDEO_MODEL];
    if ([states isEqualToString:@"WIDTH"]) {
        self.ffmVC.scalingMode = IJKMPMovieScalingModeAspectFit;
    }else{
        self.ffmVC.scalingMode = IJKMPMovieScalingModeFill;
    }
    
    
//    [self addSubview:self.ffmVC.view];
    
    /*------ 决定是前置还是后置摄像头播放 -------*/
    NSString *k = [AppInfoGeneral getValueForKey:JL_RTS_TYPE];
    if ([k isEqualToString:@"rtsp"]) {
        [self jlRealTimeMediaPlayRTSP:[NSURL URLWithString:@"rtsp://192.168.1.1:554/264_rt/XXX.sd"]];
        return;//
    }

    //准备实时流内容
    int realType = (int)[[JLCtpCaChe sharedInstance] videoStreamType];
    int widthInt = [dict[@"w"] intValue];
    int heightInt = [dict[@"h"] intValue];
    int fpsInt = [dict[@"fps"] intValue];
    _mediaDict = dict;
    _mediaType = type;
    
    
    if (type == MEDIA_FRONT) {
        
        [[JLCtpSender sharedInstanced] dvRealTimeStreamFrontWebcamOpen:realType Width:widthInt Height:heightInt Fps:fpsInt Rate:8000];
        
    }else if (type == MEDIA_POST){
        
        [[JLCtpSender sharedInstanced] dvRealTimeStreamPullWebcamOpen:realType Width:widthInt Height:heightInt Fps:fpsInt Rate:8000];
        
    }
    
    int sample_Rate = [[[JLCtpCaChe sharedInstance] videoPartDict][@"rate"] intValue];
    int sample_fps = [[[JLCtpCaChe sharedInstance] videoPartDict][@"fps"] intValue];
    
//    if ([dict[@"net_type"] isEqualToString:@"0"]) {
//        //TCP传输
//        [[JLMediaStreamManager sharedInstance] jlCreateTCPPlayerWithFps:sample_fps SetRate:sample_Rate SetFrame:CGSizeMake(widthInt, heightInt)];
//    }else{
//        //默认为UDP
//        [[JLMediaStreamManager sharedInstance] jlCreatePlayerWithType:type SetFps:sample_fps SetRate:sample_Rate SetFrame:CGSizeMake(widthInt, heightInt)];
//    }
    
    
    if ([dict[@"net_type"] isEqualToString:@"0"]) {
        //TCP传输
        [[JLMediaStreamManager sharedInstance] jlCreateTCPPlayerWithFps:sample_fps SetRate:sample_Rate SetFrame:CGSizeMake(widthInt, heightInt) StreamType:0];
    }else{
        //默认为UDP
//        [[JLMediaStreamManager sharedInstance] jlCreatePlayerWithType:type SetFps:sample_fps SetRate:sample_Rate SetFrame:CGSizeMake(widthInt, heightInt) StreamType:1];
        //设置流超时时间 60
        [[JLMediaStreamManager sharedInstance] jlCreatePlayerWithType:type SetFps:sample_fps SetRate:sample_Rate SetFrame:CGSizeMake(widthInt, heightInt) StreamType:1 withTimeOut:60];
        NSLog(@"设置流超时时间");
    }
    
    
    [timeOutTimer invalidate];
    timeOutTimer = nil;
    timeOutAction = 0;
    timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeOutCheck) userInfo:nil repeats:YES];
    [timeOutTimer fire];
    
    
}


/**
 通过rtsp播放实时流
 
 @param rtspUrl rtsp地址
 */
-(void)jlRealTimeMediaPlayRTSP:(NSURL *)rtspUrl{
    
  
    //准备ijk播放器
    //[self onClickClear];
    [self destoryUIView];
    [self installMovieNotificationObservers];
    
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
    
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [self ijkOptionSet:options];
    
    self.ffmVC = [[IJKFFMoviePlayerController alloc] initWithContentURL:rtspUrl withOptions:options];
    self.ffmVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.ffmVC.view.frame = self.bounds;
    self.ffmVC.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.ffmVC.shouldAutoplay = YES;
    
    self.autoresizesSubviews = YES;
    [self addSubview:self.ffmVC.view];
    
    [self.ffmVC prepareToPlay];
    
}





/**
 播放回放内容
 */
-(void)jlPlayBlackMeida{
    
    
    //启动等待动画
    _animaView.hidden = NO;
    [_animaView startAnimating];
    
    
    //准备ijk播放器
    [self destoryUIView];
    [self installMovieNotificationObservers];
    
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
    
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [self ijkOptionSet:options];
    
    
    if (_ffmVC == nil) {
        self.ffmVC = [[IJKFFMoviePlayerController alloc] initWithContentURLString:self.sdpcontext withOptions:options];
        [self.ffmVC prepareToPlay];
    }else{
        [_ffmVC play];
    }
    self.ffmVC.scalingMode = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.ffmVC.view.frame = self.bounds;
    self.ffmVC.shouldAutoplay = YES;
    [self.ffmVC setPauseInBackground:YES];
    NSString *states = [AppInfoGeneral getValueForKey:JL_VIDEO_MODEL];
    
    if ([states isEqualToString:@"WIDTH"]) {
        self.ffmVC.scalingMode = IJKMPMovieScalingModeAspectFit;
    }else{
        self.ffmVC.scalingMode = IJKMPMovieScalingModeFill;
    }
    self.autoresizesSubviews = YES;
    
    [self addSubview:self.ffmVC.view];
    
    [_animaView removeFromSuperview];
    _animaView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 25.0 , self.frame.size.height/2 - 25.0, 50.0, 50.0)];
    [self addSubview:_animaView];
    
    [self performSelector:@selector(onClickPlay) withObject:nil afterDelay:0.5];
    
}


-(void)ijkOptionSet:(IJKFFOptions *)options{
    
    
    //开启硬件解码
    NSString *infoValue = [AppInfoGeneral getValueForKey:@"DECODE"];
    if (!infoValue)
        infoValue = @"0";
    [options setPlayerOptionIntValue:[infoValue intValue] forKey:@"videotoolbox"]; //0是软解，1是硬解
    //    [options setPlayerOptionIntValue:1 forKey:@"videotoolbox-async"];
    //    [options setPlayerOptionIntValue:1 forKey:@"videotoolbox-wait-async"];
    //    [options setPlayerOptionIntValue:1 forKey:@"videotoolbox-handle-resolution-change"];
    // 设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推）
//        [options setPlayerOptionIntValue:128 forKey:@"vol"];
    // 最大fps
//    [options setPlayerOptionIntValue:30 forKey:@"max-fps"];
    [options setPlayerOptionIntValue:25 forKey:@"max-fps"];
//    [options setPlayerOptionIntValue:1 forKey:@"vn"];
    //连接超时
    [options setFormatOptionIntValue:30 * 1000 * 1000   forKey:@"timeout"];
    // 跳帧开关，如果cpu解码能力不足，可以设置成5，否则
    // 会引起音视频不同步，也可以通过设置它来跳帧达到倍速播放
    [options setPlayerOptionIntValue:IJK_AVDISCARD_NONREF forKey:@"framedrop"];
    [options setPlayerOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_frame"];
    [options setSwsOptionIntValue:0 forKey:@"sync-av-start"];
    // 指定最大宽度
    
    // 自动转屏开关，
    //    [options setFormatOptionIntValue:0 forKey:@"auto_convert"];
    // 重连次数
    [options setFormatOptionIntValue:100 forKey:@"reconnect"];
    //最大预读缓冲区
    //    [options setPlayerOptionIntValue:1472*44*10 forKey:@"max-buffer-size"];
    //    [options setFormatOptionIntValue:10*1024*1024 forKey:@"max_queue_size"];
    //     [options setPlayerOptionIntValue:1472 forKey:@"min-frames"];
    //设置缓冲大小
    [options setFormatOptionIntValue:2000000 forKey:@"analyzeduration"];
    [options setFormatOptionValue:@"nobuffer" forKey:@"fflags"];
    [options setFormatOptionIntValue:4096 forKey:@"probesize"];
    [options setPlayerOptionIntValue:0 forKey:@"packet-buffering"];
    //    [options setPlayerOptionIntValue:1 forKey:@"flush_packets"];
    //设置最大队列帧数
    [options setPlayerOptionIntValue:3 forKey:@"video-pictq-size"];
    //设置自动准备播放
    [options setPlayerOptionIntValue:1 forKey:@"start-on-prepared"];
    
    [options setPlayerOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_loop_filter"];
    //暂停时，往后读多少帧内容作为缓存
    //    [options setPlayerOptionIntValue:25 forKey:@"min-frames"];
    
    //视频渲染方式
    [options setPlayerOptionValue:@"fcc-i420" forKey:@"overlay-format"];
    
    
    //    options.showHudView   = YES;
    
    
}




-(void)onClickClear{
    [self.ffmVC stop];
}

/**
 停止实时流直播
 */
-(void)jlRealTimeStreamStop{
    //add
    self.playStatus = IJKMPMoviePlaybackStateStopped;
    
    if (!_ffmVC) {
        return;
    }
    
    if (_mediaType == MEDIA_FRONT) {
        
        [[JLCtpSender sharedInstanced] dvRealTimeStreamFrontWebcamClose];
        
    }else if(_mediaType == MEDIA_POST){
        
        [[JLCtpSender sharedInstanced] dvRealTimeStreamPullWebcamClose];
        
    }
    [[JLMediaStreamManager sharedInstance] destoryPlayerManager];
    
    [self removeMovieNotificationObservers];
    
    [self destoryUIView];
    [DFNotice remove:DV_OPEN_RT_STREAM Own:self];
    [DFNotice remove:DV_OPEN_PULL_RT_STREAM Own:self];
    [DFNotice remove:DV_CLOSE_RT_STREAM Own:self];
    [DFNotice remove:DV_CLOSE_PULL_RT_STREAM Own:self];
    
    [timeOutTimer invalidate];
    NSLog(@"timeOutTimerstop:%d",__LINE__);
    timeOutTimer = nil;
    timeOutAction = 0;
}

/**
 *  销毁player 的时候需要执行这个方法💥💥💥
 */
-(void)destoryUIView{

    
    if (!_ffmVC) {
        return;
    }

    [_ffmVC shutdown];
     [_ffmVC.view removeFromSuperview];
    _ffmVC = nil;
    [self removeMovieNotificationObservers];
    
   
    
}


-(void)clearIJKPlayer{
    
    [_ffmVC stop];
    
    
}

-(void)rtspIsBegin:(NSNotification *)note{
    
//    [self onClickPlay];
}

#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_ffmVC];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_ffmVC];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_ffmVC];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_ffmVC];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenWillBeUnActive) name:APP_DV_UNACTIVE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenWillBeActive) name:APP_DV_BEACTIVE object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rtspIsBegin:) name:DV_OPEN_RT_STREAM object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rtspIsBegin:) name:DV_OPEN_PULL_RT_STREAM object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rtspDataVideo:) name:DV_VIDEO_DATA_STREAM object:nil];
        dataPath = [DFFile createOn:NSDocumentDirectory MiddlePath:@"H264" File:@"video.h264"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rtspPcmData:) name:DV_PCM_DATA object:nil];
    //    pcmPath = [DFFile createOn:NSDocumentDirectory MiddlePath:@"PCM" File:@"audio.pcm"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBlackStates:) name:DV_STATES_DATA_B object:nil];
    
}

#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_ffmVC];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_ffmVC];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_ffmVC];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_ffmVC];
    
    [[NSNotificationCenter defaultCenter] removeObserver:APP_DV_UNACTIVE];
    [[NSNotificationCenter defaultCenter] removeObserver:APP_DV_BEACTIVE];
}

#pragma mark <- 通知信息处理 ->
- (void)loadStateDidChange:(NSNotification*)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    
    IJKMPMovieLoadState loadState = _ffmVC.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        dv16logs(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        dv16logs(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
        int tmpState = (int)loadState;
        if(tmpState == 4){
            [_animaView startAnimating];
        }
    } else {
        dv16logs(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}



//播放完成之后的状态返回通知
- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            dv16logs(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            dv16logs(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            dv16logs(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            dv16logs(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}


//准备播放
- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    dv16logs(@"mediaIsPreparedToPlayDidChange\n");
    
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    
    _playStatus = _ffmVC.playbackState;
    
    switch (_ffmVC.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            dv16logs(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_ffmVC.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            dv16logs(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_ffmVC.playbackState);
            [_animaView stopAnimating];
            _animaView.hidden = YES;
            
            [timeOutTimer invalidate];
            timeOutTimer = nil;
            timeOutAction = 0;
            
            //实时流已打开通知
            [[NSNotificationCenter defaultCenter] postNotificationName:DV_RT_STREAM_OPENED object:nil];
            
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            dv16logs(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_ffmVC.playbackState);
            [_animaView startAnimating];
            _animaView.hidden = NO;
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            dv16logs(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_ffmVC.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            dv16logs(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_ffmVC.playbackState);
            break;
        }
        default: {
            dv16logs(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_ffmVC.playbackState);
            break;
        }
    }
}




#pragma mark <- 存储视频数据 ->
-(void)rtspDataVideo:(NSNotification *)note{

    NSData *data = note.object;
    //NSLog(@"data.length:%lu",(unsigned long)data.length);
    self.isDataPlaying = YES;
    
    //帧率统计
    if(self.frameRate < 30)
        self.frameRate ++;
    
    
    
//
//        [DFFile writeData:data endFile:dataPath];
    
}

-(void)rtspPcmData:(NSNotification *)note{
    
    //    NSData *data = note.object;
    //    [DFFile writeData:data endFile:pcmPath];
    
}


-(void)playBlackStates:(NSNotification *)note{
    
    switch ([note.object intValue]) {
        case 1:{
            
            if (_ffmVC.playbackState ==  IJKMPMoviePlaybackStatePaused) {
                break;
            }
            [_ffmVC pause];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self bringSubviewToFront:_animaView];
                _animaView.hidden = NO;
                [_animaView startAnimating];
            });
            
            
        }break;
            
        case 2:{
            if (_ffmVC.playbackState ==  IJKMPMoviePlaybackStatePlaying) {
                break;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_ffmVC play];
                
                _animaView.hidden = YES;
                [_animaView stopAnimating];
            });
            
        }break;
            
            
        default:
            break;
    }
    
}


#pragma mark <- timeOutCheck ->
-(void)timeOutCheck{
    
    timeOutAction ++;
    if (timeOutAction > 3) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"REAL_STREAM_TIMEOUT" object:nil];
        [timeOutTimer invalidate];
        timeOutTimer = nil;
    }
    
}


#pragma mark <- 锁屏、后台处理相关 ->

-(void)screenWillBeUnActive{
    
//    //释放播放器
//    if (_ffmVC) {
//        [_ffmVC shutdown];
//        [_ffmVC.view removeFromSuperview];
////        _ffmVC = nil;
//    }
    [timeOutTimer invalidate];
    timeOutTimer = nil;
    
}

-(void)screenWillBeActive{
    //变得活跃
    //解析包内容
    //    [[JLMediaStreamManager sharedInstance] jlCreatePlayerWithType:_mediaType];
   // self.playStatus = IJKMPMoviePlaybackStatePlaying;
    
}


#pragma mark  播放器抓拍
- (UIImage*)snapshotInternalOnIOS7AndLater
{
    if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    // Render our snapshot into the image context
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    
    // Grab the image from the context
    UIImage *complexViewImage = UIGraphicsGetImageFromCurrentImageContext();
    // Finish using the context
    UIGraphicsEndImageContext();
    
    return complexViewImage;
}



-(void)removeFromSuperview{
    
    //释放解析udp包内容工具
//    [[JLMediaStreamManager sharedInstance] destoryPlayerManager];
    
    if (_ffmVC) {
        [_ffmVC shutdown];
        [_ffmVC.view removeFromSuperview];
//        _ffmVC = nil;
        [self removeMovieNotificationObservers];
    }

    
}




@end

