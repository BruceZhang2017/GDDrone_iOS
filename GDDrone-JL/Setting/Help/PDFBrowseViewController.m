//
//  PDFBrowseViewController.m
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/15.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import "PDFBrowseViewController.h"
#import "UIColor+HexColor.h"
#import "AppInfoGeneral.h"


@interface PDFBrowseViewController ()<UIWebViewDelegate>
@property(nonatomic, weak) UIView *topBarView;          //上部导航栏
/**
 *  pdf浏览器
 */
@property (nonatomic,strong) UIWebView * pdfWebView;

@end

@implementation PDFBrowseViewController

-(UIWebView *)pdfWebView
{
    if (!_pdfWebView) {
        _pdfWebView = [[UIWebView alloc] init];
        _pdfWebView.delegate = self;
    }
    return _pdfWebView;
}

-(void)setPdfType:(PDF_DOCUMENT_TYPE)pdfType
{
    
    _pdfType = pdfType;
    
    NSString * pathFile;

    switch (pdfType) {
            
        case PDF_DOCUMENT_TYPE_USER:
            
            pathFile = [[NSBundle mainBundle] pathForResource:kDV_TXT(@"指南") ofType:@"pdf"];
            break;
            
        case PDF_DOCUMENT_TYPE_PRODUCT:
            
            pathFile = [[NSBundle mainBundle] pathForResource:NSLocalizedString(@"product_manual",@"product_manual_en") ofType:@"pdf"];
            
            break;
            
        default:
            break;
    }
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:pathFile]];
    [self.pdfWebView loadRequest:request];
    
    [self topBarView];
}

- (UIView *)topBarView {
    if (_topBarView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor darkGrayColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UILabel *lb = [[UILabel alloc] init];
        if (self.pdfType == PDF_DOCUMENT_TYPE_USER) {
            
            lb.text = NSLocalizedString(@"quick user manual", @"快速使用手册");
            
        }else if (self.pdfType == PDF_DOCUMENT_TYPE_PRODUCT)
        {
            lb.text = NSLocalizedString(@"product manual", @"产品说明书");
        }
        
        lb.textColor = [UIColor whiteColor];
        lb.textAlignment = NSTextAlignmentCenter;
        
        [view addSubview:lb];
        
        [self.view addSubview:view];
 
        view.frame = CGRectMake(0, 0, kWidth, 50);
        [btn setImage:[UIImage imageNamed:@"gd_back_0"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 5, 40, 40);
        lb.frame = CGRectMake(kWidth / 2 - 50, 0, 300, 50);
        lb.center = view.center;
        lb.font = [UIFont boldSystemFontOfSize:19];
    
        _topBarView = view;
    }
    return _topBarView;
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view addSubview:self.pdfWebView];
    self.view.backgroundColor = [UIColor whiteColor];

}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.pdfWebView.frame = CGRectMake(0, 50, kWidth, kHeight - 50);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"pfd加载完成...");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"pfd加载失败...");
}

@end
