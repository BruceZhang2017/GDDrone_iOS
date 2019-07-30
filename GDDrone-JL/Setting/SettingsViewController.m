//
//  SettingsViewController.m
//  GDDrone-JL
//
//  Created by admin on 2018/12/8.
//  Copyright © 2018 admin. All rights reserved.
//

#import "SettingsViewController.h"
#import "Masonry.h"
#import "Config.h"
#import "AppInfoGeneral.h"
#import "AppMenoryViewController.h"
#import "AboutViewController.h"
#import "WiFiSettingViewController.h"
#import "PDFBrowseViewController.h"
#import "SDKLib.h"
#import "ViewController.h"


@interface SettingsViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
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
    
    NSArray *session_5;
    NSArray *sessionName_5;
}

@property(nonatomic, weak) UIView *topBarView;          //上部导航栏
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithData];
    [self topBarView];
    [self tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.topBarView.mas_bottom);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)initWithData{
    
//    session_0 = @[@"settingImg"];
//    session_1 = @[@"aboutImg",@"helpImg"];
    
//    sessionName_0 = @[kDV_TXT(@"飞机设置")];
//    sessionName_1 = @[kDV_TXT(@"帮助")];
//    sessionName_2 = @[kDV_TXT(@"APP存储管理")];
//    sessionName_3 = @[kDV_TXT(@"关于")];
    
    
        sessionName_0 = @[kDV_TXT(@"WiFi设置")];
        sessionName_1 = @[kDV_TXT(@"存储管理")];
        sessionName_2 = @[kDV_TXT(@"时间水印")];
        sessionName_3 = @[kDV_TXT(@"恢复出厂设置")];
        sessionName_4 = @[kDV_TXT(@"帮助")];
        sessionName_5 = @[kDV_TXT(@"关于")];
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

- (UITableView*)tableView{
    if(_tableView == nil){
        UITableView *tabView = [[UITableView alloc] init];
        tabView.dataSource = self;
        tabView.delegate = self;
        tabView.tableFooterView = [[UIView alloc] init];
        tabView.rowHeight = 50.0;
        tabView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tabView];
        _tableView = tabView;
    }
    return _tableView;
}

- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 0;
//    }
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger session = indexPath.section;
    if (session == 0) {//wifi设置
        //
        ViewController * vc = [ViewController sharedViewController];
        if(!vc.isTcpConnected){
            [DFUITools showText:kDV_TXT(@"WiFi未正常连接") onView:self.view delay:1.5];
            return;
        }
        
        WiFiSettingViewController *wifiSetingVC = [[WiFiSettingViewController alloc] init];
        [self.navigationController pushViewController:wifiSetingVC animated:YES];
    }
    
    if (session == 1) {//存储管理
        AppMenoryViewController *avc = [[AppMenoryViewController alloc] init];
        [self.navigationController pushViewController:avc animated:YES];
    }
    
    if (session == 2) {//时间水印
        
    
    }
    
    if(session == 3){//恢复出厂设置
        ViewController * vc = [ViewController sharedViewController];
        if(!vc.isTcpConnected){
            [DFUITools showText:kDV_TXT(@"WiFi未正常连接") onView:self.view delay:1.5];
            return;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kDV_TXT(@"提示") message:kDV_TXT(@"恢复默认设置") delegate:self cancelButtonTitle:kDV_TXT(@"取消") otherButtonTitles:kDV_TXT(@"确认"), nil];
        alert.delegate = self;
        alert.tag = 1025;
        [alert show];
    }
    
    if(session == 4){//帮助
        PDFBrowseViewController * pdfVC = [[PDFBrowseViewController alloc] init];
        pdfVC.pdfType = PDF_DOCUMENT_TYPE_USER;
        [self.navigationController pushViewController:pdfVC animated:YES];
    }
    
    if(session == 5){//关于
        AboutViewController *aboutvc = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutvc animated:YES];
    }
    
}





#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MIND_CELL"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    
    NSInteger session = indexPath.section;
    if (session == 0) {
        cell.imageView.image = [UIImage imageNamed:session_0[indexPath.row]];
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.textLabel.text = sessionName_0[0];
    }
    if (session == 1) {
        cell.imageView.image = [UIImage imageNamed:session_0[indexPath.row]];
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.textLabel.text = sessionName_1[0];
    }
    
    if (session == 2) {
        cell.imageView.image = [UIImage imageNamed:session_0[indexPath.row]];
        cell.imageView.contentMode = UIViewContentModeCenter;
        
        cell.textLabel.text = sessionName_2[0];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        UISwitch *cellSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-55, 10, 50, 50)];
        cellSwitch.tag = 0;
        NSDictionary *dict = [[JLCtpCaChe sharedInstance] videoDateDict];
        if ([dict[@"dat"] intValue] == 1) {
            [cellSwitch setOn:YES];
        }else{
            [cellSwitch setOn:NO];
        }
        [cellSwitch addTarget:self action:@selector(cellSwitchAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:cellSwitch];
    }
    if (session == 3) {
        cell.imageView.image = [UIImage imageNamed:session_0[indexPath.row]];
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.textLabel.text = sessionName_3[0];
    }
    
    if (session == 4) {
        cell.imageView.image = [UIImage imageNamed:session_0[indexPath.row]];
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.textLabel.text = sessionName_4[0];
    }
    if (session == 5) {
        cell.imageView.image = [UIImage imageNamed:session_0[indexPath.row]];
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.textLabel.text = sessionName_5[0];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    
    return cell;
}

-(void)cellSwitchAction:(UISwitch *)sender{
    
    NSDictionary *tabDict;
    switch (sender.tag) {
        case 0:{
            tabDict = [[JLCtpCaChe sharedInstance] videoDateDict];
            if ([tabDict[@"dat"] intValue] == 0) {
                [[JLCtpSender sharedInstanced] dvVideoDateSetWithStatus:1];
            }else{
                [[JLCtpSender sharedInstanced] dvVideoDateSetWithStatus:0];
            }
        }break;
        case 1:{
            tabDict = [[JLCtpCaChe sharedInstance] photoDateDict];
            if ([tabDict[@"dat"] intValue] == 0) {
                [[JLCtpSender sharedInstanced] dvPhotoDateShowWithStatus:1];
            }else{
                [[JLCtpSender sharedInstanced] dvPhotoDateShowWithStatus:0];
            }
        }break;
        default:
            break;
    }
    
    //断开图传连接，重连
    ViewController * vc = [ViewController sharedViewController];
    [vc stopRealTimeMediaPlay];
    [vc openRealStream];
    
    [DFUITools showText:kDV_TXT(@"设备处理中") onView:self.view delay:1.5];
}


#pragma mark <- AlertViewDelegate ->
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{
            
        }break;
            
        case 1:{
            //恢复默认设置
            //[[JLCtpSender sharedInstanced] dvDefaulteSetWithStatus:1];
            ViewController * vc = [ViewController sharedViewController];
            
            [vc resetCameraParam];
            
            [DFUITools showText:kDV_TXT(@"正在恢复默认设置") onView:self.view delay:2.0];
        }break;
            
        default:
            break;
    }
    
}


@end
