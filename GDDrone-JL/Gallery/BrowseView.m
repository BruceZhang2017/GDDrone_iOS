//
//  BrowseView.m
//  DVRunning16
//
//  Created by jieliapp on 2017/9/7.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "BrowseView.h"
#import "UIImageView+WebCache.h"
#import "SDKLib.h"

@interface BrowseView(){

    
    UIPanGestureRecognizer   *panGes;//拖动
    UIPinchGestureRecognizer *pinchGes;//放大/缩小
    UITapGestureRecognizer   *tapGes;//单击
    
    
}

@end

@implementation BrowseView



-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        UIView *myview = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2-self.frame.size.width/3, self.frame.size.width, self.frame.size.width/3*2)];
        [self addSubview:myview];
        
        
        _centerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width/3*2)];
        _centerImg.image = [UIImage imageNamed:@"imgv_placeholder"];
        [myview addSubview:_centerImg];
        
        
        
        panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesTureRecognizer:)];
        [myview addGestureRecognizer:panGes];
        
        pinchGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecogenizer:)];
        [myview addGestureRecognizer:pinchGes];
        
        tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecogenizer:)];
        [self addGestureRecognizer:tapGes];
        
        UITapGestureRecognizer *tmptap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecogenizer:)];
        [_centerImg addGestureRecognizer:tmptap];
        
    }
    
    return self;
    
}

-(void)stepWithImage:(UIImage *)image{

    _centerImg.image = image;
    _centerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2-self.frame.size.width/2, self.frame.size.width, self.frame.size.width)];
    self.hidden = NO;
    
}

-(void)stepWithImageURL:(NSString *)fileName{
    
    NSString *targetPath = [NSString stringWithFormat:@"http://%@:%d/%@",DV_TCP_ADDRESS,DV_HTTP_PORT,fileName];
    
    [_centerImg sd_setImageWithURL:[NSURL URLWithString:targetPath]];
    _centerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2-self.frame.size.width/2, self.frame.size.width, self.frame.size.width)];
    
    
}

-(void)panGesTureRecognizer:(UIPanGestureRecognizer *)recognizer{

    //视图前置操作
    CGPoint point = [recognizer translationInView:self];
    //NSLog(@"%@", NSStringFromCGPoint(translation));
    recognizer.view.center = CGPointMake(recognizer.view.center.x + point.x, recognizer.view.center.y + point.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];

    
}


-(void)pinchGestureRecogenizer:(UIPinchGestureRecognizer *)recognizer{
    
    if (recognizer.state==UIGestureRecognizerStateBegan || recognizer.state==UIGestureRecognizerStateChanged)
        
    {
        
        UIView *view=[recognizer view];
        
        //扩大、缩小倍数
        
        view.transform = CGAffineTransformScale(view.transform, recognizer.scale, recognizer.scale);
        
        recognizer.scale=1;
        
    }

}


-(void)tapGestureRecogenizer:(UITapGestureRecognizer *)tap{
    
    self.hidden = YES;
    _centerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2-self.frame.size.width/2, self.frame.size.width, self.frame.size.width)];

    [self removeFromSuperview];
    
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
    
}





@end
