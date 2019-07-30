//
//  VersionCheck.m
//  DVRunning16
//
//  Created by jieliapp on 2017/7/10.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "VersionCheck.h"
#import <DFUnits/DFUnits.h>
#import "SDKLib.h"
#import "YHHFtpRequest.h"
#import "LxFTPRequest.h"


@interface VersionCheck()<UIAlertViewDelegate>{

    BOOL    matchVersion;
    UIAlertView *alertNotmatch;
    YHHFtpRequest *ftpManager;
    
}

@end

@implementation VersionCheck

+(instancetype)sharedInstance{
    static VersionCheck *vcMe;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vcMe = [[VersionCheck alloc] init];
    });
    
    return vcMe;
}

-(instancetype)init{

    self = [super init];
    if (self) {
        _hostName = @"cam.jieli.net";
        _userName = @"wifi@baidu.com";
        _password = @"123456";
        matchVersion = YES;
        ftpManager = [[YHHFtpRequest alloc] init];
    }
    return self;
}

-(void)checkVersionMatch{
    
    ftpManager.serversPath = @"cam.jieli.net/firmware/version.json";
    ftpManager.ftpUser = _userName;
    ftpManager.ftpPassword = _password;
    [ftpManager download:NO progress:^(Float32 percent, NSUInteger finishSize) {
        
    } complete:^(id respond, NSError *error) {
        if (error) {
            NSLog(@"ftp error:%@",error);
            return ;
        }
        NSString *path = [DFFile createOn:NSLibraryDirectory MiddlePath:@"DVConfig" File:@"version.json"];
        [DFFile writeData:respond endFile:path];
        NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
        localPath = [localPath stringByAppendingPathComponent:@"/DVConfig/dev_desc.txt"];
        NSDictionary *dict = [self getDictWithPath:path];
        NSDictionary *dict2 = [self getDictWithPath:localPath];
        [self comepareDeviceVersion:dict2 serDict:dict];
        
    }];
}


-(void)downloadFileWithPath{

    
    ftpManager.serversPath = _bfuDownloadPath;
    ftpManager.ftpUser = _userName;
    ftpManager.ftpPassword = _password;
    [ftpManager download:NO progress:^(Float32 percent, NSUInteger finishSize) {
        
    } complete:^(id respond, NSError *error) {
        if (!error) {
            NSString *path = [DFFile createOn:NSLibraryDirectory MiddlePath:@"UPDATE" File:@"JL_AC54.bfu"];
            [DFFile writeData:respond endFile:path];
            NSLog(@"download frimware finish! ==>%@",path);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FTP_W_DL_PKG" object:path];
        }else{
            NSLog(@"ftp error:%@",error);
        }
    }];
}

-(void)updateLoadFile:(NSString *)path{

    
    
//    NSString *fileLenth = [NSString stringWithFormat:@"%lld",[self fileSizeAtPath:path]];
//    NSLog(@"---fileLenth---%@",fileLenth);
//    NSString *toPath = [NSString stringWithFormat:@"%@%s",DV_TCP_ADDRESS,":21/JL_AC54.bfu"];
//    NSLog(@"---toPath---%@",toPath);
////    [[JLCtpSender sharedInstanced] dvDidStopSendHeartBeat];
//    ftpManager.serversPath = toPath;
//    ftpManager.ftpUser = @"FTPX";
//    ftpManager.ftpPassword = @"12345678";
//    ftpManager.localPath = path;
//
//    [ftpManager upload:NO progress:nil complete:^(id respond, NSError *error) {
//        if (error) {
//            NSLog(@"ftp error :%@ %d",error,__LINE__);
//            [ftpManager quit];
//            return ;
//        }
//        [DFNotice post:@"FTP_UPLOAD_OK" Object:nil];
//        [ftpManager quit];
//    }];
    
//    NSString *fileName = [path lastPathComponent];
    NSString *fileName = @"JL_AC54.bfu";
    NSString *FTP_ADDRESS = [NSString stringWithFormat:@"ftp://%@",DV_TCP_ADDRESS];
    LxFTPRequest *request = [LxFTPRequest uploadRequest];
    request.serverURL = [[NSURL URLWithString:FTP_ADDRESS] URLByAppendingPathComponent:fileName];
    request.localFileURL = [NSURL fileURLWithPath:path];
    request.username = @"FTPX";
    request.password = @"12345678";
    request.progressAction = ^(NSInteger totalSize, NSInteger finishedSize, CGFloat finishedPercent) {
        
    };
    request.successAction = ^(__unsafe_unretained Class resultClass, id result) {
        [DFNotice post:@"FTP_UPLOAD_OK" Object:nil];
    };
    request.failAction = ^(CFStreamErrorDomain errorDomain, NSInteger error, NSString *errorDescription) {
        NSLog(@"failed");
    };
    [request start];
}

//单个文件的大小
-(long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [manager attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    return 0;
}






-(NSDictionary *)getDictWithPath:(NSString *)path{

    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"dict:%@",dict);
        return dict;
    }
    
    return nil;
}


#pragma mark <- comepare Version ->
-(void)comepareDeviceVersion:(NSDictionary *)devDict serDict:(NSDictionary *)serDict{

//    NSLog(@"devDcit:%@",devDict);
    NSString *p_path = [[NSBundle mainBundle] pathForResource:@"product_type" ofType:@"plist"];
    NSArray *productArray = [NSArray arrayWithContentsOfFile:p_path];
    
    
    NSString *p_type = devDict[@"product_type"];
    for (NSString *type in productArray) {
        matchVersion = NO;
        if ([p_type isEqual:type]) {
            
            NSArray *versionArray = serDict[p_type];
            NSString *devVersion = devDict[@"firmware_version"];
            devVersion = [devVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            
           [versionArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
               NSString *vers1 = [obj1 stringByReplacingOccurrencesOfString:@"." withString:@""];
               NSString *vers2 = [obj2 stringByReplacingOccurrencesOfString:@"." withString:@""];
               if ([vers1 integerValue]>[vers2 integerValue]) {
                   return NSOrderedDescending;
               }else{
                   return NSOrderedAscending;
               }
           }];
            NSString *ver = [versionArray lastObject];
            ver = [ver stringByReplacingOccurrencesOfString:@"." withString:@""];
            if ([ver integerValue]>[devVersion integerValue]) {
                NSLog(@"版本过低了，可以升级");
                NSString *tagPath = [NSString stringWithFormat:@"%@/firmware/%@/%@/Update Notes.txt",_hostName,p_type,[versionArray lastObject]];
                _bfuDownloadPath = [NSString stringWithFormat:@"%@/firmware/%@/%@/JL_AC54.bfu",_hostName,p_type,[versionArray lastObject]];
                
                ftpManager.serversPath = tagPath;
                
                ftpManager.ftpUser = _userName;
                ftpManager.ftpPassword = _password;
                [ftpManager download:NO
                            progress:^(Float32 percent, NSUInteger finishSize) {
                                 [DFNotice post:@"FTP_PRESENT_DW" Object:@(percent)];
                            } complete:^(id respond, NSError *error) {
                                if (!error) {
                                    NSString *path = [DFFile createOn:NSLibraryDirectory MiddlePath:@"UPDATE" File:@"UpdateNotes.txt"];
                                    [DFFile writeData:respond endFile:path];
                                    NSString *updateNote = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                                    NSLog(@"download UpdateNotes.txt finish! ==>%@",updateNote);
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATENOTES" object:path];
                                }else{
                                    NSLog(@"ftp error:%@_%d",error,__LINE__);
                                }
                                
                            }];
                
            }else{
                
                
                NSLog(@"Version Match!");
                
                
            }
            matchVersion = YES;
            break;
        }
    }
    
    if (matchVersion == NO) {
        [self versionNotMatchView];
    }
}

#pragma mark <- alert 相关->
-(void)versionNotMatchView{

    alertNotmatch = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"VersionNoMach_context", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Confirm_context", nil) otherButtonTitles:nil, nil];
    alertNotmatch.tag = 666;
    
    [alertNotmatch show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 666) {
        
        [self versionNotMatchView];
        
    }
}



@end
