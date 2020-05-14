//
//  HMHomeDiscoveryController.m
//  SimpleLamp
//
//  Created by chen on 2020/5/14.
//  Copyright © 2020 chen. All rights reserved.
//

#import "HMHomeDiscoveryController.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "HMHomeCollectionCell.h"


#define HOME_CELL_IDENTIFIER   @"HomeWaterfallCell"
#define HOME_CELL_AD_IDENTIFIER @"HOME_CELL_AD_IDENTIFIER"
#define HOME_HEADER_IDENTIFIER @"HomeWaterfallHeader"
#define HOME_FOOTER_IDENTIFIER @"HomeWaterfallFooter"


@interface HMHomeDiscoveryController () <UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout> {
    
}

@property (nonatomic,strong) CHTCollectionViewWaterfallLayout *waterLayout;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *allAdsArray;
@property (nonatomic,assign) NSInteger currPage;
@property (nonatomic,assign) BOOL hasNextPage;


@end

@implementation HMHomeDiscoveryController

- (id)init{
    if (self = [super init]) {
        _dataArray = @[].mutableCopy;
        _allAdsArray = @[].mutableCopy;
        _currPage = 1;
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



#pragma mark - collection view

- (void)initCollectionView{
    
    _waterLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
    _waterLayout.sectionInset = UIEdgeInsetsMake(5, 15, 15, 15);
    _waterLayout.headerHeight = 15;
    _waterLayout.footerHeight = 0;
    _waterLayout.minimumColumnSpacing = 15;
    _waterLayout.minimumInteritemSpacing = 15;
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_TOP_HEIGHT) collectionViewLayout:_waterLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.clipsToBounds = YES;
    [_collectionView registerClass:[HMHomeCollectionCell class]
        forCellWithReuseIdentifier:HOME_CELL_IDENTIFIER];
    [_collectionView registerClass:[HMHomeCollectionAdCell class]
        forCellWithReuseIdentifier:HOME_CELL_AD_IDENTIFIER];
    [_collectionView registerClass:[HMHomeWaterFlowHeaderView class]
        forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
               withReuseIdentifier:HOME_HEADER_IDENTIFIER];
    [_collectionView registerClass:[CHTCollectionViewWaterfallFooter class]
        forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
               withReuseIdentifier:HOME_FOOTER_IDENTIFIER];
    [self.view addSubview:_collectionView];
    
    _collectionView.mj_header = [MJRefreshJBHeader headerWithRefreshingTarget:self refreshingAction:@selector(refrushHeaderData)];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _recommendArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [_recommendArray objectAtIndex:indexPath.row];
    CGFloat width = [[dict stringValueForKey:@"width"] floatValue];
    CGFloat height = [[dict stringValueForKey:@"height"] floatValue];
    NSInteger is_ad = [[dict stringValueForKey:@"is_ad"] integerValue];
    
    if (is_ad == 1){
        if (width == 0 || height == 0) {
            return CGSizeMake(HomeCollectionCell_width, HomeCollectionCell_width);
        }else{
            CGFloat actualHeight = (HomeCollectionCell_width * height)/width;
            return CGSizeMake(HomeCollectionCell_width, actualHeight);
        }
    }else{
        
        return [HMHomeCollectionCell getCollectionCellSizeWithInformation:dict];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [_recommendArray objectAtIndex:indexPath.row];
    NSInteger is_ad = [[dict stringValueForKey:@"is_ad"] integerValue];
    UIColor *color = [self getRadomColor:indexPath.row];
    
    if (is_ad == 1) {
        HMHomeCollectionAdCell *cell =
        (HMHomeCollectionAdCell *)[collectionView dequeueReusableCellWithReuseIdentifier:HOME_CELL_AD_IDENTIFIER forIndexPath:indexPath];
        
        
        [cell reloadWithInformation:dict];
        cell.bigImage.backgroundColor = color;
        
        
        return cell;
    }else{
        HMHomeCollectionCell *cell =
        (HMHomeCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:HOME_CELL_IDENTIFIER forIndexPath:indexPath];
        
        
        [cell reloadWithInformation:dict];
        cell.bigImage.backgroundColor = color;
        
        [cell.praiseView addTarget:self action:@selector(clickPraise:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
    }
    
}

- (UIColor *)getRadomColor:(NSInteger)index{
    NSInteger i = index %4;
    
    if (i == 0) {
        return RGB_COLOR_String(@"BBBBBB");
    }else if (i == 1) {
        return RGB_COLOR_String(@"E1E0E1");
    }else if (i == 2) {
        return RGB_COLOR_String(@"DAD2D1");
    }else if (i == 3) {
        return RGB_COLOR_String(@"E5DDD3");
    }else {
        return RGB_COLOR_String(@"BBBBBB");
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HOME_HEADER_IDENTIFIER forIndexPath:indexPath];
        
    } else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HOME_FOOTER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    }
    
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    NSInteger type_id = [[dict stringValueForKey:@"type_id"] integerValue];
    NSInteger is_ad = [[dict stringValueForKey:@"is_ad"] integerValue];
    
    if (is_ad == 1) {
        
        
    }else{
        
        
        
    }
    
}







@end
