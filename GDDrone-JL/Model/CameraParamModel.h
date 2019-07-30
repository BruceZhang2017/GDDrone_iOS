//
//  CameraParamModel.h
//  GDDrone-JL
//
//  Created by admin on 2018/12/8.
//  Copyright © 2018 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraParamModel : NSObject

typedef enum{
    WB_DAYLIGHT,
    WB_CLOUNDY,
    WB_TUNGSTEN,
    WB_FLUORESCENT1,
    WB_FLUORESCENT2,
    WB_AUTO,
} WhiteBalance;

@end
