//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FlyFollowModel.h
//  GDDrone-JL
//
//  Created by ANKER on 2019/7/26.
//  Copyright © 2019 admin. All rights reserved.
//
	

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlyFollowModel : NSObject

- (NSDictionary*)getFlyfollowData: (int)latitude longitude: (int)longitude;

@end

NS_ASSUME_NONNULL_END
