//
//  UserDefaultsUtil.h
//  GDDrone-JL
//
//  Created by admin on 2019/1/3.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDefaultsUtil : NSObject
+(void)setValue:(int) value forKey:(NSString*)key;
+(int)getValueForKey:(NSString *)key;
+(void)setObject:(id) obj forKey:(NSString*)key;
+(id)getObjectForKey:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
