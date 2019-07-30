//
//  AlbumTableCell.h
//  DVRunning16
//
//  Created by jieliapp on 2017/6/27.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PICTURE_ALBUM,
    VIDEO_ALBUM
} ALBUM_TYPE;

@protocol albumTableCellDelegate <NSObject>

-(void)albumDidSelected:(NSString *)name;
-(void)albumDidSelectedForPlay:(NSString *)name;

@end

@interface AlbumTableCell : UITableViewCell

@property(nonatomic,strong) NSArray *collectionArray;
@property(nonatomic,assign) BOOL    selectStatus;
@property(nonatomic,assign) ALBUM_TYPE type;
@property(nonatomic,assign) id <albumTableCellDelegate> delegate;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithFrame:(CGRect)frame;

-(void)reloadViewData;
@end
