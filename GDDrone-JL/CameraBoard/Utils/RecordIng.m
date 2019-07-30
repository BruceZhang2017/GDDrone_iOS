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
        
        bgImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgImgv.backgroundColor = [UIColor blackColor];
        bgImgv.layer.cornerRadius = 2;
        bgImgv.alpha = 0;
        [self addSubview:bgImgv];
        
        redImgv = [[UIImageView alloc] initWithFrame:CGRectMake(2, frame.size.height/2-10, 20, 20)];
        redImgv.image = [UIImage imageNamed:@"gd_redpoint"];
        [self addSubview:redImgv];
        //12
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(22+2, bgImgv.frame.size.height/2-10, bgImgv.frame.size.width-18, 20)];
//        titleLab.backgroundColor = [UIColor grayColor];
//        titleLab.textColor = [UIColor whiteColor];
        titleLab.textColor = kRecordTimeColor;
        titleLab.font = [UIFont systemFontOfSize:13];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = @"00:00";//REC
        [self addSubview:titleLab];
        
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
