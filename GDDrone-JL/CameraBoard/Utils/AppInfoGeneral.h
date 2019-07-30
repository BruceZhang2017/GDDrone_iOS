//
//  AppInfoGeneral.h
//  DVRunning16
//
//  Created by jieliapp on 2017/6/23.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <DFUnits/DFUnits.h>


#define WIFI_PREFIX  @""//GD240 HD_

//多语言
#define kDV_SET(lan)            [DFUITools languageSet:lan]
//#define kDV_TXT(key)            [DFUITools languageText:key Table:@"Localizable"]
#define kDV_TXT(key)            NSLocalizedString(key, nil)
#define kDVLANGUAGE             @"DV_LANGUAGE"
#define kDV_LANGUAGE_CHANGE     @"DV_LANGUAGES_CHANGE"
//一些键值对
#define JL_SAVE_IMG_TO_PHONE  @"SAVE_TO_PHONE"      //保存图片到手机：Value：@"SAVE"/@"UNSAVE"
#define JL_VIDEO_MODEL        @"JL_VIDEO_MODELS"    //摄影模式：Value：@"FULL"/@"WIDTH"
#define JL_VIDEO_RESOLUTION_RATIO @"JL_VIDEO_RESOLUTION_RATIO" //录像分辨率
#define JL_SAVE_DV16_USER_PROTOCOL @"SAVE_DV16_USER_PROTOCOL" //保存勾选用户使用协议的状态
#define JL_WIFI_NAME @"WIFI_NAME" //路由器名字
#define JL_PASSWORD @"PASSWORD" //路由器密码
#define JL_SAVE_STATE @"save_state" //是否保存路由器信息
#define JL_RTS_TYPE @"rts_type" //是否默认为rtsp播放




@interface AppInfoGeneral : NSObject

/**
 获取当前的WiFi——SSID
 
 @return SSID
 */
+(NSString*)currentSSID;


/**
 区分vf_list.txt中的视频和照片

 @return nsdictionary
 */
+(NSDictionary *)readvfListFiletoDictionary;


/**
 读取vf_list.txt中的照片

 @return 照片Array
 */
+(NSArray *)readImageFromvfListFiletoArray;

/**
 读vf_list.txt中的视频

 @return Array
 */
+(NSMutableArray *)readVfListVideoFileToArray;


/**
 删除vf_listFile 中的文件

 @param dict 文件属性字典
 @return 结果
 */
+(BOOL)deleteVFListDictionaryItems:(NSDictionary *)dict;


/**
 修改某vf_list.txt的一项文件属性

 @param dict 文件属性字典
 @return 结果
 */
+(BOOL)changeVFListDictionaryItems:(NSDictionary *)dict;


/**
 增加vf_list.txt的一项内容

 @param dict 文件属性字典
 @return 结果
 */
+(BOOL)addVfListDictionaryItems:(NSDictionary *)dict;

/**
 读取VF_list.txt的视频路径

 @return array
 */
+(NSMutableArray *)readMovFilePath;


/**
 获取当前的视频封面图
 
 @param urlStr 视频文件路径
 @return UIimage
 */
+(UIImage *)getMovFileFirstImage:(NSString *)urlStr;

/**
 有效内存
 
 @return 有效内存
 */
+ (double)availableMemory;

/**
 已使用内存
 
 @return 已使用内存
 */
+ (double)usedMemory;

/**
 计算文件夹大小
 
 @param myPath 文件夹路径
 @return 大小
 */
+(NSString *)fileSizeWithPath:(NSString *)myPath;



/**
 记录起键值对
 
 @param value Value
 @param key key
 */
+ (void)setJLValue:(NSString *)value ForKey:(NSString *)key;
/**
 根据Key获取Value
 
 @param key key
 @return Value
 */
+ (NSString *)getValueForKey:(NSString *)key;

/**
 查询从固件所获得的dev_desc.txt配置信息
 
 @return nsdictionary
 */
+(NSDictionary *)getDevComfigDictionary;


/**
 对VfList.txt重新排序
 
 @param baseDict 源数据
 @return 新的排序字典
 */
+(NSDictionary *)vflistReSorting:(NSDictionary *)baseDict;

@end
