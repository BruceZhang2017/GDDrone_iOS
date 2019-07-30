//
//  SelectMedia.h
//  DVRunning16
//
//  Created by jieliapp on 2017/7/7.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectMedia : NSObject

@property (nonatomic,strong) NSMutableArray *selectedArray;
+(instancetype)sharedInstance;


@end
