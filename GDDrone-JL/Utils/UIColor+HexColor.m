//
//  UIColor+HexColor.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/28.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    int strLen = (int)[cString length];
    if (strLen != 6 && strLen != 8)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *aString;
    NSString *rString;
    NSString *gString;
    NSString *bString;
    
    if(strLen == 6){
        //a
        aString = @"FF";
        
        //r
        rString = [cString substringWithRange:range];
        
        //g
        range.location = 2;
        gString = [cString substringWithRange:range];
        
        //b
        range.location = 4;
        bString = [cString substringWithRange:range];
    }else if(strLen == 8){
        //a
        range.location = 0;
        aString = [cString substringWithRange:range];
        
        //r
        range.location = 2;
        rString = [cString substringWithRange:range];
        
        //g
        range.location = 4;
        gString = [cString substringWithRange:range];
        
        //b
        range.location = 6;
        bString = [cString substringWithRange:range];
    }
    
    
    // Scan values
    unsigned int a, r, g, b;
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:((float) a / 255.0f)];
}

@end
