//
//  AlbumTableCell.m
//  DVRunning16
//
//  Created by jieliapp on 2017/6/27.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "AlbumTableCell.h"
#import "AlbumCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "SDKLib.h"
#import <DFUnits/DFUnits.h>
#import "SelectMedia.h"
#import "AppInfoGeneral.h"
#import <IJKMediaFramework/IJKMediaFramework.h>




@interface AlbumTableCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{

    UICollectionView *albunCollection;
    JLFFCodecFrame    *ffcodeFrame;
}
@end


@implementation AlbumTableCell

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
//        [self awakeFromNib];
        self = [[NSBundle mainBundle] loadNibNamed:@"AlbumTableCell"
                                             owner:nil options:nil][0];
        self.frame = frame;
    
        ffcodeFrame = [[JLFFCodecFrame alloc] init];
        
        _selectStatus = NO;
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        CGFloat sw = [UIScreen mainScreen].bounds.size.width/5-4;//3
        flow.itemSize = CGSizeMake(sw, 80.0);
        flow.minimumLineSpacing = 6;
        flow.minimumInteritemSpacing = 2.0;
        
        
        albunCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(2, 0, frame.size.width-4, frame.size.height) collectionViewLayout:flow];
        albunCollection.dataSource = self;
        albunCollection.delegate = self;
        albunCollection.backgroundColor = [UIColor clearColor];
        UINib *cellNib = [UINib nibWithNibName:@"AlbumCollectionCell" bundle:nil];
        [albunCollection registerNib:cellNib forCellWithReuseIdentifier:@"AlbumCollectionCell"];
        albunCollection.scrollEnabled = NO;
        [self addSubview:albunCollection];
        
    }
    
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithFrame:(CGRect)frame {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = frame;
        
        ffcodeFrame = [[JLFFCodecFrame alloc] init];
        
        _selectStatus = NO;
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        //设置cell宽高
//        CGFloat sw = [UIScreen mainScreen].bounds.size.width/3-4;
        CGFloat sw = [UIScreen mainScreen].bounds.size.width/5-4;
        flow.itemSize = CGSizeMake(sw, 80.0);
        
        flow.minimumLineSpacing = 6;
        flow.minimumInteritemSpacing = 2.0;
        
        
        
        albunCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(2, 0, self.frame.size.width-4, self.frame.size.height) collectionViewLayout:flow];
        albunCollection.dataSource = self;
        albunCollection.delegate = self;
        albunCollection.backgroundColor = [UIColor clearColor];
        UINib *cellNib = [UINib nibWithNibName:@"AlbumCollectionCell" bundle:nil];
        [albunCollection registerNib:cellNib forCellWithReuseIdentifier:@"AlbumCollectionCell"];
        albunCollection.scrollEnabled = NO;
        [self addSubview:albunCollection];
        
    }
    return self;
    
}

-(void)reloadViewData{
    //[albunCollection updateConstraints];
    [albunCollection reloadData];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _collectionArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    AlbumCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumCollectionCell" forIndexPath:indexPath];
    if (_selectStatus == NO) {
        
        cell.markimgv.hidden = YES;
        
    }else{
        cell.markimgv.hidden = NO;
    }
    
    if (_type == PICTURE_ALBUM) {
        cell.videoView.hidden = YES;
    }else{
        cell.videoView.hidden = NO;
    }
    
    
    
    NSDictionary *dict =  _collectionArray[indexPath.row];
    
    //判断是否已存在选中行列
    NSArray *selectArray = [[SelectMedia sharedInstance] selectedArray];
    if ([selectArray containsObject:dict[@"f"]]) {
        
        cell.markimgv.image = [UIImage imageNamed:@"album_selected"];
        
    }else{
    
        cell.markimgv.image = [UIImage imageNamed:@"album_unselected"];
        
    }
    
    
    if ([dict[@"f"] hasSuffix:@"JPG"]) {
        cell.videoView.hidden = YES;

        if (dict[@"network"]) {
            
            NSString *imgPath = dict[@"f"];
            NSString *targetPath = [NSString stringWithFormat:@"http://%@:%d/%@",DV_TCP_ADDRESS,DV_HTTP_PORT,imgPath];
            [cell.centerImgv sd_setImageWithURL:[NSURL URLWithString:targetPath] placeholderImage:[UIImage imageNamed:@"imgv_placeholder.png"]];
            cell.centerImgv.contentMode = UIViewContentModeScaleToFill;
            
        }else{
            
            NSString *imagePath = dict[@"f"];
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            path = [path stringByAppendingPathComponent:@"device_image"];
            path = [path stringByAppendingPathComponent:imagePath];
            
            NSData *fileimgData = [NSData dataWithContentsOfFile:path];
            cell.centerImgv.image = [UIImage imageWithData:fileimgData];
            
        }

    }else {
        
        NSString *imagePath = dict[@"f"];
        imagePath = [imagePath lastPathComponent];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        path = [path stringByAppendingString:@"/video_thum/Thumbnails"];
        path = [path stringByAppendingPathComponent:imagePath];
        path = [path stringByReplacingOccurrencesOfString:@".MOV" withString:@".movps"];
        
//        int duration = 0;
        NSString *pathTime = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSArray *a_array = [imagePath componentsSeparatedByString:@"_"];
        NSString *a_str = [a_array lastObject];
        if ([a_str isEqualToString:@"urgent.MOV"]) {
            pathTime = [pathTime stringByAppendingString:@"/urgent_video"];
            NSString *timeStr = [DFTime stringFromSec:10];
            cell.videoLabel.text = timeStr;
            
        }else{
            
            pathTime = [pathTime stringByAppendingString:@"/device_video"];
            int timtLong = [dict[@"d"] intValue];
            uint32_t mytime = timtLong;
            NSString *timeStr = [DFTime stringFromSec:mytime];
            cell.videoLabel.text = timeStr;
        }
        
        pathTime = [pathTime stringByAppendingPathComponent:imagePath];
//        duration = [ffcodeFrame jlFFGetVideoDuration:pathTime]/1000;
        
    
//        UIImage *imgs = [AppInfoGeneral getMovFileFirstImage:path];
        
        NSData *imgdata = [NSData dataWithContentsOfFile:path];

//        cell.centerImgv.image = [UIImage imageNamed:@"imgv_placeholder.png"];
        cell.centerImgv.image = [UIImage imageWithData:imgdata];
        cell.videoView.hidden = NO;
    
    }
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSString *fileName = _collectionArray[indexPath.row][@"f"];
    
    if (_selectStatus == NO) {
        
        if ([_delegate respondsToSelector:@selector(albumDidSelectedForPlay:)]) {
            [_delegate albumDidSelectedForPlay:fileName];
        }
        return;
    }
    
    if (![[[SelectMedia sharedInstance] selectedArray] containsObject:fileName]) {
        
        [[[SelectMedia sharedInstance] selectedArray] addObject:fileName];
        
    }else{
        
        [[[SelectMedia sharedInstance] selectedArray] removeObject:fileName];
        
    }
    
    
    if ([_delegate respondsToSelector:@selector(albumDidSelected:)]) {
        
        [_delegate albumDidSelected:fileName];
        
    }
    

}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
