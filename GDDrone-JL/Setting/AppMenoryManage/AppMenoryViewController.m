//
//  AppMenoryViewController.m
//  DVRunning16
//
//  Created by jieliapp on 2017/8/14.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "AppMenoryViewController.h"
#import "PNChart.h"
#import "AppInfoGeneral.h"
#import "SDImageCache.h"


@interface AppMenoryViewController (){

    UIView      *firstView;
    UILabel     *firstLab;
    UILabel     *allLab;
    
    
    
    UIView      *secView;
    PNPieChart  *pieChart;
    NSArray     *charArray;
    
    UIView      *thirdView;
    NSString    *cachePath;
    UIButton    *deleteBtn;
}
@property(nonatomic, weak) UIView *topBarView;          //上部导航栏


@end

@implementation AppMenoryViewController

int navigationBarH = 100;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = kDV_TXT(@"APP存储管理");
//    self.title = @"APP存储管理";
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    CGRect rect = self.navigationController.navigationBar.frame;
//    self.navigationController.navigationBar.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, navigationBarH);
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"headTitleImgv"] forBarMetrics:UIBarMetricsDefault];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gd_back_0"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBtnAction)];
//    self.navigationItem.leftBarButtonItem = leftButton;
    
    [self topBarView];
    
    [self stepUpData];
    [self initWithUI];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor lightGrayColor];
}

int topBarH = 50;
- (UIView *)topBarView {
    
    if (_topBarView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor darkGrayColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        //btn.backgroundColor = kRedColor;
        [view addSubview:btn];
        
        UIImageView *setImaView = [[UIImageView alloc] init];
        [view addSubview:setImaView];
        
        [self.view addSubview:view];
        
        view.frame = CGRectMake(0, 0, kWidth, topBarH);
        [btn setImage:[UIImage imageNamed:@"gd_back_0"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 5, 40, 40);
        setImaView.image = [UIImage imageNamed:@"gd_setting"];
        setImaView.frame = CGRectMake(kWidth / 2 - 25, 5, 40, 40);
        
        _topBarView = view;
    }
    return _topBarView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)back{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
//     [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)leftBtnAction{

    
     [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)stepUpData{
    
    cachePath = nil;
    cachePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    cachePath = [cachePath stringByAppendingPathComponent:@"Medias/Thumbnails"];
    
    NSString *myused = [AppInfoGeneral fileSizeWithPath:cachePath];
    
    
    float center = 0;
    
    if ([myused hasSuffix:@"MB"]) {
        myused = [myused stringByReplacingOccurrencesOfString:@"MB" withString:@""];
        center = [myused floatValue]/1024;
    }else if ([myused hasSuffix:@"GB"]) {
        myused = [myused stringByReplacingOccurrencesOfString:@"GB" withString:@""];
        center = [myused floatValue];
    }else{
        center = 0;
    }
    
    
    
    float left = [AppInfoGeneral usedMemory];
    float total = [AppInfoGeneral availableMemory];
    
    float right = left-center;
    float all = (total-left);
    
    charArray = @[[PNPieChartDataItem dataItemWithValue:all color:PNJLRedColor description:@"GB"],
                  [PNPieChartDataItem dataItemWithValue:right color:PNJLGlayColor description:@"GB"]];
    
}

-(void)initWithUI{
    
    
    

    self.view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:240.0/255.0 alpha:1];
    
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 5+topBarH, self.view.frame.size.width, 50.0)];
    firstView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstView];
    
    firstLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 30)];
    firstLab.font = [UIFont systemFontOfSize:14];
    firstLab.text = kDV_TXT(@"总容量");
    firstLab.textColor = [UIColor darkTextColor];
    [firstView addSubview:firstLab];
    
    
    allLab = [[UILabel alloc] initWithFrame:CGRectMake(firstView.frame.size.width - 100, 10, 85, 30)];
    allLab.textColor = [UIColor darkTextColor];
    allLab.textAlignment = NSTextAlignmentRight;
    allLab.font = [UIFont systemFontOfSize:14];
    double allInt = [AppInfoGeneral availableMemory];
    NSString *allLabtxt = [NSString stringWithFormat:@"%.2fGB",allInt];
    allLab.text = allLabtxt;
    [firstView addSubview:allLab];
    
    
    int secViewH = kHeight - topBarH - 5 - 50 - 5 - 5 -50 -5 ;
    secView = [[UIView alloc] initWithFrame:CGRectMake(0, 60.0+topBarH, self.view.frame.size.width, secViewH)];// 250
    secView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:secView];
    
    pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 85, 10, 170, 170) items:charArray];
    pieChart.descriptionTextFont = [UIFont systemFontOfSize:13];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.showOnlyValues = NO;
    pieChart.showAbsoluteValues = YES;
    pieChart.shouldHighlightSectorOnTouch = NO;
    [pieChart strokeChart];
    [secView addSubview:pieChart];
    
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50.0, secView.frame.size.height - 17.0, 100, 15)];
    [secView addSubview:showView];
    UIImageView *imgv1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 10, 10)];
    imgv1.backgroundColor = PNJLRedColor;
    [showView addSubview:imgv1];
    UILabel *les1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 40, 13)];
    les1.text = kDV_TXT(@"剩余");
    les1.font = [UIFont systemFontOfSize:10];
    les1.textAlignment = NSTextAlignmentLeft;
    [showView addSubview:les1];
    
    UIImageView *imgv2 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 2, 10, 10)];
    imgv2.backgroundColor = PNJLGlayColor;
    [showView addSubview:imgv2];
    UILabel *les2 = [[UILabel alloc] initWithFrame:CGRectMake(64, 1, 40, 13)];
    les2.text = kDV_TXT(@"已使用");
    les2.font = [UIFont systemFontOfSize:10];
    les2.textAlignment = NSTextAlignmentLeft;
    [showView addSubview:les2];
    
    
    
    
    thirdView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - 50 -5 , self.view.frame.size.width, 50.0)];//315.0
    thirdView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:thirdView];
    deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0 , thirdView.frame.size.width, 50.0)];
    [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    NSString *myused = [AppInfoGeneral fileSizeWithPath:cachePath];
    if (!myused) {
        myused = @"0.0MB";
    }
    NSString *deleteTitle = [NSString stringWithFormat:@"%@:%@",kDV_TXT(@"清除缓存"),myused];
    [deleteBtn setTitle:deleteTitle forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [deleteBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    deleteBtn.contentEdgeInsets = UIEdgeInsetsMake(0,-thirdView.frame.size.width+70+75+15, 0, 0);
    [thirdView addSubview:deleteBtn];
    

}



-(void)deleteBtnAction:(UIButton *)sender{
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *contents = [fm contentsOfDirectoryAtPath:cachePath error:nil];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while (filename = [e nextObject]) {
        NSString *rmItem = [cachePath stringByAppendingPathComponent:filename];
        [fm removeItemAtPath:rmItem error:nil];
        
    }
    
    [pieChart removeFromSuperview];
    pieChart = nil;
    [self stepUpData];
    
    
    pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 85, 10, 170, 170) items:charArray];
    pieChart.descriptionTextFont = [UIFont systemFontOfSize:13];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.showOnlyValues = NO;
    pieChart.showAbsoluteValues = YES;
    pieChart.shouldHighlightSectorOnTouch = NO;
    [pieChart strokeChart];
    [secView addSubview:pieChart];
    
    NSString *myused = [AppInfoGeneral fileSizeWithPath:cachePath];
    if (!myused) {
        myused = @"0.0MB";
    }
    NSString *deleteTitle = [NSString stringWithFormat:@"%@:%@",kDV_TXT(@"清除缓存"),myused];
    [deleteBtn setTitle:deleteTitle forState:UIControlStateNormal];
    
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
