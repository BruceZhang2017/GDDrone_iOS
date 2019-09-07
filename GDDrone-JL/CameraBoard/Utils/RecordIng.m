//
//  RecordIng.m
//  DVRunning16
//
//  Created by jieliapp on 2017/7/11.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "RecordIng.h"
#import "UIColor+HexColor.h"
#import <DFUnits/DFUnits.h>
#import "ViewController.h"
#import "Masonry.h"

@interface RecordIng(){

    UIImageView *bgImgv;
    UIImageView *redImgv;
    UILabel *titleLab;
    NSTimer *runTime;
    int   timeInt;
}

@end
@implementation RecordIng

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        bgImgv = [[UIImageView alloc] initWithFrame:CGRectZero];
        bgImgv.backgroundColor = [UIColor blackColor];
        bgImgv.layer.cornerRadius = 2;
        bgImgv.alpha = 0;
        [self addSubview:bgImgv];
        
        [bgImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left);
        }];
        
        redImgv = [[UIImageView alloc] initWithFrame:CGRectZero];
        redImgv.image = [UIImage imageNamed:@"gd_redpoint"];
        [self addSubview:redImgv];
        
        [redImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(2);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        
        //12
        titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLab.textColor = kRecordTimeColor;
        titleLab.font = [UIFont systemFontOfSize:13];
        titleLab.textAlignment = NSTextAlignmentRight;
        titleLab.text = @"00:00";//REC
        [self addSubview:titleLab];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(redImgv.mas_right);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(20);
            make.right.equalTo(self.mas_right).offset(-1);
        }];
        
        
        bgImgv.hidden = YES;
        redImgv.hidden = YES;
        titleLab.hidden = YES;
    }
    
    return self;
    
}


-(void)start{
    bgImgv.hidden = NO;
    redImgv.hidden = NO;
    titleLab.hidden = NO;
    
    [runTime invalidate];
    runTime = nil;
    timeInt = 0;
    
    runTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addTimer) userInfo:nil repeats:YES];
    [runTime fire];
    
}

-(void)addTimer{

    timeInt ++;
    uint32_t k = (uint32_t)timeInt;
    NSString *str = [DFTime stringFromSec:k];
    if (str.length > 5) {
        str = [str substringFromIndex:str.length - 5];
    }
    
    NSLog(@"TimeStr:%@",str);
    titleLab.text = str;
    
    if (bgImgv.isHidden== YES) {
        bgImgv.hidden = NO;
        redImgv.hidden = NO;
        //titleLab.hidden = NO;
    }else{
        bgImgv.hidden = YES;
        redImgv.hidden = YES;
        //titleLab.hidden = YES;
    }
    
    //录像时长限制到3分钟
    if(timeInt > 3 * 60){
        ViewController * vc = [ViewController sharedViewController];
        if(vc.noTFisRecording){
            [vc stopLocalRecord];
            [vc startLocalRecord];
        }
    }
}


-(void)stop{
    
    bgImgv.hidden = YES;
    redImgv.hidden = YES;
    titleLab.hidden = YES;
    [runTime invalidate];
    runTime = nil;
    timeInt = 0;
}


@end
