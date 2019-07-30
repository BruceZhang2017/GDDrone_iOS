//
//  FlyCtrlModel.m
//  GDDrone-JL
//
//  Created by admin on 2018/7/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "FlyCtrlModel.h"

static FlyCtrlModel *instance;

@implementation FlyCtrlModel

+(instancetype)sharedInstance{
    if(instance == nil){
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            instance=[[super allocWithZone:NULL]init];
        });
    }
    return instance;
}

//重写allocWithZone:方法，在这里创建唯一的实例(注意线程安全)
+(id)allocWithZone:(struct _NSZone *)zone{
    if(instance == nil){
        instance = [FlyCtrlModel sharedInstance];
    }
    return instance;
}

-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}



-(NSDictionary*)getFlyCtrlData{
    unsigned char serialdata[11];//13
    serialdata[0] = 0x46;
    serialdata[1] = 0x48;
    //保留Byte
    serialdata[2] = 0x3c;
    serialdata[3] = 0x6A;
    serialdata[4] = 0x04;
    serialdata[5] = 0x00;
    //pitch
    serialdata[6] = 256-(_pitch + 1000)*0.128;
    //roll
    serialdata[7] = (_roll + 1000)*0.128;
    //throttle
    serialdata[8] = 256-(_throttle + 1000)*0.128;//256-(valueY+1000)*256/2000;
    //yaw
    serialdata[9] = (_yaw + 1000)*0.128;
    serialdata[10] = [self checkSum:serialdata len:11];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithCapacity:2];
    NSMutableDictionary *sub_data = [NSMutableDictionary dictionaryWithCapacity:11];//13
    [data setValue:@"PUT" forKey:@"op"];
    
    //十进制形式字符串类型：
    for(int i=0;i<11;i++){
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