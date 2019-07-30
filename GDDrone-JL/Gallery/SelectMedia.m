//
//  SelectMedia.m
//  DVRunning16
//
//  Created by jieliapp on 2017/7/7.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "SelectMedia.h"

@implementation SelectMedia

+(instancetype)sharedInstance{

    static SelectMedia *Me;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Me = [[SelectMedia alloc] init];
    });
    
    return Me;
    
}

-(instancetype)init{

    self = [super init];
    if (self) {
        _selectedArray = [NSMutableArray array];
    }
    return self;
}


@end
