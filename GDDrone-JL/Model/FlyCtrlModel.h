//
//  FlyCtrlModel.h
//  GDDrone-JL
//
//  Created by admin on 2018/7/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 roll pitch yaw取值范围为-1000-1000
 */

@interface FlyCtrlModel : NSObject

/**
 左右移动
 */
@property (nonatomic, assign) int roll;

/**
 前后移动
 */
@property (nonatomic, assign) int pitch;

/**
 偏航
 */
@property (nonatomic, assign) int yaw;

/**
 *  油门
 */
@property (nonatomic,assign) int throttle;


/**
 特殊Byte1
 */
@property (nonatomic,assign) int specialByte_1;

+(instancetype)sharedInstance;

-(NSDictionary*)getFlyCtrlData;

@end
