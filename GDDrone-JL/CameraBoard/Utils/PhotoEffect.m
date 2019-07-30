//
//  PhotoEffect.m
//  
//
//  Created by Mac on 15/12/2.
//
//

#import "PhotoEffect.h"
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>



@interface PhotoEffect(){

    UIView * flashView;
}

@end


@implementation PhotoEffect


-(void)kacha{
    /*--- 拍照声音 ---*/
    AudioServicesPlaySystemSound(1108);
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    
    flashView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    flashView.backgroundColor = [UIColor whiteColor];
    flashView.alpha = 0;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:flashView];
    

    
    [flashView setAlpha:1];
    [UIView beginAnimations:@"flash screen" context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [flashView setAlpha:0.0f];
    [UIView commitAnimations];
    [self performSelector:@selector(removeMe) withObject:nil afterDelay:0.2];
}

-(void)removeMe{
    [flashView removeFromSuperview];
}



@end
