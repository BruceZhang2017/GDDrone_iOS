//
//  LocalPlayerViewController.m
//  DVRunning16
//
//  Created by jieliapp on 2017/8/21.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "LocalPlayerViewController.h"
#import "KRVideoPlayerController.h"

@interface LocalPlayerViewController ()

@property(nonatomic,strong)KRVideoPlayerController *videoController;

@end

@implementation LocalPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playVideoWithURL:_locolPath];
    });
    
    
    
}





- (void)playVideoWithURL:(NSURL *)url
{
    
    if (!self.videoController) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, height/2-width*(9.0/16.0)/2, width, width*(9.0/16.0))];
        
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            
            weakSelf.videoController = nil;
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                [weakSelf.exViewController viewWillAppear:YES];
            }];
            
            
        }];
        [self.videoController showInWindow];
    }
    self.videoController.contentURL = url;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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

@end
