//
//  AppDelegate.m
//  GDDrone-JL
//
//  Created by admin on 2018/7/12.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "AppInfoGeneral.h"
#import "SDKLib.h"
#import "UserDefaultsUtil.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController *vc = [ViewController sharedViewController];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
    _window.rootViewController = nv;
    [_window makeKeyAndVisible];
    
    //第一次启动
    if([UserDefaultsUtil getValueForKey:kIsFirstLaunchKey] != 1){
        [UserDefaultsUtil setValue:1 forKey:kIsFirstLaunchKey];
        [UserDefaultsUtil setValue:0 forKey:kBrightnessKey];
        [UserDefaultsUtil setValue:0 forKey:kExposureKey];
        [UserDefaultsUtil setValue:256 forKey:kContrastKey];
        [UserDefaultsUtil setValue:0 forKey:kWhiteBalanceKey];
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //回来之时将检查WiFi名称是否匹配
    NSString *ssid = [AppInfoGeneral currentSSID];
    if (ssid) {
//        if ([ssid hasPrefix:WIFI_PREFIX]) {
            //连接TCP
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WIFI_SSID_MATCH" object:@0];
            [[JLDV16SDK shareInstanced] setTcpIp:@"192.168.1.1"];
            [[JLCtpSender sharedInstanced] didConnectToAddress:DV_TCP_ADDRESS withPort:DV_TCP_PORT];
//        }else{
//            if (![DV_TCP_ADDRESS isEqual:@"192.168.1.1"]) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"WIFI_SSID_MATCH" object:@0];
//                [[JLCtpSender sharedInstanced] didConnectToAddress:DV_TCP_ADDRESS withPort:DV_TCP_PORT];
//            }else{
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"WIFI_SSID_MATCH" object:@1];
//
//            }
//        }
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WIFI_SSID_MATCH" object:@2];
    }
    //回到前台时，停掉播放器
    [[NSNotificationCenter defaultCenter] postNotificationName:APP_DV_BEACTIVE object:nil];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    
    //退到后台时，断开连接
    [[JLCtpSender sharedInstanced] desConnectedCTP];
    
//    [[SDImageCache sharedImageCache] clearDisk];
//    [[SDImageCache sharedImageCache] clearMemory];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"vf_list.txt"];
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:path error:nil];
    
    //退到后台时，停掉播放器
    [[NSNotificationCenter defaultCenter] postNotificationName:APP_DV_UNACTIVE object:nil];
    
    //释放解析udp包内容工具
    [[JLMediaStreamManager sharedInstance] destoryPlayerManager];
    [[JLMediaPlayBlack sharedInstance] jlMediaPlayBlackOver];
}


@end
