//
//  ResetWiFiPwdViewController.m
//  GDDrone-JL
//
//  Created by admin on 2018/12/24.
//  Copyright © 2018 admin. All rights reserved.
//

#import "ResetWiFiPwdViewController.h"
#import "AppInfoGeneral.h"
#import "SDKLib.h"

@interface ResetWiFiPwdViewController ()<UITextFieldDelegate>{
    UIView *newPswView_0;
    UITextField *pswTxfd_0;
    
    UIView *newPswView_1;
    UITextField *pswTxfd_1;
    int topbarH;
}
@property (nonatomic,weak) UIView *topBarView;

@end

@implementation ResetWiFiPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor lightGrayColor];
    topbarH = 50;
    
    [self topBarView];
    [self stepUpUI];
    
    self.view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:240.0/255.0 alpha:1.0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [pswTxfd_0 becomeFirstResponder];
        
    });
    
    [DFNotice add:DV_AP_SSID_INFO Action:@selector(appssidinfoNote:) Own:self];
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
    [self.navigationController popViewControllerAnimated:NO];
}



-(void)stepUpUI{
    
    newPswView_0 = [[UIView alloc] initWithFrame:CGRectMake(0, topbarH+10, self.view.frame.size.width, 55)];
    newPswView_0.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:newPswView_0];
    
    pswTxfd_0 = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, self.view.frame.size.width-15.0, 45)];
    pswTxfd_0.borderStyle = UITextBorderStyleNone;
    pswTxfd_0.placeholder = kDV_TXT(@"请输入新密码");
    pswTxfd_0.font = [UIFont systemFontOfSize:15.0];
    pswTxfd_0.clearButtonMode = UITextFieldViewModeWhileEditing;
    pswTxfd_0.autocorrectionType = UITextAutocorrectionTypeNo;
    pswTxfd_0.returnKeyType = UIReturnKeyNext;
    pswTxfd_0.keyboardAppearance = UIKeyboardTypeDefault;
    pswTxfd_0.keyboardType = UIKeyboardTypeASCIICapable;
    pswTxfd_0.tag = 0;
    pswTxfd_0.delegate = self;
    
    [newPswView_0 addSubview:pswTxfd_0];
    
    UIImageView *lineVIew = [[UIImageView alloc] initWithFrame:CGRectMake(0, topbarH+65, self.view.frame.size.width, 0.5)];
    lineVIew.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineVIew];
    
    
    newPswView_1 = [[UIView alloc] initWithFrame:CGRectMake(0, topbarH+65.5, self.view.frame.size.width, 55)];
    newPswView_1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:newPswView_1];
    
    pswTxfd_1 = [[UITextField alloc] initWithFrame:CGRectMake(15.0, 5, self.view.frame.size.width-15.0, 45)];
    pswTxfd_1.borderStyle = UITextBorderStyleNone;
    pswTxfd_1.placeholder = kDV_TXT(@"请再次输入新密码");
    pswTxfd_1.font = [UIFont systemFontOfSize:15.0];
    pswTxfd_1.clearButtonMode = UITextFieldViewModeWhileEditing;
    pswTxfd_1.autocorrectionType = UITextAutocorrectionTypeNo;
    pswTxfd_1.returnKeyType = UIReturnKeyDone;
    pswTxfd_1.keyboardAppearance = UIKeyboardTypeDefault;
    pswTxfd_1.keyboardType = UIKeyboardTypeASCIICapable;
    pswTxfd_1.tag = 1;
    pswTxfd_1.delegate = self;
    
    [newPswView_1 addSubview:pswTxfd_1];
    
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
    
    if ([self isMatchRule:pswTxfd_1.text] && [self isMatchRule:pswTxfd_0.text]) {
        if ([pswTxfd_1.text isEqual:pswTxfd_0.text]) {
            
            NSString *ssid = [AppInfoGeneral currentSSID];
            
            [[JLCtpSender sharedInstanced] dvSetAPssidInfoWith:ssid Password:pswTxfd_1.text onStatus:1];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:kDV_TXT(@"设置成功重启APP") delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
        }else{
            [DFUITools showText:kDV_TXT(@"两次密码不一样") onView:self.view delay:1.5];
        }
    }else{
        [DFUITools showText:kDV_TXT(@"错误的格式") onView:self.view delay:1.5];
    }
}

-(void)dismissKeyboardAction{
    
    [pswTxfd_0 endEditing:YES];
    [pswTxfd_1 endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 0) {
        
        if ([self isMatchRule:pswTxfd_0.text]) {
            [pswTxfd_1 becomeFirstResponder];
        }else{
            [DFUITools showText:kDV_TXT(@"错误的格式") onView:self.view delay:1.5];
        }
        
    }else {
        [textField endEditing:YES];
        if ([self isMatchRule:pswTxfd_1.text]) {
            if ([pswTxfd_1.text isEqual:pswTxfd_0.text]) {
                
            }else{
                [DFUITools showText:kDV_TXT(@"两次密码不一样") onView:self.view delay:1.5];
            }
        }
    }
    
    return YES;
}



-(BOOL)isMatchRule:(NSString *)matchStr{
    if (matchStr.length>7 && matchStr.length<16) {
        int k = 0;
        for (int i=0; i<matchStr.length; i++) {
            unichar ch = [matchStr characterAtIndex:i];
            if (0x4E00 <= ch  && ch <= 0x9FA5) {
                k = 1;
            }
        }
        
        if (k==0) {
            return YES;
        }else{
            return NO;
        }
        
    }else if(matchStr.length == 0){
        return YES;
    }
    
    return NO;
    
}

@end
