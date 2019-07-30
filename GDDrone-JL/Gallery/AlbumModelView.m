//
//  AlbumModelView.m
//  DVRunning16
//
//  Created by jieliapp on 2017/6/27.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "AlbumModelView.h"
#import "AlbumTableCell.h"
#import "AppInfoGeneral.h"

@interface AlbumModelView()<UITableViewDelegate,UITableViewDataSource,albumTableCellDelegate>{

    NSArray  *itemArray;
    
    UIImageView  *bgImgv;
    UILabel      *bglab;
    
}

@end
@implementation AlbumModelView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self initWithUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dvLanguageChange) name:kDV_LANGUAGE_CHANGE object:nil];
    }
    return self;
    
}

-(void)setSelectorTag:(BOOL)selectorTag{
    _selectorTag = selectorTag;
    [_albumTable reloadData];
}


-(void)dvLanguageChange{
 
    bglab.text = kDV_TXT(@"没有文件");
    
}

-(void)initWithUI{
    //
    
    

    bgImgv = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-60, self.frame.size.height/2-120, 120.0, 120.0)];
    bgImgv.image = [UIImage imageNamed:@"noneMedia"];
    [self addSubview:bgImgv];
    
    bglab = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-100, self.frame.size.height/2, 200, 40)];
    bglab.textAlignment =  NSTextAlignmentCenter;
    bglab.textColor = [UIColor blackColor];
    bglab.font = [UIFont systemFontOfSize:15];
    bglab.text = kDV_TXT(@"没有文件");
    [self addSubview:bglab];
    
    bgImgv.hidden = YES;
    bglab.hidden = YES;
    
    [self loadAlbumTable];
}

-(void)loadAlbumTable{
    _albumTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _albumTable.delegate = self;
    _albumTable.dataSource = self;
    //    _albumTable.tableFooterView = [UIView new];
    //    _albumTable.backgroundColor = [UIColor clearColor];
    _albumTable.allowsSelection = NO;
    _albumTable.rowHeight = 200;
    _albumTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //固定行高，禁止动态计算，以解决刷新跳动问题
    if (@available(iOS 11.0, *)) {
        _albumTable.estimatedRowHeight = 0;
        _albumTable.estimatedSectionFooterHeight = 0;
        _albumTable.estimatedSectionHeaderHeight = 0;
    }
    
    [self addSubview:_albumTable];
}

-(void)reloadAlbumTable{
    [_albumTable removeFromSuperview];
    _albumTable = nil;
    [self loadAlbumTable];
}



/**
 设置字典

 @param albumDcit 字典
 */
-(void)setAlbumDcit:(NSDictionary *)albumDcit{
    
    _albumDcit = albumDcit;
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSString *key in _albumDcit) {
        [tmpArray addObject:key];
    }
    
    NSComparator finderSort = ^(id string1,id string2){
        
        if ([string1 integerValue] < [string2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([string1 integerValue] > [string2 integerValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
    
    itemArray = [tmpArray sortedArrayUsingComparator:finderSort];
    
    if (itemArray.count <= 0) {
        _albumTable.hidden = YES;
        bgImgv.hidden = NO;
        bglab.hidden = NO;
    }else{
        _albumTable.hidden = NO;
        bgImgv.hidden = YES;
        bglab.hidden = YES;
    }
    

    [_albumTable reloadData];

}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _albumDcit.count;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return 1;//一行
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(6, 0, self.frame.size.width, 50.0)];
    headView.backgroundColor = [UIColor whiteColor];
    UIImageView *headimng = [[UIImageView alloc] initWithFrame:CGRectMake(0,5 , 40.0, 40.0)];
    [headimng setImage:[UIImage imageNamed:@"calendarTime"]];
    headimng.contentMode = UIViewContentModeCenter;
    [headView addSubview:headimng];
    
    UILabel *headTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 5 , 120, 40.0)];
    headTitle.font = [UIFont systemFontOfSize:13];
    headTitle.textAlignment = NSTextAlignmentLeft;
    NSString *year = [itemArray[section] substringWithRange:NSMakeRange(0, 4)];
    NSString *mon = [itemArray[section] substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [itemArray[section] substringFromIndex:6];
    
    headTitle.text = [NSString stringWithFormat:@"%@-%@-%@",year,mon,day];
    
    [headView addSubview:headTitle];
    
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 50.0;
    
}

int columnNum = 5; //列数
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger section = indexPath.section;
    NSString *tmpKey = itemArray[section];
    NSArray *tmpArray = _albumDcit[tmpKey];
    
    int k = tmpArray.count % columnNum;//3
    CGFloat height = 200;
    if (k == 0) {
        height = 86*tmpArray.count/columnNum;
    }else{
        height = 86*(tmpArray.count/columnNum + 1);
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cellForRowAtIndexPath...");
    
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123456"];
    
    static NSString *cellid = @"AlbumTableCell";
    AlbumTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
//    AlbumTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumTableCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        
        NSInteger section = indexPath.section;
        NSString *tmpKey = itemArray[section];
        NSArray *tmpArray = _albumDcit[tmpKey];
        
        int k = tmpArray.count % columnNum;//3
        CGFloat height = 200;
        if (k == 0) {
            height = 86*tmpArray.count/columnNum;//3
        }else{
            height = 86*(tmpArray.count/columnNum + 1);//3
        }
        
        @autoreleasepool {
            
            cell = [[AlbumTableCell alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
            //复用
//            cell = [[AlbumTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid WithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
        }
        
    }
    
    cell.delegate = self;
    NSInteger section = indexPath.section;
    NSString *key = itemArray[section];
    
    cell.collectionArray = _albumDcit[key];
    cell.type = VIDEO_ALBUM;
    cell.selectStatus = _selectorTag;
    cell.backgroundColor = [UIColor whiteColor];
    [cell reloadViewData];
    
    
    
    return cell;
}






-(void)albumDidSelected:(NSString *)name{

    if([_delegate respondsToSelector:@selector(selectedFileNameWithItem:)]){
        [_delegate selectedFileNameWithItem:name];
    }
    
    [_albumTable reloadData];
    
}

-(void)albumDidSelectedForPlay:(NSString *)name{

    if ([_delegate respondsToSelector:@selector(selectedFileNameWithItemPlay:)]) {
        [_delegate selectedFileNameWithItemPlay:name];
    }
    
}



@end
