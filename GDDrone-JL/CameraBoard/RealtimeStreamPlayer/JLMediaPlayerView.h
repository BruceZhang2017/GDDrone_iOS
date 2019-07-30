//
//  JLMediaPlayerView.h
//  DV16Flying
//
//  Created by jieliapp on 2017/5/19.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

@class IJKFFMoviePlayerController;

@interface JLMediaPlayerView : UIView

@property (nonatomic,strong) IJKFFMoviePlayerController *ffmVC;
@property (nonatomic,strong) UIActivityIndicatorView    *animaView;
@property (nonatomic,strong) UIView                     *operationView;
@property (nonatomic,strong) NSURL                      *mediaUrl;
@property (nonatomic,strong) NSString                   *sdpcontext;
@property (nonatomic,strong) NSDictionary               * mediaDict;
@property (nonatomic,assign) NSInteger                  mediaType;
@property (nonatomic,assign) IJKMPMoviePlaybackState    playStatus;
@property (nonatomic,assign) BOOL  isDataPlaying;
@property (nonatomic,assign) int frameRate;

- (instancetype)initWithFrame:(CGRect)frame;


/**
 播放实时流
 
 @param type 前视:0    后视:1
 @param dict 参数字典
 
 视频参数配置：
 
 format: 实时流格式（0：JPEG，1：H264）
 
 w: 实时流宽度
 
 h: 实时流高度
 
 fps: 实时流帧率
 
 net_type 1：UDP 0：TCP 实时流传输类型TCP/UDP
 */
-(void)jlRealTimeMediaPlayWith:(NSInteger) type WithDictionary:(NSDictionary *)dict;


/**
 通过rtsp播放实时流

 @param rtspUrl rtsp地址
 */
-(void)jlRealTimeMediaPlayRTSP:(NSURL *)rtspUrl;


/**
 停止实时流直播
 */
-(void)jlRealTimeStreamStop;



/**
 播放回放内容
 */
-(void)jlPlayBlackMeida;


-(void)onClickPause;

/**
 播放器抓拍
 */
- (UIImage*)snapshotInternalOnIOS7AndLater;


/**
 *  销毁player 的时候需要执行这个方法💥💥💥
 */
-(void)destoryUIView;




@end
