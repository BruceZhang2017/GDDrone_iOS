//
//  WiFiSettingViewController.m
//  GDDrone-JL
//
//  Created by admin on 2018/12/24.
//  Copyright © 2018 admin. All rights reserved.
//

#import "WiFiSettingViewController.h"
#import "AppInfoGeneral.h"
#import "SDKLib.h"
#import "Masonry.h"
#import "RenameSsidViewController.h"
#import "ResetWiFiPwdViewController.h"

@interface WiFiSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
        NSArray *sessionName;
}

@property (nonatomic,weak) UIView *topBarView;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation WiFiSettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    [self topBarView];
    [self tableView];
}

-(void)initData{
    sessionName = @[kDV_TXT(@"WiFi名称"),kDV_TXT(@"WiFi密码")];
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


#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    if(section == 0){
        RenameSsidViewController *renameSsidVC = [[RenameSsidViewController alloc] init];
        [self.navigationController pushViewController:renameSsidVC animated:NO];
    }
    if(section == 1){
        ResetWiFiPwdViewController *resetWiFiPwdVC = [[ResetWiFiPwdViewController alloc] init];
        [self.navigationController pushViewController:resetWiFiPwdVC animated:NO];
    }
}

#pragma UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deviceCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    NSInteger section = indexPath.section;
    if(section == 0){
        cell.textLabel.text = sessionName[0];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-160, 0, 130, 50)];
        NSString *ssidStr = [AppInfoGeneral currentSSID];
        ssidStr = [ssidStr stringByReplacingOccurrencesOfString:WIFI_PREFIX withString:@""];
        nameLab.text = ssidStr;
        nameLab.textColor = [UIColor lightGrayColor];
        nameLab.textAlignment = NSTextAlignmentRight;
        nameLab.font = [UIFont systemFontOfSize:14];
        [cell addSubview:nameLab];
    }else if(section == 1){
        cell.textLabel.text = sessionName[1];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return cell;
}


#pragma mark <- AlertViewDelegate ->
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{
            
        }break;
            
        case 1:{
            
        }break;
            
        default:
            break;
    }
    
}

@end
