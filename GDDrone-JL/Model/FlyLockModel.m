//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FlyLockModel.m
//  GDDrone-JL
//
//  Created by ANKER on 2019/7/25.
//  Copyright © 2019 admin. All rights reserved.
//
	

#import "FlyLockModel.h"

@implementation FlyLockModel

- (NSDictionary*)flylockData: (unsigned char)value {
    unsigned char serialdata[8];
    serialdata[0] = 0x46;
    serialdata[1] = 0x48;
    serialdata[2] = 0x3c;
    serialdata[3] = 0x67;
    serialdata[4] = 0x01;
    serialdata[5] = 0x00;
    serialdata[6] = value;
    serialdata[7] = [self checkSum:serialdata len:8];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithCapacity:2];
    NSMutableDictionary *sub_data = [NSMutableDictionary dictionaryWithCapacity:8];
    [data setValue:@"PUT" forKey:@"op"];
    
    //十进制形式字符串类型：
    for(int i = 0; i < 8; i++) {
        NSString *key = [NSString stringWithFormat:@"D%d",i];
        NSString *value = [NSString stringWithFormat:@"%d",serialdata[i]];
        [sub_data setValue:value forKey:key];
    }
    
    [data setValue:sub_data forKey:@"param"];
    
    return data;
}

// 长度 功能，数据
-(unsigned char) checkSum: (unsigned char[]) arry len:(int) len {
    unsigned char checkSum = 0x00;
    
    for (int i = 3; i < len - 1; i++) {
        checkSum ^= arry[i] & 0xff;
    }
    
    return checkSum;
}

@end
