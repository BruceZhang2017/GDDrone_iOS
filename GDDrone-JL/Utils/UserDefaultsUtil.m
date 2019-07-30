//
//  UserDefaultsUtil.m
//  GDDrone-JL
//
//  Created by admin on 2019/1/3.
//  Copyright © 2019 admin. All rights reserved.
//

#import "UserDefaultsUtil.h"

@implementation UserDefaultsUtil
+(void)setValue:(int) value forKey:(NSString*)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:value forKey:key];
}
+(int)getValueForKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return (int)[userDefaults integerForKey:key];
}

+(void)setObject:(id) obj forKey:(NSString*)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:obj forKey:key];
}
+(id)getObjectForKey:(NSString*)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}
@end
