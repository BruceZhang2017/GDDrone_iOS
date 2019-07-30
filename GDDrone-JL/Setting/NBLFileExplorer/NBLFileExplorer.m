//
//  NBLFileExplorer.m
//  NBLFileExplorer
//
//  Created by snb on 16/12/20.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "NBLFileExplorer.h"
#import "NBLFileListViewController.h"
#import "NBLFileListShowViewController.h"

@implementation NBLFileExplorer

+ (instancetype)sharedExplorer
{
    static NBLFileExplorer *fileExplorer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileExplorer = [[self alloc] init];
    });

    return fileExplorer;
}


- (void)presentedByViewController:(UIViewController *)viewController
{
    NBLFileListViewController *fileListVC = [[NBLFileListViewController alloc] init];
//    NBLFileListShowViewController *fileListVC = [[NBLFileListShowViewController alloc] init];
    fileListVC.currentLocation = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];//NSHomeDirectory()
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:fileListVC];
    [viewController presentViewController:nav animated:YES completion:nil];
}

@end
