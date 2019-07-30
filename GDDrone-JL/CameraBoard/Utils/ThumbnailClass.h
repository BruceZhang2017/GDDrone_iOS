//
//  ThumbnailClass.h
//  DVRunning16
//
//  Created by jieliapp on 2017/7/15.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//


/*
 // 下载缩略图专用类
 //
 */

#import <Foundation/Foundation.h>

@protocol ThumbnailDelegate <NSObject>

-(void)getThumbnailPhoto:(NSString *)path;

@optional
-(void)getAllThumbnailPhoto:(NSArray *)pathArray;

@end

@interface ThumbnailClass : NSObject

@property(nonatomic,assign) id<ThumbnailDelegate>delegate;


/**
 输入要下载的文件名称
 下载缩略图列表（完整路径）
 @param downloadArray 下载缩略图列表
 */
-(void)downloadWithArray:(NSArray *)downloadArray;


/**
 输入要接收解析的预览图张数

 @param num 数目
 */
-(void)downloadMediasPhotoWithNum:(NSInteger)num;

/**
 获取视频缩略图
 
 @param path 视频文件路径
 */
-(void)getVideosThumbnailWith:(NSString *)path;




@end
