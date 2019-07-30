//
//  RenameSsidViewController.m
//  GDDrone-JL
//
//  Created by admin on 2018/12/24.
//  Copyright © 2018 admin. All rights reserved.
//

#import "RenameSsidViewController.h"
#import "AppInfoGeneral.h"
#import "SDKLib.h"
#import "Masonry.h"

@interface RenameSsidViewController ()<UITextFieldDelegate>{
    NSArray *sessionName;
    
    UIView  *nameView;
    UILabel *nameLab;
    UITextField *nameTxfd;
    UILabel *tipsLab;
    int topbarH;
}
@property (nonatomic,weak) UIView *topBarView;
@end

@implementation RenameSsidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    [self topBarView];
}

-(void)initData{
    topbarH = 50;
    sessionName = @[kDV_TXT(@"WiFi名称"),kDV_TXT(@"WiFi密码")];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self stepUpUI];
    
    self.view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:240.0/255.0 alpha:1.0];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [nameTxfd becomeFirstResponder];
        
    });
    
    [DFNotice add:DV_AP_SSID_INFO Action:@selector(appssidinfoNote:) Own:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UIView *)topBarView {
    
    if (_topBarView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor darkGrayColor];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:backBtn];
        
        UIImageView *setImaView = [[UIImageView alloc] init];
        [view addSubview:setImaView];
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [saveBtn setTitle:kDV_TXT(@"保存") forState:UIControlStateNormal];
        [view addSubview:saveBtn];
        
        [self.view addSubview:view];
        
        view.frame = CGRectMake(0, 0, kWidth, topbarH);
        [backBtn setImage:[UIImage imageNamed:@"gd_back_0"] forState:UIControlStateNormal];
        backBtn.frame = CGRectMake(0, 5, 40, 40);
        
        setImaView.image = [UIImage imageNamed:@"gd_setting"];
        setImaView.frame = CGRectMake(kWidth / 2 - 25, 5, 40, 40);
        
        saveBtn.frame = CGRectMake(kWidth - 50 , 5, 40, 40);
        
        _topBarView = view;
    }
    return _topBarView;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)stepUpUI{
    
    nameView = [[UIView alloc] initWithFrame:CGRectMake(0, topbarH+10, self.view.frame.size.width, 55)];
    nameView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nameView];
    
    nameLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 140.0, 33)];
    nameLab.textColor = [UIColor blackColor];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont systemFontOfSize:15.0];
    nameLab.text = [NSString stringWithFormat:@"%@",WIFI_PREFIX];
    [nameView addSubview:nameLab];
    
    nameTxfd = [[UITextField alloc] initWithFrame:CGRectMake(145.0, 5, self.view.frame.size.width-145.0, 45)];
    nameTxfd.borderStyle = UITextBorderStyleNone;
    nameTxfd.placeholder = @"name";
    nameTxfd.font = [UIFont systemFontOfSize:15.0];
    nameTxfd.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSString *ssid = [AppInfoGeneral currentSSID];
    ssid = [ssid stringByReplacingOccurrencesOfString:WIFI_PREFIX withString:@""];
    nameTxfd.text = ssid;
    nameTxfd.autocorrectionType = UITextAutocorrectionTypeNo;
    nameTxfd.returnKeyType = UIReturnKeyDone;
    nameTxfd.keyboardAppearance = UIKeyboardTypeDefault;
    nameTxfd.keyboardType = UIKeyboardTypeASCIICapable;
    nameTxfd.delegate = self;
    [nameView addSubview:nameTxfd];
    
    tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(10, topbarH+75, self.view.frame.size.width-20, 30)];
    tipsLab.textColor = [UIColor lightGrayColor];
    tipsLab.textAlignment = NSTextAlignmentLeft;
    tipsLab.font = [UIFont systemFontOfSize:13.0];
    tipsLab.text = kDV_TXT(@"名称限制在个字符");
    [self.view addSubview:tipsLab];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardAction)];
    [self.view addGestureRecognizer:tapGes];
    
}

-(void)appssidinfoNote:(NSNotification *)note{
    NSDictionary *dict = note.object;
    if ([dict[@"op"] isEqualToString:@"NOTIFY"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:kDV_TXT(@"设置成功重启APP") delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)saveBtnAction{
    NSString *txfdStr = [nameTxfd text];
    NSInteger textlength = [self unicodeLengthOfString:txfdStr];
    if (textlength>27 || textlength == 0) {
        [DFUITools showText:kDV_TXT(@"错误的格式") onView:self.view delay:1.5];
        return;
    }
    NSString *tagString = [NSString stringWithFormat:@"%@%@",WIFI_PREFIX,txfdStr];
    [[JLCtpSender sharedInstanced] dvSetAPssidInfoWith:tagString Password:@"" onStatus:1];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:kDV_TXT(@"设置成功重启APP") delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
}

//按照中文两个字符，英文数字一个字符计算字符数
-(NSUInteger) unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 3;
    }
    return asciiLength;
}

#pragma mark -- UITextFieldDelegate
-(void)dismissKeyboardAction{
    [nameTxfd endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField endEditing:YES];
    [self saveBtnAction];
    return YES;
}


@end
