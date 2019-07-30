//
//  VersionCheck.h
//  DVRunning16
//
//  Created by jieliapp on 2017/7/10.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol versionCheckDelegate <NSObject>

-(void)downloadProgress:(NSString *)present;


@end

@interface VersionCheck : NSObject

@property(nonatomic,strong)NSString *hostName;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,strong)NSString *bfuDownloadPath;
@property(nonatomic,assign)id<versionCheckDelegate> delegate;


+(instancetype)sharedInstance;
-(void)checkVersionMatch;
-(void)downloadFileWithPath;
-(void)updateLoadFile:(NSString *)path;

@end
