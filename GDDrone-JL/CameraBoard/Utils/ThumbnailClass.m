//
//  ThumbnailClass.m
//  DVRunning16
//
//  Created by jieliapp on 2017/7/15.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "ThumbnailClass.h"
#import "SDKLib.h"
#import <DFUnits/DFUnits.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface ThumbnailClass(){

    JLFFCodecFrame *ffcodeFrame;
    NSArray *ipcDownloadArray;
}

@end

@implementation ThumbnailClass

-(instancetype)init{

    self = [super init];
    
    if (self) {
        
        ffcodeFrame = [[JLFFCodecFrame alloc] init];
        [self addNote];
        
    }
    
    return self;
}

-(void)downloadWithArray:(NSArray *)downloadArray{
    
    NSLog(@"downloadArray:%@",downloadArray);
    
    [[JLCtpSender sharedInstanced] dvGetMultiFileCoverMap:downloadArray];
    ipcDownloadArray = downloadArray;
    
    
}


-(void)downloadMediasPhotoWithNum:(NSInteger)num{
    
     [[JLMediaSocketer sharedInstance] startToReceiveMediasDataForOne:num];
    
}


/**
 获取视频缩略图

 @param path 视频文件路径
 */
-(void)getVideosThumbnailWith:(NSString *)path{

    
    [ffcodeFrame jlFFonFrameCodeWithVideo:path];
    
}


- (void)addNote{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewVideoSmallImage:) name:JLFFDECODESU object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFailedVideosmallImage:) name:JLFFDECODEFA object:nil];
    
    [DFNotice add:DV_MULTI_COVER_FIGURE Action:@selector(mediaMuLticover:) Own:self];
    [DFNotice add:DV_MEDIADOWNLOAD_OK Action:@selector(mediaVideoFileLoadOK:) Own:self];
    [DFNotice add:DV_ALL_MEDIADOWN_OK Action:@selector(mediaVideoFileAllFinish:) Own:self];
    [DFNotice add:JLFFDECODESU_VIDEO Action:@selector(videojlCodeSucceed:) Own:self];
    [DFNotice add:DV_MEDIASPHOTO_GET Action:@selector(mediasPhotoFileLoadOK:) Own:self];
    [DFNotice add:DV_MEDIASPHOTO_FINISH Action:@selector(mediaVideoFileAllFinish:) Own:self];
    
}


-(void)getNewVideoSmallImage:(NSNotification *)note{
    
    NSDictionary *dict = [note object];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingString:@"/Medias/Thumbnails"];
    path = [path stringByAppendingPathComponent:dict[@"filename"]];
    path = [path stringByReplacingOccurrencesOfString:@".MOV" withString:@".movps"];
    [DFFile createPath:path];
    NSData *data = dict[@"image"];
    [DFFile writeData:data fillFile:path];
    

    
    if ([_delegate respondsToSelector:@selector(getThumbnailPhoto:)]) {
        
        [_delegate getThumbnailPhoto:path];
        
    }
    
    
}


-(void)videojlCodeSucceed:(NSNotification *)note{
    
    NSDictionary *dict = [note object];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingString:@"/video_thum/Thumbnails"];
    path = [path stringByAppendingPathComponent:dict[@"filename"]];
    path = [path stringByReplacingOccurrencesOfString:@".MOV" withString:@".movps"];
    [DFFile createPath:path];
    NSData *data = dict[@"image"];
    [DFFile writeData:data fillFile:path];
    
    
    
    NSArray *pathArray = [[path lastPathComponent] componentsSeparatedByString:@"_"];
    if ([[pathArray lastObject] isEqualToString:@"urgent.movps"]) {
        
    }else{
        
        NSString *newpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *newpath_1 = [newpath stringByAppendingPathComponent:@"device_video"];
        NSString *newpath_2 = [newpath_1 stringByAppendingPathComponent:dict[@"filename"]];
        NSString *newpath_3 = [newpath_2 stringByReplacingOccurrencesOfString:@".movps" withString:@".MOV"];
        int dura = [ffcodeFrame jlFFGetVideoDuration:newpath_3];
        
        NSString *duration = [NSString stringWithFormat:@"_%d.MOV",dura];
        NSString *newpath_4 = [newpath_3 stringByReplacingOccurrencesOfString:@".MOV" withString:duration];
        
        [DFFile renameOldName:newpath_3 NewName:newpath_4];
        
        NSString *path_w = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        path_w = [path_w stringByAppendingString:@"/video_thum/Thumbnails"];
        path_w = [path_w stringByAppendingPathComponent:dict[@"filename"]];
        NSString *duration_w = [NSString stringWithFormat:@"_%d.movps",dura];
        path_w = [path_w stringByReplacingOccurrencesOfString:@".MOV" withString:duration_w];
        [DFFile renameOldName:path NewName:path_w];
        
        
    }
    
    
}

-(void)getFailedVideosmallImage:(NSNotification *)note{
    
    NSDictionary *dict = note.object;

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingString:@"/video_thum/Thumbnails"];
    path = [path stringByAppendingPathComponent:dict[@"filename"]];
    path = [path stringByReplacingOccurrencesOfString:@".MOV" withString:@".movps"];
    [DFFile createPath:path];
    UIImage *img = [UIImage imageNamed:@"ImageLoadFailed"];
    NSData *data = UIImagePNGRepresentation(img);
    [DFFile writeData:data fillFile:path];
    NSLog(@"error:%@ withName:%@",dict[@"err_msg"],dict[@"filename"]);
    
}




-(void)mediaVideoFileLoadOK:(NSNotification *)note{
    
    NSDictionary *dataDict = [note object];
    
    NSDictionary *dict = @{@"height":dataDict[@"height"],@"width":dataDict[@"width"],@"name":dataDict[@"file"]};
    
    if ([dataDict[@"file"] isEqualToString:@"2018_03_21_154330.MOV"]) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        path = [path stringByAppendingString:@"/test.h264"];
        [DFFile createPath:path];
        [DFFile writeData:dataDict[@"iData"] fillFile:path];
    }
    
    [ffcodeFrame jlFFonFrameCodeWith:dataDict[@"iData"] withDict:dict];
  
    
    
}



-(void)mediaMuLticover:(NSNotification *)note{
    
    //    NSLog(@"12345679==>%@",note);
    NSDictionary *baseDict = [note object];
    NSDictionary *parDict = baseDict[@"param"];
    if ([parDict[@"status"] intValue] == 0 && !baseDict[@"errno"]) {
        [[JLMediaSocketer sharedInstance] startToReceiveMediaData:ipcDownloadArray];
        
    }
    
    
}

-(void)mediaVideoFileAllFinish:(NSNotification *)note{

    if ([_delegate respondsToSelector:@selector(getAllThumbnailPhoto:)]) {
        
        [_delegate getAllThumbnailPhoto:note.object];
        
    }
    
}


#pragma mark <- 获取一个视频的多张缩略图 ->

-(void)mediasPhotoFileLoadOK:(NSNotification *)note{
    
    NSDictionary *dataDict = [note object];
    
    NSDictionary *dict = @{@"height":dataDict[@"height"],@"width":dataDict[@"width"],@"name":dataDict[@"file"]};
    
    [ffcodeFrame jlFFonFrameCodeWith:dataDict[@"iData"] withDict:dict];
    
}


@end
