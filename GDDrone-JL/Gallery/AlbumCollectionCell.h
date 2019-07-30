//
//  AlbumCollectionCell.h
//  DVRunning16
//
//  Created by jieliapp on 2017/6/27.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *centerImgv;
@property (weak, nonatomic) IBOutlet UIImageView *markimgv;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *videoLabel;

@end
