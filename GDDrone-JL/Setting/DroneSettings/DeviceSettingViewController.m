//
//  DeviceSettingViewController.m
//  GDDrone-JL
//
//  Created by admin on 2018/12/11.
//  Copyright © 2018 admin. All rights reserved.
//

#import "DeviceSettingViewController.h"
#import "SDKLib.h"
#import "AppInfoGeneral.h"
#import "Masonry.h"
#import "ViewController.h"


@interface DeviceSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    NSArray *sessionName;
}

@property (nonatomic,weak) UIView *topBarView;
@property(nonatomic, strong) UITableView *tableView;

@end



@implementation DeviceSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    [self topBarView];
    [self tableView];
}

-(void)initData{
    sessionName = @[kDV_TXT(@"时间水印"),kDV_TXT(@"恢复默认设置")];
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
    if(section == 1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kDV_TXT(@"提示") message:kDV_TXT(@"恢复默认设置") delegate:self cancelButtonTitle:kDV_TXT(@"取消") otherButtonTitles:kDV_TXT(@"确认"), nil];
        alert.delegate = self;
        alert.tag = 1025;
        [alert show];
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
        cell.accessoryType = UITableViewCellAccessoryNone;
        UISwitch *cellSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-55, 10, 50, 50)];
        cellSwitch.tag = indexPath.row;
        NSDictionary *dict = [[JLCtpCaChe sharedInstance] videoDateDict];
        if ([dict[@"dat"] intValue] == 1) {
            [cellSwitch setOn:YES];
        }else{
            [cellSwitch setOn:NO];
        }
        [cellSwitch addTarget:self action:@selector(cellSwitchAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:cellSwitch];
    }else if(section == 1){
        cell.textLabel.text = sessionName[1];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
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
        case 2:{
            if (sender.on == YES) {
                [AppInfoGeneral setJLValue:@"rtsp" ForKey:JL_RTS_TYPE];
            }else{
                [AppInfoGeneral setJLValue:@"rtp" ForKey:JL_RTS_TYPE];
            }
        }break;
        case 3:{
            
            tabDict = [[JLCtpCaChe sharedInstance] boardVoiceDict];
            if ([tabDict[@"bvo"] intValue] == 0) {
                [[JLCtpSender sharedInstanced] dvBoardVoiceSwitch:1];
            }else{
                [[JLCtpSender sharedInstanced] dvBoardVoiceSwitch:0];
            }
            
        }break;
        case 4:{
            
            NSDictionary *dict = [[JLCtpCaChe sharedInstance] videoMicDict];
            if ([dict[@"mic"] intValue] == 0) {
                [[JLCtpSender sharedInstanced] dvVideoRecordMicSetWith:1];
            }else{
                [[JLCtpSender sharedInstanced] dvVideoRecordMicSetWith:0];
            }
            
        }break;
        default:
            break;
    }
    
    
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
            
            NSDictionary *brtDictionary = @{@"op":@"PUT",@"param":@{@"brightness":@"0"}};
            [[JLCtpSender sharedInstanced] dvGenericCommandWith:brtDictionary Topic:@"PHOTO_BRIGHTNESS"];
            vc.cameraParamView.brightnessSlider.value = 0;
            vc.cameraParamView.brightnessValueLab.text = @"0";
            
            NSDictionary *expDictionary = @{@"op":@"PUT",@"param":@{@"exp":@"0"}};
            [[JLCtpSender sharedInstanced] dvGenericCommandWith:expDictionary Topic:@"PHOTO_EXP"];
            vc.cameraParamView.exposureSlider.value = 0;
            vc.cameraParamView.exposureValueLab.text = @"0";
            
            NSDictionary *crtDictionary = @{@"op":@"PUT",@"param":@{@"contrast":@"256"}};
            [[JLCtpSender sharedInstanced] dvGenericCommandWith:crtDictionary Topic:@"PHOTO_CONTRAST"];
            vc.cameraParamView.contrastSlider.value = 256;
            vc.cameraParamView.contrastValueLab.text = @"256";
            
            NSDictionary *wblDictionary = @{@"op":@"PUT",@"param":@{@"wbl":@"0"}};
            [[JLCtpSender sharedInstanced] dvGenericCommandWith:wblDictionary Topic:@"WHITE_BALANCE"];
            vc.cameraParamView.whiteBalanceSlider.value = 0;
            vc.cameraParamView.whiteBalanceValueLab.text = kDV_TXT(@"自动");
            
            [DFUITools showText:kDV_TXT(@"正在恢复默认设置") onView:self.view delay:2.0];
        }break;
            
        default:
            break;
    }
    
}





@end
