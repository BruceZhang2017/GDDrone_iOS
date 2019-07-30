//
//  AlbumViewController.m
//  DVRunning16
//
//  Created by jieliapp on 2017/6/27.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumModelView.h"
#import "AppInfoGeneral.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "JLMediaPlayerView.h"
#import "SDKLib.h"
#import <DFUnits/DFUnits.h>
#import "SelectMedia.h"
#import "LocalPlayerViewController.h"
#import "BrowseView.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface AlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,AlbumModeViewDelegate,UIAlertViewDelegate>{
    
    //topbar
    UIButton *backBtn;
    UIButton *photoBtn;
    UIButton *videoBtn;
    UIButton *selectBtn;
    
    __weak NSLayoutConstraint *videoUbm;
    __weak NSLayoutConstraint *urgentUbm;
    
    __weak NSLayoutConstraint *chooseUbm;
    __weak NSLayoutConstraint *pictureUbm;
    
    UIView *headView;
    
   

    AlbumModelView  *pictureView;
    AlbumModelView  *videoView;
    
    NSArray *viewArray;
    
    JLFFCodecFrame      *ffcodeFrame;
    
    UICollectionView *viewCollection;
    
    //数据
    NSMutableDictionary *imageDict;
    NSMutableDictionary *movDict;
    NSMutableDictionary *urgentDict;
    
    //屏幕宽高
    CGFloat sW;
    CGFloat sH;
    
    int toolbarH;
    int btnW;
    
    
    //选择
    BOOL selectTarget;
    BOOL allSelectTag;
    UIView *titleView;
    UILabel *titleLab;
    UIButton *allBtn;
    UIButton *sExistBtn;
    
    UIView   *bottomView;
    UIButton *shareBtn;
    UIButton *saveBtn;
    UIButton *deleteBtn;
    
    NSIndexPath *nowIndexPath;
    
}

@end

@implementation AlbumViewController
singleton_implementation(AlbumViewController)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ffcodeFrame  = [[JLFFCodecFrame alloc] init];
    
    [self initWithUI];
}

-(void)viewDidAppear:(BOOL)animated{
}

-(void)viewWillAppear:(BOOL)animated{

 
    [self reloadMemory];
    
    [self addNote];
    [self initWithData];
    selectTarget = NO;
    
    
}

-(void)viewDidDisappear:(BOOL)animated{

    selectTarget = NO;
    [[[SelectMedia sharedInstance] selectedArray] removeAllObjects];
    
    [self cleanListMemory];
    
    [self removeNote];
}

#pragma mark <内存优化>
-(void)cleanListMemory{

    [pictureView removeFromSuperview];
    pictureView = nil;
    [videoView removeFromSuperview];
    videoView = nil;
    viewArray = nil;
}

-(void)reloadMemory{
    
    if (viewArray==nil) {
        
        pictureView = [[AlbumModelView alloc] initWithFrame:CGRectMake(0, 0.0, sW, sH - toolbarH)];//-49
        pictureView.delegate = self;
        videoView = [[AlbumModelView alloc] initWithFrame:CGRectMake(0, 0.0, sW, sH - toolbarH)];
        videoView.delegate = self;
        viewArray = @[pictureView,videoView];
    }
}


/**
 初始化选择器UI
 */
-(void)createSelectorUI{

    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sW, toolbarH)];
    [self.view addSubview:titleView];
    titleView.hidden = YES;
    UIImageView *bgimgv = [[UIImageView alloc] initWithFrame:titleView.frame];
//    bgimgv.image = [UIImage imageNamed:@"headTitleImgv"];
    bgimgv.backgroundColor = kRGBColorInteger(50,50,50);
    [titleView addSubview:bgimgv];
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectMake(sW/2-50, 25, 100, 35)];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = [NSString stringWithFormat:@"%@0",kDV_TXT(@"已选")];
    [titleView addSubview:titleLab];
    
    allBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, btnW, 35)];
    [allBtn setTitle:kDV_TXT(@"全选") forState:UIControlStateNormal];
    allBtn.titleLabel.textColor = [UIColor whiteColor];
    allBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    allSelectTag = NO;
    [allBtn addTarget:self action:@selector(allBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:allBtn];
    
    sExistBtn = [[UIButton alloc] initWithFrame:CGRectMake(sW - 50, 25, 40, 35)];
    sExistBtn.titleLabel.textColor = [UIColor whiteColor];
    sExistBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sExistBtn setTitle:kDV_TXT(@"退出") forState:UIControlStateNormal];
    [sExistBtn addTarget:self action:@selector(sExistBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:sExistBtn];
    
    //bottom
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, sH-49, sW, 49)];
    bottomView.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:238.0/255.0 alpha:1];
    [self.view addSubview:bottomView];
    bottomView.hidden = YES;
    
    [self addButtomButtons];
//    CGFloat w = (sW-120)/3;
//    saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(w, 0, 60, 49)];
//    [saveBtn setImage:[UIImage imageNamed:@"saveImg"] forState:UIControlStateNormal];
//    [saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:saveBtn];
//
//    deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(sW-60-w, 0, 60, 49)];
//    [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
//    [bottomView addSubview:deleteBtn];
    
}

-(void)addButtomButtons{
    
    CGFloat sw = bottomView.frame.size.width;
    CGFloat width = sw / 3;
    for (int i = 0; i<3; i++) {
        switch (i) {
            case 0:{
                shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(i*width, 0, width, 49)];
                [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
                [shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [bottomView addSubview:shareBtn];
                
                continue;
            }break;
            case 1:{
                saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(i*width, 0, width, 49)];
                [saveBtn setImage:[UIImage imageNamed:@"saveImg"] forState:UIControlStateNormal];
                [saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [bottomView addSubview:saveBtn];
            }break;
            case 2:{
                deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(i*width, 0, width, 49)];
                [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                [bottomView addSubview:deleteBtn];
                continue;
                
            }break;
            default:
                break;
        }
    }
    
    
}


-(void)initWithUI{

    
    sW = [UIScreen mainScreen].bounds.size.width;
    sH =  [UIScreen mainScreen].bounds.size.height;
    
    toolbarH = 60;
    btnW = 80;
    
    [self initHeadBar];
    
    @autoreleasepool {
        
        pictureView = [[AlbumModelView alloc] initWithFrame:CGRectMake(0, 0.0, sW, sH - toolbarH)];
        pictureView.delegate = self;
        videoView = [[AlbumModelView alloc] initWithFrame:CGRectMake(0, 0.0, sW, sH - toolbarH)];
        videoView.delegate = self;

        viewArray = @[pictureView,videoView];
        
        //流视图
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.itemSize = pictureView.frame.size;
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 0;
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        
        viewCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, sW, sH - toolbarH) collectionViewLayout:flow];
        viewCollection.delegate = self;
        viewCollection.dataSource = self;
        viewCollection.backgroundColor = [UIColor whiteColor];
        [viewCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"AlbumModelView"];
        viewCollection.pagingEnabled = YES;
        [viewCollection setAllowsSelection:NO];
        [self.view addSubview:viewCollection];
        
        
        
        videoUbm.constant = (sW - (50*4))/5;
//        urgentUbm.constant = (sW - (50*4))/5;
        //    chooseUbm.constant = (sW - (50*4))/5;
        pictureUbm.constant = (sW - (50*4))/5;
        
        
        [self initWithData];
        
        [self setBtnColor:photoBtn];
        
        
        [self createSelectorUI];
        
        //设置默认的IndexPath
        CGPoint pInView = CGPointMake(0, 0);
        NSIndexPath *indexPathNow = [viewCollection indexPathForItemAtPoint:pInView];
        nowIndexPath = indexPathNow;
    }
    
    
    [photoBtn setTitle:kDV_TXT(@"图片") forState:UIControlStateNormal];
    [videoBtn setTitle:kDV_TXT(@"视频") forState:UIControlStateNormal];
    [selectBtn setTitle:kDV_TXT(@"选择") forState:UIControlStateNormal];
}


-(void)initHeadBar {
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sW, toolbarH)];
    UIImageView *bgimgv = [[UIImageView alloc] initWithFrame:headView.frame];
    //bgimgv.image = [UIImage imageNamed:@"headTitleImgv"];
    bgimgv.backgroundColor = kRGBColorInteger(50,50,50);
    [headView addSubview:bgimgv];
    
    backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
    
    photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(sW/2 - 20 -btnW, 25, btnW, 35)];
    [photoBtn addTarget:self action:@selector(photoBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:photoBtn];
    
    videoBtn = [[UIButton alloc] initWithFrame:CGRectMake(sW/2 + 20, 25, btnW, 35)];
    [videoBtn addTarget:self action:@selector(videoBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:videoBtn];
    
    selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(sW - btnW, 25, btnW, 35)];
    [selectBtn addTarget:self action:@selector(selectBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:selectBtn];
    
    [self.view addSubview:headView];
}



- (void)initWithData {

    
    if (imageDict) {
        [imageDict removeAllObjects];
    }else{
        imageDict = [NSMutableDictionary dictionary];
    }
    
    if (movDict) {
        [movDict removeAllObjects];
    }else{
        movDict = [NSMutableDictionary dictionary];
    }
    
//    if (urgentDict) {
//        [urgentDict removeAllObjects];
//    }else{
//        urgentDict = [NSMutableDictionary dictionary];
//    }
    
    //获取本地的照片
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"device_image"];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray *imageArray = [fm contentsOfDirectoryAtPath:path error:nil];
    
    
    for (NSString *tmpStr in imageArray) {
        
        if ([tmpStr hasSuffix:@".JPG"] || [tmpStr hasSuffix:@".jpg"]) {
            
            NSString *key = [tmpStr substringWithRange:NSMakeRange(0, 8)];
            NSString *timeStr = [tmpStr substringWithRange:NSMakeRange(0, 17)];//10//
            if (imageDict[key]) {
                
                NSDictionary *imgDict = @{@"f":tmpStr,@"t":timeStr};
                [imageDict[key] addObject:imgDict];
                
            }else{
                
                NSMutableArray *imageArray = [NSMutableArray array];
                [imageDict setValue:imageArray forKey:key];
                NSDictionary *imgDict = @{@"f":tmpStr,@"t":timeStr};
                [imageDict[key] addObject:imgDict];
                
            }
            
        }
        
    }
    
    //获取本地的视频
    NSString *pathvideo = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    pathvideo = [pathvideo stringByAppendingPathComponent:@"device_video"];
    NSArray *videoArray = [fm contentsOfDirectoryAtPath:pathvideo error:nil];
    
    for (NSString *tmpStr in videoArray){
        
        if ([tmpStr hasSuffix:@".MOV"]) {
            
            NSString *key = [tmpStr substringWithRange:NSMakeRange(0, 8)];
            NSString *timeStr = [tmpStr substringWithRange:NSMakeRange(0, 14)];//10
            NSLog(@"gallery videofileStr: %@",tmpStr);//20181225151616_f2dd3cd7-b026-40aa-aaf4-f6ea07376490_1.MOV
            
            
//            AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:targtPath]];
//            CMTime videoTime = [asset duration];
//            int secends  = ceil(videoTime.value/videoTime.timescale);
            NSArray *duraArray = [tmpStr componentsSeparatedByString:@"_"];;
            NSString *duration = [[duraArray lastObject] stringByReplacingOccurrencesOfString:@".MOV" withString:@""];
            
            if (movDict[key]) {
                
                NSDictionary *videoDict = @{@"f":tmpStr,@"t":timeStr,@"d":duration};
                [movDict[key] addObject:videoDict];
                
            }else{
                
                NSMutableArray *videoArray = [NSMutableArray array];
                [movDict setValue:videoArray forKey:key];
                
                NSDictionary *videoDict = @{@"f":tmpStr,@"t":timeStr,@"d":duration};
                [movDict[key] addObject:videoDict];
                
            }
        }
    }
    
    //排序，根据时间排序
    //，
    NSComparator finderSort = ^(NSDictionary *dict1,NSDictionary *dict2){
        NSString *timeStr1 = [dict1 objectForKey:@"t"];
        NSString *timeStr2 = [dict2 objectForKey:@"t"];
        
        if ([timeStr1 integerValue] < [timeStr2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([timeStr1 integerValue] > [timeStr2 integerValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
    
    //照片排序
    NSArray *picDictKeyArr = [imageDict allKeys];
    for(NSString *key in picDictKeyArr){
        [imageDict[key] sortUsingComparator:finderSort];
        //NSLog(@"MovDict:%@",imageDict[key]);
    }
    
    //视频排序
    NSArray *movDictKeyArr = [movDict allKeys];
    for(NSString *key in movDictKeyArr){
        [movDict[key] sortUsingComparator:finderSort];
        //NSLog(@"MovDict:%@",movDict[key]);
    }
    
    
    
    
//    //获取本地的紧急视频
//    NSString *pathvideo_urgent = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    pathvideo_urgent = [pathvideo_urgent stringByAppendingPathComponent:@"urgent_video"];
//    NSArray *videoArray_urgent = [fm contentsOfDirectoryAtPath:pathvideo_urgent error:nil];
//
//    for (NSString *tmpStr in videoArray_urgent){
//
//        if ([tmpStr hasSuffix:@".MOV"]) {
//
//            NSString *key = [tmpStr substringWithRange:NSMakeRange(0, 8)];
//            NSString *timeStr = [tmpStr substringWithRange:NSMakeRange(0, 10)];
//            NSString *targtPath = [pathvideo_urgent stringByAppendingPathComponent:tmpStr];
//            AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:targtPath]];
//            CMTime videoTime = [asset duration];
//            int secends  = ceil(videoTime.value/videoTime.timescale);
//            NSString *duration = [NSString stringWithFormat:@"%d",secends];
//
//
//
//
//
//            if (urgentDict[key]) {
//
//                NSDictionary *videoDict = @{@"f":tmpStr,@"t":timeStr,@"d":duration};
//
//                //先判断本地是否存在了该文件的缩略图，否则就当文件已损坏
//                if ([self checkThumbImgExistWithDict:videoDict] == NO) {
//
//                    continue;
//                }
//                [urgentDict[key] addObject:videoDict];
//
//            }else{
//
//                NSMutableArray *videoArray = [NSMutableArray array];
//                [urgentDict setValue:videoArray forKey:key];
//
//                NSDictionary *videoDict = @{@"f":tmpStr,@"t":timeStr,@"d":duration};
//
//                //先判断本地是否存在了该文件的缩略图，否则就当文件已损坏
//                if ([self checkThumbImgExistWithDict:videoDict] == NO) {
//
//                    continue;
//                }
//
//                [urgentDict[key] addObject:videoDict];
//
//            }
//
//        }
//    }
    

    
    [pictureView setAlbumDcit:imageDict];
    [videoView setAlbumDcit:movDict];
    
    [viewCollection reloadData];
    
}



/**
 检查是否存在缩略图

 @param dict 视频文件相关字典
 @return 状态
 */
-(BOOL)checkThumbImgExistWithDict:(NSDictionary *)dict{

    NSString *imagePath = dict[@"f"];
    imagePath = [imagePath lastPathComponent];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingString:@"/video_thum/Thumbnails"];
    path = [path stringByAppendingPathComponent:imagePath];
    path = [path stringByReplacingOccurrencesOfString:@".MOV" withString:@".movps"];
    NSData *imgdata = [NSData dataWithContentsOfFile:path];
    
    if (imgdata) {
        return YES;
    }else{
        //既然不存在，就删了那个紧急文件
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *pathvideo_urgent = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        pathvideo_urgent = [pathvideo_urgent stringByAppendingPathComponent:@"urgent_video"];
        pathvideo_urgent = [pathvideo_urgent stringByAppendingPathComponent:dict[@"f"]];
        [fm removeItemAtPath:pathvideo_urgent error:nil];
        return NO;
    }
}

#pragma mark <- UIButton Action ->

-(void)setBtnColor:(UIButton *)sender{
    
    if ([sender isEqual:photoBtn]) {
        photoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        videoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [photoBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if ([sender isEqual:videoBtn]){
        
        videoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        photoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [videoBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [photoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

-(void)backBtnClickAction:(id)sender{
    //[self dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)photoBtnClickAction:(id)sender {
    CGPoint pInView = CGPointMake(0, 0);
        // 获取这一点的indexPath
        NSIndexPath *indexPathNow = [viewCollection indexPathForItemAtPoint:pInView];
        nowIndexPath = indexPathNow;
        [viewCollection scrollToItemAtIndexPath:indexPathNow atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    [self setBtnColor:photoBtn];
}

- (void)videoBtnClickAction:(id)sender {
    
    CGPoint pInView = CGPointMake(sW, 0);
    // 获取这一点的indexPath
    NSIndexPath *indexPathNow = [viewCollection indexPathForItemAtPoint:pInView];
    nowIndexPath = indexPathNow;
    [viewCollection scrollToItemAtIndexPath:indexPathNow atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    [self setBtnColor:videoBtn];
}

- (void)selectBtnClickAction:(id)sender {
    
    [[[SelectMedia sharedInstance] selectedArray] removeAllObjects];
    [self selectedFileNameWithItem:nil];
    
    titleView.hidden = NO;
    bottomView.hidden = NO;
    //[DFNotice post:@"HIDDEN_BARITEM_STATUS" Object:@1];
    
    
    [pictureView setSelectorTag:YES];
    [videoView setSelectorTag:YES];
    
    [viewCollection setScrollEnabled:NO];
}


//全选按钮
-(void)allBtnAction:(UIButton *)sender{

    if(allSelectTag == NO){
        [allBtn setTitle:kDV_TXT(@"取消全选") forState:UIControlStateNormal];
        switch (nowIndexPath.row) {
            case 0:{
                [self selectAllItemWithDict:imageDict];
            }break;
            case 1:{
                [self selectAllItemWithDict:movDict];
            }break;
            case 2:{
                [self selectAllItemWithDict:urgentDict];
            }break;
                
            default:
                break;
        }
        allSelectTag = YES;
        
    }else{
        
        [allBtn setTitle:kDV_TXT(@"全选") forState:UIControlStateNormal];
        allSelectTag = NO;
        [[[SelectMedia sharedInstance] selectedArray] removeAllObjects];
        [pictureView setSelectorTag:YES];
        [videoView setSelectorTag:YES];
    }
    
    [self selectedFileNameWithItem:nil];
    
}

//退出选择模式
- (void)sExistBtnAction:(UIButton *)sender{

    titleView.hidden = YES;
    bottomView.hidden = YES;
    [[[SelectMedia sharedInstance] selectedArray] removeAllObjects];
    [DFNotice post:@"HIDDEN_BARITEM_STATUS" Object:@0];
    [pictureView setSelectorTag:NO];
    [videoView setSelectorTag:NO];
    [viewCollection setScrollEnabled:YES];
    [allBtn setTitle:kDV_TXT(@"全选") forState:UIControlStateNormal];
    allSelectTag = NO;
}

//分享
-(void)shareBtnAction:(UIButton *)sender{
    NSMutableArray* imageArray = [NSMutableArray array];
    
    switch (nowIndexPath.row) {
        case 0:
        {
            for (NSString *fileName in [[SelectMedia sharedInstance] selectedArray]) {
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                path = [path stringByAppendingPathComponent:@"device_image"];
                path = [path stringByAppendingPathComponent:fileName];
                
                [imageArray addObject:[UIImage imageWithContentsOfFile:path]];
            }
            
            if(imageArray.count==0){
                [DFUITools showText:kDV_TXT(@"请先选择要分享的文件") onView:self.view delay:1.5];
                return;
            }
            
            UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:imageArray applicationActivities:nil];
            
            [self presentViewController:activityVC animated:TRUE completion:nil];
        }
            break;
        case 1:
        case 2:
        {
             [DFUITools showText:kDV_TXT(@"请在系统相册中分享") onView:self.view delay:1.5];
        }
            break;
    }
}

//保存到手机媒体库
-(void)saveBtnAction:(UIButton *)sender{
    switch (nowIndexPath.row) {
        case 0:{
            for (NSString *fileName in [[SelectMedia sharedInstance] selectedArray]) {
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                path = [path stringByAppendingPathComponent:@"device_image"];
                path = [path stringByAppendingPathComponent:fileName];
                [self savePhotoToMedias:path];
            }
        }break;
        case 1:{
//            [DFUITools showText:@"由于视频原因，暂未增加" onView:self.view delay:1.5];
//            return;
            
            for (NSString *fileName in [[SelectMedia sharedInstance] selectedArray]) {
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                path = [path stringByAppendingPathComponent:@"device_video"];
                path = [path stringByAppendingPathComponent:fileName];
                [self saveVideoToMeidas:path];
            }
            
        }break;
        case 2:{
            
//            [DFUITools showText:@"由于视频原因，暂未增加" onView:self.view delay:1.5];
            
            for (NSString *fileName in [[SelectMedia sharedInstance] selectedArray]) {
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                path = [path stringByAppendingPathComponent:@"urgent_video"];
                path = [path stringByAppendingPathComponent:fileName];
                [self saveVideoToMeidas:path];
            }
            
             return;
            
        }break;
            
        default:
            break;
    }
}

//从本地删除
-(void)deleteBtnAction:(UIButton *)sender{
    if ([[SelectMedia sharedInstance] selectedArray].count>0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:kDV_TXT(@"请确认是否删除") delegate:self cancelButtonTitle:kDV_TXT(@"确认") otherButtonTitles:kDV_TXT(@"取消"), nil];
        alert.tag = 1;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    
   
    
    if (alertView.tag ==1) {
        
        
        switch (buttonIndex) {
            case 0:{
                NSFileManager *fm = [NSFileManager defaultManager];
                if (nowIndexPath.row == 0) {
                    
                    for (NSString *fileName in [[SelectMedia sharedInstance] selectedArray]) {
                        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                        path = [path stringByAppendingPathComponent:@"device_image"];
                        path = [path stringByAppendingPathComponent:fileName];
                        [fm removeItemAtPath:path error:nil];
                    }
                }
                
                if (nowIndexPath.row == 1) {
                    for (NSString *fileName in [[SelectMedia sharedInstance] selectedArray]) {
                        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                        path = [path stringByAppendingPathComponent:@"device_video"];
                        path = [path stringByAppendingPathComponent:fileName];
                        [fm removeItemAtPath:path error:nil];
                        
                        NSString *path2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                        path2 = [path2 stringByAppendingString:@"/video_thum/Thumbnails"];
                        path2 = [path2 stringByAppendingPathComponent:fileName];
                        path2 = [path2 stringByReplacingOccurrencesOfString:@".MOV" withString:@".movps"];
                        [fm removeItemAtPath:path2 error:nil];
                    }
                }
                
                if (nowIndexPath.row == 2) {
                    for (NSString *fileName in [[SelectMedia sharedInstance] selectedArray]) {
                        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                        path = [path stringByAppendingPathComponent:@"urgent_video"];
                        path = [path stringByAppendingPathComponent:fileName];
                        [fm removeItemAtPath:path error:nil];
                        
                        NSString *path2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                        path2 = [path2 stringByAppendingString:@"/video_thum/Thumbnails"];
                        path2 = [path2 stringByAppendingPathComponent:fileName];
                        path2 = [path2 stringByReplacingOccurrencesOfString:@".MOV" withString:@".movps"];
                        [fm removeItemAtPath:path2 error:nil];
                    }
                }
                
                [self cleanListMemory];
                [self reloadMemory];
                [self initWithData];
            }break;
                
            default:
                break;
        }
        
        [self sExistBtnAction:sExistBtn];
    }
    

 
}




-(void)selectAllItemWithDict:(NSDictionary *)dict{

    [[[SelectMedia sharedInstance] selectedArray] removeAllObjects];
    for(NSString *key in dict){
    
        NSArray *baseArray = dict[key];
        for (NSDictionary *tmpDict in baseArray) {
            [[[SelectMedia sharedInstance] selectedArray] addObject:tmpDict[@"f"]];
        }
        
    }
    
    switch (nowIndexPath.row) {
        case 0:
            [pictureView setSelectorTag:YES];
            break;
        case 1:
            [videoView setSelectorTag:YES];
            break;
        default:
            break;
    }
    
    
    
    
}


#pragma mark <- collectionview Delegate ->
#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 2;//2
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumModelView" forIndexPath:indexPath];
    
    [cell addSubview:viewArray[indexPath.row]];
    
    return cell;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 将collectionView在控制器view的中心点转化成collectionView上的坐标
    CGPoint pInView = [self.view convertPoint:viewCollection.center toView:viewCollection];
    // 获取这一点的indexPath
    NSIndexPath *indexPathNow = [viewCollection indexPathForItemAtPoint:pInView];
    // 赋值给记录当前坐标的变量
    NSLog(@"indexpathNow:%ld",(long)indexPathNow.row);
    nowIndexPath = indexPathNow;
    // 更新底部的数据
    
    switch (indexPathNow.row) {
        case 0:{
            
            [self setBtnColor:photoBtn];
            
        }break;
        case 1:{
            [self setBtnColor:videoBtn];
        }break;
        default:
            break;
    }
    // ...
}


//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"offsetY:%f",offsetY);
//}

-(void)selectedFileNameWithItem:(NSString *)fileName{

    NSInteger count = [[SelectMedia sharedInstance] selectedArray].count;
    
    NSString *selectedString = [NSString stringWithFormat:@"%@%d",kDV_TXT(@"已选"),(int)count];
    
    titleLab.text = selectedString;

}

-(void)selectedFileNameWithItemPlay:(NSString *)fileName{

    
    
     __weak typeof(self)weakSelf = self;
    switch (nowIndexPath.row) {
        case 0:{
            
            
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            path = [path stringByAppendingPathComponent:@"device_image"];
            path = [path stringByAppendingPathComponent:fileName];
            
            BrowseView *brows = [[BrowseView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];

            NSData *data = [NSData dataWithContentsOfFile:path];
            
            if (data) {
                [brows stepWithImage:[UIImage imageWithData:data]];
                [self.view.window addSubview:brows];
            }
           
            
            
        }break;
        case 1:{
            
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            path = [path stringByAppendingPathComponent:@"device_video"];
            path = [path stringByAppendingPathComponent:fileName];
            NSURL *url = [NSURL fileURLWithPath:path];
            LocalPlayerViewController *vc = [[LocalPlayerViewController alloc] init];
            vc.locolPath = url;
            vc.exViewController = self;
            [weakSelf presentViewController:vc animated:YES completion:nil];
            
        }break;
            
        case 2:{
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            path = [path stringByAppendingPathComponent:@"urgent_video"];
            path = [path stringByAppendingPathComponent:fileName];
            NSURL *url = [NSURL fileURLWithPath:path];
            LocalPlayerViewController *vc = [[LocalPlayerViewController alloc] init];
            vc.locolPath = url;
            vc.exViewController = self;
            [weakSelf presentViewController:vc animated:YES completion:nil];
            
        }break;
            
        default:
            break;
    }
    
}


//ljw++
-(void)scrollToRaw{
//    [_videoView.albumTable scrollToRowAtIndexPath:<#(nonnull NSIndexPath *)#> atScrollPosition:<#(UITableViewScrollPosition)#> animated:<#(BOOL)#>];
}
    



#pragma mark <- 缩略图的 ->
-(void)getNewVideoSmallImage:(NSNotification *)note{
    
    NSDictionary *dict = [note object];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingString:@"/Medias/Thumbnails"];
    path = [path stringByAppendingPathComponent:dict[@"filename"]];
    path = [path stringByReplacingOccurrencesOfString:@".MOV" withString:@".movps"];
    [DFFile createPath:path];
    NSData *data = dict[@"image"];
    [DFFile writeData:data fillFile:path];
    
    //    UIImageView *test = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    //    test.image = [UIImage imageWithData:dict[@"image"]];
    //    [self.view addSubview:test];
    
    
    [viewCollection reloadData];
    
}
-(void)getFailedVideosmallImage:(NSNotification *)note{
    
    NSDictionary *dict = note.object;
    NSLog(@"error:%@ withName:%@",dict[@"err_msg"],dict[@"filename"]);
    
}


-(void)mediaVideoFileLoadOK:(NSNotification *)note{
    
    NSDictionary *dataDict = [note object];
    
    NSDictionary *dict = @{@"height":dataDict[@"height"],@"width":dataDict[@"width"],@"name":dataDict[@"file"]};
    
    [ffcodeFrame jlFFonFrameCodeWith:dataDict[@"iData"] withDict:dict];
    
    
    
}

-(void)mediaMuLticover:(NSNotification *)note{
    
    //    NSLog(@"12345679==>%@",note);
    
    
}


-(void)addNote{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewVideoSmallImage:) name:JLFFDECODESU object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFailedVideosmallImage:) name:JLFFDECODEFA object:nil];
    
    [DFNotice add:DV_MULTI_COVER_FIGURE Action:@selector(mediaMuLticover:) Own:self];
    [DFNotice add:DV_MEDIADOWNLOAD_OK Action:@selector(mediaVideoFileLoadOK:) Own:self];
    [DFNotice add:kDV_LANGUAGE_CHANGE Action:@selector(dvLanguageChange) Own:self];
    [DFNotice add:DV_URGENT_VIDEO_OK Action:@selector(dvReFreshUrgentVideo:) Own:self];
    
    
}


-(void)removeNote{

    [DFNotice remove:DV_MEDIADOWNLOAD_OK Own:self];
    [DFNotice remove:DV_MULTI_COVER_FIGURE Own:self];
    [DFNotice remove:JLFFDECODESU Own:self];
    [DFNotice remove:JLFFDECODEFA Own:self];
}


-(void)dvLanguageChange{

    
    [photoBtn setTitle:kDV_TXT(@"图片") forState:UIControlStateNormal];
    [videoBtn setTitle:kDV_TXT(@"视频") forState:UIControlStateNormal];
    [selectBtn setTitle:kDV_TXT(@"选择") forState:UIControlStateNormal];
    [allBtn setTitle:kDV_TXT(@"全选") forState:UIControlStateNormal];
    [sExistBtn setTitle:kDV_TXT(@"退出") forState:UIControlStateNormal];
    
}


-(void)dvReFreshUrgentVideo:(NSNotification *)note{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadMemory];
        [self initWithData];
        selectTarget = NO;
        [viewCollection reloadData];
        
    });
    
}


#pragma mark <-把照片存储到相册->
- (void)savePhotoToMedias:(NSString *)patch{

    UIImage *image = [UIImage imageWithContentsOfFile:patch];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);


}


- (void)image: (UIImage*)image didFinishSavingWithError: (NSError*) error contextInfo: (void*)contextInfo
{
    //NSLog(@"save result");

    if (error != nil) {
        //show error message
        NSLog(@"take picture failed");
        [DFUITools showText:kDV_TXT(@"图片保存到图库失败") onView:self.view delay:1.5];
    }else {
        //show message image successfully saved
        NSLog(@"save success");
        [DFUITools showText:kDV_TXT(@"图片已保存到图库") onView:self.view delay:1.5];

    }
    
    [self sExistBtnAction:sExistBtn];

}

#pragma mark <- 把视频存储到相册 ->

- (void)saveVideoToMeidas:(NSString *)patch{

    NSURL *url = [[NSURL alloc] initWithString:patch];

    ALAssetsLibrary *libary = [[ALAssetsLibrary alloc] init];
    [libary writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {

        if (error) {
            NSLog(@"Save Video failed....");
            [DFUITools showText:kDV_TXT(@"视频保存到图库失败") onView:self.view delay:1.5];

        }else{

            NSLog(@"Save Video OK...");
            [DFUITools showText:kDV_TXT(@"视频已保存到图库") onView:self.view delay:1.5];

        }
        [self sExistBtnAction:sExistBtn];
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
