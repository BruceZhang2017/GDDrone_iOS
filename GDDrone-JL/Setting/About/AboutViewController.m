//
//  AboutViewController.m
//  DVRunning16
//
//  Created by jieliapp on 2017/8/22.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "AboutViewController.h"
#import "AppInfoGeneral.h"
#import <ftpKit/ftpKit.h>
#import "VersionCheck.h"
#import "SDKLib.h"
#import "NBLFileExplorer.h"
#import <DFUnits/DFUnits.h>
#import "AppInfoGeneral.h"
#import "ViewController.h"



@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UIImageView *iconImgv;
    UILabel *appVersionLab;
    UILabel *deviceVersionLab;
    
    UITableView *versionTable;
    NSArray     *tabArray;
    NSString * filePath;
    
    BRRequestUpload *uploadFile;
    NSData *uploadData;
}

@property(nonatomic, weak) UIView *topBarView;          //上部导航栏


@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self topBarView];
    

    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:240.0/255.0 alpha:1];
//    tabArray = @[kDV_TXT(@"检查更新"),kDV_TXT(@"上传固件"),kDV_TXT(@"意见反馈")];
//    tabArray = @[kDV_TXT(@"检查更新"),kDV_TXT(@"上传固件")];
    tabArray = @[kDV_TXT(@"上传固件")];

    
    [self setUpUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ctpLocalResponds:) name:@"CTP_LOCAL" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadOver:) name:@"FTP_UPLOAD_OK" object:nil];
    
    
}

- (UIView *)topBarView {
    
    if (_topBarView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor darkGrayColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UIImageView *setImaView = [[UIImageView alloc] init];
        [view addSubview:setImaView];
        
        [self.view addSubview:view];
        
        view.frame = CGRectMake(0, 0, kWidth, 50);
        [btn setImage:[UIImage imageNamed:@"gd_back_0"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 5, 40, 40);
        setImaView.image = [UIImage imageNamed:@"gd_setting"];
        setImaView.frame = CGRectMake(kWidth / 2 - 25, 5, 40, 40);
        
        _topBarView = view;
    }
    return _topBarView;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 本地升级指令回调
-(void)ctpLocalResponds:(NSNotification*)note{
    filePath = [note object];
    NSLog(@"---filePath---%@",filePath);
    [DFUITools showText:kDV_TXT(@"摄像机升级中，请勿断电") onView:self.view delay:20.0];
    [[VersionCheck sharedInstance] updateLoadFile:filePath];
}

#pragma mark <- ftp Notification ->
-(void)uploadOver:(NSNotification *)note{

//    NSFileManager *fm = [NSFileManager defaultManager];
//    [fm removeItemAtPath:filePath error:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [DFUITools showText:kDV_TXT(@"待摄像机重启后，重启APP") onView:self.view delay:5.0];
    });
}

-(void)leftBtnAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



-(void)setUpUI{

    
    iconImgv = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-60, 60, 120, 120)];
    [iconImgv setImage:[UIImage imageNamed:@"gd_icon"]];
    [iconImgv setContentMode:UIViewContentModeCenter];
    [self.view addSubview:iconImgv];
    
    appVersionLab = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-110, 180, 220, 30)];
    appVersionLab.font = [UIFont systemFontOfSize:13];
    appVersionLab.textColor = [UIColor darkTextColor];
    appVersionLab.textAlignment = NSTextAlignmentCenter;
    appVersionLab.text = [NSString stringWithFormat:@"%@：V1.0.0",kDV_TXT(@"软件版本")];
    [self.view addSubview:appVersionLab];
    
    deviceVersionLab = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-110, 240, 220, 30)];
    deviceVersionLab.font = [UIFont systemFontOfSize:13];
    deviceVersionLab.textColor = [UIColor darkTextColor];
    deviceVersionLab.textAlignment = NSTextAlignmentCenter;
    if([self checkUpWifiMatch]==YES){
        NSDictionary *dict = [AppInfoGeneral getDevComfigDictionary];
        if (dict) {
            NSString *versiontext = [NSString stringWithFormat:@"%@：V%@",kDV_TXT(@"固件版本"),dict[@"firmware_version"]];
            deviceVersionLab.text = versiontext;
        }
        [self.view addSubview:deviceVersionLab];
    }
    
    versionTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kHeight-50*3, [UIScreen mainScreen].bounds.size.width, 150)];
    versionTable.backgroundColor = [UIColor clearColor];
    [versionTable setScrollEnabled:NO];
    versionTable.rowHeight = 50;
    versionTable.tableFooterView = [UIView new];
    versionTable.dataSource = self;
    versionTable.delegate = self;
    [self.view addSubview:versionTable];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return tabArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellID = @"CELLID_VERSION";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = tabArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor darkTextColor];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kDV_TXT(@"当前为最新版本") message:nil delegate:nil cancelButtonTitle:kDV_TXT(@"确认") otherButtonTitles:nil, nil];
//        [alert show];
        
        ViewController * vc = [ViewController sharedViewController];
        if(!vc.isTcpConnected){
            [DFUITools showText:kDV_TXT(@"WiFi未正常连接") onView:self.view delay:1.5];
            return;
        }
        
        [[NBLFileExplorer sharedExplorer] presentedByViewController:self];
    }else if(indexPath.row == 1){
//        ViewController * vc = [ViewController sharedViewController];
//        if(!vc.isTcpConnected){
//            [DFUITools showText:kDV_TXT(@"WiFi未正常连接") onView:self.view delay:1.5];
//            return;
//        }
//
//        [[NBLFileExplorer sharedExplorer] presentedByViewController:self];
    }else if(indexPath.row == 2){

//        NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/dvrunning2/id1320743451?l=zh&ls=1&mt=8"];
//        NSURL * url = [NSURL URLWithString:str];
//        [[UIApplication sharedApplication] openURL:url];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
