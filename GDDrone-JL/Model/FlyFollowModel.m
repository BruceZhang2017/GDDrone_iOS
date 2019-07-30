//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FlyFollowModel.m
//  GDDrone-JL
//
//  Created by ANKER on 2019/7/26.
//  Copyright © 2019 admin. All rights reserved.
//
	

#import "FlyFollowModel.h"

@implementation FlyFollowModel

- (NSDictionary*)getFlyfollowData: (int)latitude longitude: (int)longitude {
    unsigned char serialdata[15];//13
    serialdata[0] = 0x46;
    serialdata[1] = 0x48;
    //保留Byte
    serialdata[2] = 0x3c;
    serialdata[3] = 0x6d;
    serialdata[4] = 0x08;
    serialdata[5] = 0x00;
    serialdata[6] = latitude & 0xff;
    serialdata[7] = (latitude >> 8) & 0xff;
    serialdata[8] = (latitude >> 16) & 0xff;
    serialdata[9] = (latitude >> 24) & 0xff;
    serialdata[10] = longitude & 0xff;
    serialdata[11] = (longitude >> 8) & 0xff;
    serialdata[12] = (longitude >> 16) & 0xff;
    serialdata[13] = (longitude >> 24) & 0xff;
    serialdata[14] = [self checkSum:serialdata len:15];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithCapacity:2];
    NSMutableDictionary *sub_data = [NSMutableDictionary dictionaryWithCapacity:15];
    [data setValue:@"PUT" forKey:@"op"];
    
    //十进制形式字符串类型：
    for(int i=0;i<15;i++){
        NSString *key = [NSString stringWithFormat:@"D%d",i];
        NSString *value = [NSString stringWithFormat:@"%d",serialdata[i]];
        [sub_data setValue:value forKey:key];
    }
    
    
    [data setValue:sub_data forKey:@"param"];
    NSLog(@"跟随：%@", data);
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
