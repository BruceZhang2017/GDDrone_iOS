//
//  BrowseView.h
//  DVRunning16
//
//  Created by jieliapp on 2017/9/7.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseView : UIView


@property(nonatomic,strong)UIImageView *centerImg;


-(void)stepWithImage:(UIImage *)image;

-(void)stepWithImageURL:(NSString *)fileName;


@end
