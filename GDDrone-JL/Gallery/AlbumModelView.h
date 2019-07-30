//
//  AlbumModelView.h
//  DVRunning16
//
//  Created by jieliapp on 2017/6/27.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlbumModeViewDelegate <NSObject>

-(void)selectedFileNameWithItem:(NSString *)fileName;
-(void)selectedFileNameWithItemPlay:(NSString *)fileName;

@end

@interface AlbumModelView : UIView


@property(nonatomic,strong)UITableView *albumTable;
@property(nonatomic,strong)NSDictionary *albumDcit;
@property(nonatomic,assign)BOOL  selectorTag;
@property(nonatomic,assign)id <AlbumModeViewDelegate>delegate;

/**
 设置字典
 
 @param albumDcit 字典
 */
-(void)setAlbumDcit:(NSDictionary *)albumDcit;


@end
