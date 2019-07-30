//
//  MindViewController.m
//  DVRunning16
//
//  Created by jieliapp on 2017/6/23.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "MindViewController.h"
//#import "SettingViewController.h"
//#import "NavViewController.h"
//#import "LangagueViewController.h"
#import "AppInfoGeneral.h"
#import "AppMenoryViewController.h"
//#import "AboutViewController.h"
//#import "APPAdvancedSetting.h"
#import "SDKLib.h"
#import <DFUnits/DFUnits.h>

//#import "MediaDownloadAction.h"
//#import "UserProfileViewController.h"


@interface MindViewController ()<UITableViewDelegate,UITableViewDataSource>{

    UIButton *headTitleBtn;
    UITableView *mindTable;
    
    NSArray *session_0;
    NSArray *sessionName_0;
    
    NSArray *session_1;
    NSArray *sessionName_1;
    
    NSArray *session_2;
    NSArray *sessionName_2;
    
    NSArray *session_3;
    NSArray *sessionName_3;
    
    NSArray *session_4;
    NSArray *sessionName_4;
}

@end

@implementation MindViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initWithData];
    
    
    
    mindTable.dataSource = self;
    mindTable.delegate = self;
    mindTable.tableFooterView = [UIView new];
    mindTable.rowHeight = 50.0;
    mindTable.backgroundColor = [UIColor clearColor];
    
    [DFNotice add:kDV_LANGUAGE_CHANGE Action:@selector(dvLanguageChange) Own:self];
    
}



-(void)initWithData{

//    session_0 = @[@"settingImg"];
//    session_1 = @[@"aboutImg",@"helpImg"];
    
    sessionName_0 = @[kDV_TXT(@"记录仪设置")];
    sessionName_1 = @[kDV_TXT(@"APP存储管理"),kDV_TXT(@"语言")];
    sessionName_2 = @[kDV_TXT(@"保存图片到手机")];
//    sessionName_3 = @[NSLocalizedString(@"AppInfoSet_context", "")];
//    sessionName_0 = @[NSLocalizedString(@"Setting_context", "")];
    sessionName_3 = @[kDV_TXT(@"APP高级设置"),kDV_TXT(@"用户使用协议"),kDV_TXT(@"关于")];
    [headTitleBtn setTitle:kDV_TXT(@"设置") forState:UIControlStateNormal];
    

}

-(void)dvLanguageChange{
    
    [self initWithData];
    [mindTable reloadData];
    
}


#pragma mark <- TableView Delegate ->

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return 0;
    }
    
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return sessionName_0.count;
    }
    if (section == 1) {
        
        return sessionName_1.count;
        
    }
    if (section == 2) {
        return sessionName_2.count;
    }
    if (section == 3) {
        return sessionName_3.count;
    }
    if (section == 4) {
        
        return sessionName_4.count;
        
    }
    
    return 0;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MIND_CELL"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    
    NSInteger session = indexPath.section;
    if (session == 0) {
        cell.imageView.image = [UIImage imageNamed:session_0[indexPath.row]];
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.textLabel.text = sessionName_0[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    if (session == 1) {
        cell.imageView.image = [UIImage imageNamed:session_1[indexPath.row]];
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.textLabel.text = sessionName_1[indexPath.row];
        
    }
    
    if (session == 2) {
        cell.textLabel.text = sessionName_2[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryNone;
        UISwitch *cellSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-55, 10, 50, 50)];
        cellSwitch.tag = indexPath.row;
        NSString * states = [AppInfoGeneral getValueForKey:JL_SAVE_IMG_TO_PHONE];
        if (states && [states isEqualToString:@"SAVE"]) {
            [cellSwitch setOn:YES];
        }else{
            [cellSwitch setOn:NO];
        }
        [cellSwitch addTarget:self action:@selector(cellSwitchAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:cellSwitch];
    }
    if (session == 3) {
        
        cell.textLabel.text = sessionName_3[indexPath.row];
        
    }
    
    if (session == 4) {
        
        cell.textLabel.text = sessionName_4[indexPath.row];
        
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger session = indexPath.section;
    if (session == 0) {
        if ([self checkUpWifiMatch] == NO) {
            
            [DFUITools showText:@"wifi not match!" onView:self.view delay:1.5];
            return;
            
        }
        
        if ([[JLCtpCaChe sharedInstance] isREC_Status] == YES) {
            
            [DFUITools showText:kDV_TXT(@"录像中不可进行设置") onView:self.view delay:1.5];
            return;
        }
        
//        SettingViewController *vc = [[SettingViewController alloc] init];
//        NavViewController *navVC = [[NavViewController alloc] initWithRootViewController:vc];
//
//        [self presentViewController:navVC animated:YES completion:^{
//
//        }];
        
    }
    
    if (session == 1) {
        switch (indexPath.row) {
            case 0:{
//                AppMenoryViewController *avc = [[AppMenoryViewController alloc] init];
//                NavViewController *nav = [[NavViewController alloc] initWithRootViewController:avc];
//                [self presentViewController:nav animated:YES completion:nil];
            
            }break;
            case 1:{
//                LangagueViewController *lvc = [[LangagueViewController alloc] init];
//                NavViewController *nav = [[NavViewController alloc] initWithRootViewController:lvc];
//                [self presentViewController:nav animated:YES completion:nil];
            }break;
                
            default:
                break;
        }
        
    }
    
    if (session == 3) {
        switch (indexPath.row) {
            case 0:{
//                APPAdvancedSetting *avc = [[APPAdvancedSetting alloc] init];
//                NavViewController *nav = [[NavViewController alloc] initWithRootViewController:avc];
//                [self presentViewController:nav animated:YES completion:nil];
            }break;
            case 1:{
//                UserProfileViewController *userProfileViewController = [[UserProfileViewController alloc] init];
//                NavViewController *navVC = [[NavViewController alloc] initWithRootViewController:userProfileViewController];
//                [self presentViewController:navVC animated:YES completion:^{
//                }];
            }break;
            case 2:{
//                AboutViewController *lvc = [[AboutViewController alloc] init];
//                NavViewController *nav = [[NavViewController alloc] initWithRootViewController:lvc];
//                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }
    
}





-(void)cellSwitchAction:(UISwitch *)sender{
    
    NSString *saveStr = [AppInfoGeneral getValueForKey:JL_SAVE_IMG_TO_PHONE];
    
    if (saveStr && [saveStr isEqualToString:@"SAVE"]) {
        
        [AppInfoGeneral setJLValue:@"UNSAVE" ForKey:JL_SAVE_IMG_TO_PHONE];
        
    }else{
        
        [AppInfoGeneral setJLValue:@"SAVE" ForKey:JL_SAVE_IMG_TO_PHONE];
        
    }
    
    
    [mindTable reloadData];
    

}




-(BOOL)checkUpWifiMatch{

    
    NSString *ssid = [AppInfoGeneral currentSSID];
    if (ssid) {
        
        if ([ssid hasPrefix:WIFI_PREFIX] || ![DV_TCP_ADDRESS isEqualToString:@"192.168.1.1"]) {
            
            return YES;
        }else{
            return NO;
        }
        
    }
    
    return NO;
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
