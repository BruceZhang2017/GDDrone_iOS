//
//  UpdateViewController.m
//  DVRunning16
//
//  Created by jieliapp on 2017/7/8.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "UpdateViewController.h"
#import <DFUnits/DFUnits.h>
#import "StatusCell.h"
#import "VersionCheck.h"
#import "SDKLib.h"
#import "AppInfoGeneral.h"

@interface UpdateViewController ()<UITableViewDelegate,UITableViewDataSource>{

    __weak IBOutlet UILabel *statusLab;
    __weak IBOutlet UITableView *statusTableView;
     NSArray *statusArray;
    int     statusIndex;
    float   presentF;
    
    
}

@end

@implementation UpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    statusArray = @[kDV_TXT(@"下载升级包到手机"),kDV_TXT(@"上传升级包到摄像机"),kDV_TXT(@"摄像机升级中，请勿断电"),kDV_TXT(@"待摄像机重启后，重启APP")];
    
    
    
    statusTableView.dataSource = self;
    statusTableView.delegate = self;
    statusTableView.rowHeight = 64.0;
    statusTableView.tableFooterView = [UIView new];
    statusTableView.allowsSelection = NO;
    statusTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [DFNotice add:@"FTP_PRESENT_DW" Action:@selector(progressUpdate:) Own:self];
    [DFNotice add:@"FTP_W_DL_PKG" Action:@selector(bfuDownloadOF:) Own:self];
    [DFNotice add:@"FTP_UPLOAD_OK" Action:@selector(uploadOver:) Own:self];
    statusIndex = 0;
    
    [[VersionCheck sharedInstance] downloadFileWithPath];
 

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return statusArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpgradeCell"];
    if (cell == nil) {
        cell = [[StatusCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    }
    
    statusLab.text = [NSString stringWithFormat:@"%@%@",kDV_TXT(@"正在进行"),statusArray[statusIndex]];
    cell.statusPrg.hidden = YES;
    cell.statusLab.textColor = [UIColor lightGrayColor];
    cell.statusImg.image = [UIImage imageNamed:@"upgradeStatus1"];
    if (indexPath.row == 3) {
         cell.statusImg.image = [UIImage imageNamed:@"upgradeStatus4"];
    }
    cell.statusLab.text = statusArray[indexPath.row];
    
    
    if (indexPath.row<statusIndex) {
        cell.statusImg.image = [UIImage imageNamed:@"upgradeStatus3"];
        cell.statusLab.textColor = [UIColor blackColor];
    }
    
    if (indexPath.row == 0 && statusIndex == 0) {
         cell.statusPrg.hidden = NO;
        [cell.statusPrg setProgress:presentF];
        cell.statusLab.textColor = [UIColor blackColor];
        cell.statusImg.image = [UIImage imageNamed:@"upgradeStatus2"];
    }
    
    if (indexPath.row == 1 && statusIndex == 1) {
        cell.statusPrg.hidden = NO;
        [cell.statusPrg setProgress:presentF];
        cell.statusImg.image = [UIImage imageNamed:@"upgradeStatus2"];
    }
   
    
    
    if (indexPath.row == 2 && statusIndex == 2) {
        cell.statusPrg.hidden = YES;
        cell.statusImg.image = [UIImage imageNamed:@"upgradeStatus2"];
    }
    
    if (indexPath.row == 3 && statusIndex == 3){
    
        cell.statusPrg.hidden = YES;
        cell.statusImg.image = [UIImage imageNamed:@"upgradeStatus4"];
        
    }
    
    
    return cell;
    
}

-(void)updateTableViewStatus{

    statusIndex = 3;
    [statusTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
}


#pragma mark <- ftp Notification ->

-(void)progressUpdate:(NSNotification *)note{
    
    NSString *fStr = [note object];
    presentF = [fStr floatValue];
    [statusTableView reloadData];
    
}

-(void)bfuDownloadOF:(NSNotification *)note{

    NSString *downloadPath = [note object];
    statusIndex = 1;
    [[VersionCheck sharedInstance] updateLoadFile:downloadPath];
    
}

-(void)uploadOver:(NSNotification *)note{

    statusIndex = 2;
    [statusTableView reloadData];
    //重启小机
    //[[JLCtpSender sharedInstanced] dvMakeDeviceReset];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateTableViewStatus];
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{

    return NO;
}

//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
