//
//  AppInfoGeneral.m
//  DVRunning16
//
//  Created by jieliapp on 2017/6/23.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "AppInfoGeneral.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <sys/param.h>
#import <sys/mount.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "SDKLib.h"
#import <LibDV16SDK/LibDV16SDK.h>


@implementation AppInfoGeneral


/**
 获取当前的WiFi——SSID

 @return SSID
 */
+(NSString*)currentSSID{
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    NSDictionary * info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    if (info!=nil) {
        NSString *ssid = [info objectForKey:@"SSID"]; //lowercaseString];
        return ssid;
    }else{
        return nil;
    }
}



+(NSDictionary *)readvfListFiletoDictionary{

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"vf_list.txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (data) {
        NSDictionary *baseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray *baseArray = baseDict[@"file_list"];
        
        NSMutableArray *imageArray = [NSMutableArray array];
        NSMutableArray *videoArray = [NSMutableArray array];
        
        for (NSDictionary *tmpDict in baseArray) {
            if ([tmpDict[@"f"] hasSuffix:@".JPG"]) {
                [imageArray addObject:tmpDict];
            }
            
            if ([tmpDict[@"f"] hasSuffix:@".MOV"]) {
                [videoArray addObject:tmpDict];
            }
        }

        NSDictionary *targetDict =  @{@"video":videoArray,@"image":imageArray};
        
        return targetDict;
    }
    
    return nil;
}

+(NSArray *)readImageFromvfListFiletoArray{

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"vf_list.txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (data) {
        NSDictionary *baseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray *baseArray = baseDict[@"file_list"];
        
        NSMutableArray *imageArray = [NSMutableArray array];

        for (NSDictionary *tmpDict in baseArray) {
            if ([tmpDict[@"f"] hasSuffix:@".JPG"]) {
                [imageArray addObject:tmpDict];
            }
            
        }

        return imageArray;
    }
    
    return nil;
    
}


+(NSArray *)readvfListFiletoArray{
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"vf_list.txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (data) {
        NSDictionary *baseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray *baseArray = baseDict[@"file_list"];
        
        NSMutableArray *imageArray = [NSMutableArray array];
        NSMutableArray *videoArray = [NSMutableArray array];
        
        for (NSDictionary *tmpDict in baseArray) {
            if ([tmpDict[@"f"] hasSuffix:@".JPG"]) {
                [imageArray addObject:tmpDict];
            }
            
            if ([tmpDict[@"f"] hasSuffix:@".MOV"]) {
                [videoArray addObject:tmpDict];
            }
        }
        
//        NSDictionary *targetDict =  @{@"video":videoArray,@"image":imageArray};
        
        return baseArray;
    }
    
    return nil;
}

+(NSMutableArray *)readVfListVideoFileToArray{
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"vf_list.txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (data) {
        NSDictionary *baseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray *baseArray = baseDict[@"file_list"];
        
        NSMutableArray *imageArray = [NSMutableArray array];
        NSMutableArray *videoArray = [NSMutableArray array];
        
        for (NSDictionary *tmpDict in baseArray) {
            if ([tmpDict[@"f"] hasSuffix:@".JPG"]) {
                [imageArray addObject:tmpDict];
            }
            
            if ([tmpDict[@"f"] hasSuffix:@".MOV"]) {
                [videoArray addObject:tmpDict];
            }
        }
        
        
        return videoArray;
        
    }
    
    return nil;
    
}


+(BOOL)deleteVFListDictionaryItems:(NSDictionary *)dict{

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"vf_list.txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (data) {
        
        NSMutableDictionary *baseData = [[NSMutableDictionary alloc] init];
        NSDictionary *tmpDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        [baseData setDictionary:tmpDict];
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        [tmpArray setArray:baseData[@"file_list"]];
        [tmpArray removeObject:dict];
        [baseData setValue:tmpArray forKey:@"file_list"];
        
        NSData *newData = [NSJSONSerialization dataWithJSONObject:baseData options:NSJSONWritingPrettyPrinted error:nil];
        
        [DFFile writeData:newData fillFile:path];
        
    }
    
    return YES;
    
}

+(BOOL)addVfListDictionaryItems:(NSDictionary *)dict{

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"vf_list.txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (data) {
        
        NSMutableDictionary *baseData = [[NSMutableDictionary alloc] init];
        NSDictionary *tmpDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        [baseData setDictionary:tmpDict];
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        [tmpArray setArray:baseData[@"file_list"]];
        [tmpArray addObject:dict];
        [baseData setValue:tmpArray forKey:@"file_list"];
        NSData *newData = [NSJSONSerialization dataWithJSONObject:baseData options:NSJSONWritingPrettyPrinted error:nil];
        [DFFile writeData:newData fillFile:path];
        
    }
    
    return YES;
}

+(BOOL)changeVFListDictionaryItems:(NSDictionary *)dict{

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"vf_list.txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (data) {

        NSMutableDictionary *baseDict = [NSMutableDictionary dictionary];
        NSDictionary *tmpDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        [baseDict setDictionary:tmpDict];
        NSMutableArray *tmpArray = [NSMutableArray array];
        [tmpArray setArray:baseDict[@"file_list"]];
        
        NSInteger changeIndex = 0;
        
        for (int i = 0; i<tmpArray.count; i++) {
            if ([tmpArray[i][@"f"]isEqualToString:dict[@"f"]]) {
                changeIndex = i;
            }
        }
        
        [tmpArray replaceObjectAtIndex:changeIndex withObject:dict];
        [baseDict setValue:tmpArray forKey:@"file_list"];
        
        NSData *newData = [NSJSONSerialization dataWithJSONObject:baseDict options:NSJSONWritingPrettyPrinted error:nil];
    
        [DFFile writeData:newData fillFile:path];
        
    }
    
    return YES;
    
}





+(NSMutableArray *)readMovFilePath{

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"vf_list.txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data) {
        NSDictionary *baseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray *baseArray = baseDict[@"file_list"];
        NSMutableArray *videoArray = [NSMutableArray array];
        
        for (NSDictionary *tmpDict in baseArray) {
        
            if ([tmpDict[@"f"] hasSuffix:@".MOV"]) {
                [videoArray addObject:tmpDict[@"f"]];
            }
        }
        return videoArray;
    }
    
    return nil;
}



/**
 获取当前的视频封面图

 @param urlStr 视频文件路径
 @return UIimage
 */
+(UIImage *)getMovFileFirstImage:(NSString *)urlStr{

    NSURL *videoUrl = [NSURL fileURLWithPath:urlStr];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = 0;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 15) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef) {
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    }
    UIImage *thumbnailImage = nil;
    
    if (thumbnailImageRef) {
        
        thumbnailImage = [UIImage imageWithCGImage:thumbnailImageRef];
        
    }
    

    return thumbnailImage;
}



/**
 有效内存

 @return 有效内存
 */
+ (double)availableMemory{

    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSString *tmpStr = [NSString stringWithFormat:@"%@",[fattributes objectForKey:NSFileSystemSize]];
    return [tmpStr floatValue]/1024.0f/1024/1024;
    
}


/**
 已使用内存

 @return 已使用内存
 */
+ (double)usedMemory{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    

    NSDictionary *fattributes2 = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    
    
    float target = [[fattributes objectForKey:NSFileSystemSize] floatValue] - [[fattributes2 objectForKey:NSFileSystemFreeSize] floatValue];
    
    return target/1024.0/1024.0/1024.0f;
}




/**
 计算文件夹大小

 @param myPath 文件夹路径
 @return 大小
 */
+(NSString *)fileSizeWithPath:(NSString *)myPath
{
    // 总大小
    unsigned long long size = 0;
    NSString *sizeText = nil;
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 文件属性
    NSDictionary *attrs = [mgr attributesOfItemAtPath:myPath error:nil];
    // 如果这个文件或者文件夹不存在,或者路径不正确直接返回0;
    if (attrs == nil) return sizeText;
    if ([attrs.fileType isEqualToString:NSFileTypeDirectory]) { // 如果是文件夹
        // 获得文件夹的大小  == 获得文件夹中所有文件的总大小
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:myPath];
        for (NSString *subpath in enumerator) {
            // 全路径
            NSString *fullSubpath = [myPath stringByAppendingPathComponent:subpath];
            // 累加文件大小
            size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
            
            if (size >= pow(10, 9)) { // size >= 1GB
                sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
            } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
                
                sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];

            } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
                sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
            } else { // 1KB > size
                sizeText = [NSString stringWithFormat:@"%zdB", size];
            }
            
//            sizeText = [NSString stringWithFormat:@"%.2f", size / pow(10, 9)];
            
        }
        return sizeText;
        
    } else { // 如果是文件
        size = attrs.fileSize;
        if (size >= pow(10, 9)) { // size >= 1GB
            sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
        } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
            sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
        } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
            sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
        } else { // 1KB > size
            sizeText = [NSString stringWithFormat:@"%zdB", size];
        }
//         sizeText = [NSString stringWithFormat:@"%.2f", size / pow(10, 9)];
    }
    return sizeText;
}



/**
 记录起键值对

 @param value Value
 @param key key
 */
+ (void)setJLValue:(NSString *)value ForKey:(NSString *)key{

    NSUserDefaults *usdf = [NSUserDefaults standardUserDefaults];
    [usdf setObject:value forKey:key];

}


/**
 根据Key获取Value

 @param key key
 @return Value
 */
+ (NSString *)getValueForKey:(NSString *)key{

    NSUserDefaults *usdf = [NSUserDefaults standardUserDefaults];
    NSString *value = [usdf objectForKey:key];
    return value;
}


/**
 查询从固件所获得的dev_desc.txt配置信息

 @return nsdictionary
 */
+(NSDictionary *)getDevComfigDictionary{

    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *fmDictPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    fmDictPath = [fmDictPath stringByAppendingPathComponent:@"DVConfig"];
    fmDictPath = [fmDictPath stringByAppendingPathComponent:@"dev_desc.txt"];
    if ([fm fileExistsAtPath:fmDictPath]) {
        NSData *data = [NSData dataWithContentsOfFile:fmDictPath];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        return dict;
        
    }else{
        NSString *urlPath = [NSString stringWithFormat:@"http://%@:8080/mnt/spiflash/res/dev_desc.txt",DV_TCP_ADDRESS];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlPath]];
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            return dict;
        }
       
        return nil;
    }
    
}


/**
 对VfList.txt重新排序

 @param baseDict 源数据
 @return 新的排序字典
 */
+(NSDictionary *)vflistReSorting:(NSDictionary *)baseDict{
    
    if (!baseDict) {
        return nil;
    }
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    [tmpArray setArray:baseDict[@"file_list"]];
    
    NSComparator finderSort = ^(id dict_0,id dict_1) {
        NSString *string_0 = dict_0[@"t"];
        NSString *string_1 = dict_1[@"t"];
        if ([string_0 integerValue] < [string_1 intValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if([string_0 integerValue] > [string_1 integerValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }else{
            return (NSComparisonResult)NSOrderedSame;
        }
    };
    
    NSArray *newArray;
    newArray = [tmpArray sortedArrayUsingComparator:finderSort];
    
    NSDictionary *newDict =@{@"file_list":newArray};
    NSData *newData = [NSJSONSerialization dataWithJSONObject:newDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    filePath = [filePath stringByAppendingPathComponent:@"vf_list.txt"];
    
    [DFFile writeData:newData fillFile:filePath];
    
    return newDict;
    
}





@end
