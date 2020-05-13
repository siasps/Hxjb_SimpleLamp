
//
//  HMScaleScrollView.m
//  kitest
//
//  Created by Huamo on 2018/5/28.
//  Copyright © 2018年 chen. All rights reserved.
//

#import "HMScaleScrollView.h"


@interface HMScaleImageModel : NSObject

@property(nonatomic,strong) NSString *imageUrlStr;
@property(nonatomic,assign) CGFloat imageHeiht;
@property(nonatomic,assign) CGFloat imageWidth;



@end

@implementation HMScaleImageModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"imageUrlStr" : @"image_url",
             @"imageHeiht" : @"height",
             @"imageWidth" : @"width"
             };
}


@end



@interface HMScaleScrollView () <UIScrollViewDelegate> {
    
}
@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,weak) id<HMScaleScrollViewDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic, assign)CGFloat lastPosition;    //左后的滑动坐标
@property(nonatomic, assign)NSInteger currentpage;   //当前页

@end



@implementation HMScaleScrollView

- (instancetype)initWithDelegate:(id<HMScaleScrollViewDelegate>)delegate frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        
        _mainScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _mainScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        _mainScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_mainScrollView];
        
        //设置分页
        _mainScrollView.pagingEnabled = YES;
        //设置弹簧效果为NO
        _mainScrollView.bounces = NO;
        _mainScrollView.delegate = self;
        //关闭自动布局
        _mainScrollView.translatesAutoresizingMaskIntoConstraints = NO;
        //隐藏滚动条
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        
        
        _dataArray = @[].mutableCopy;
        
    }
    return self;
}

- (void)reloadWithDataArray:(NSArray *)array{
    [_dataArray removeAllObjects];
    for (UIImageView *imageV in _mainScrollView.subviews) {
        [imageV removeFromSuperview];
    }
    _currentpage = 0;
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        HMScaleImageModel *model = [HMScaleImageModel yy_modelWithDictionary:obj];
//        [_dataArray addObject:model];
    }];
    
    
    [self initSubviews];
    
    
    if (_dataArray.count > 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(scaleScrollView:viewHeight:pageIndex:)]) {
            HMScaleImageModel *model = [self.dataArray firstObject];
            CGFloat imageHeight = [self heightformodel:model];
            [_delegate scaleScrollView:self viewHeight:imageHeight pageIndex:0];
        }
    }
    
}

- (void)initSubviews{
    
    CGFloat imageHeight = 0.0f;
    for (NSUInteger i = 0; i < self.dataArray.count ; i++) {
        HMScaleImageModel *model = [self.dataArray objectAtIndex:i];
        //获取到宽高比例的高度
        imageHeight = [self heightformodel:model];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, imageHeight)];
        imageView.backgroundColor = [UIColor whiteColor];
        //多余部分不显示
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = 100 +i;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrlStr] placeholderImage:[UIImage imageNamed:@"default640x640.png"]];
        [_mainScrollView addSubview:imageView];
    }
    //获取到第一张图片
    UIImageView *imageView = (UIImageView *)[self viewWithTag:100];
    //设置刚开始的数据
    _mainScrollView.contentSize = CGSizeMake(self.dataArray.count * SCREEN_WIDTH, imageView.frame.size.height);
    
    
    //修改成图片的高度
    CGRect frame = self.frame;
    frame.size.height = imageView.height;
    self.frame = frame;
    
    _mainScrollView.frame = self.bounds;
    
}

- (CGFloat)heightformodel:(HMScaleImageModel *)model{
    
    if (model.imageWidth == 0 || model.imageHeiht == 0) {
        return SCREEN_WIDTH/16*9;
    }
    
    CGFloat scale = model.imageWidth / SCREEN_WIDTH;
    CGFloat height =  model.imageHeiht / scale;
    
    return height;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //拿到移动中的x
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat currentPostion = offsetX;
    //当前页数
    int page = offsetX / SCREEN_WIDTH;
    
    BOOL isleft;
    if (currentPostion > _lastPosition) {
        isleft = YES;
        if (page > 0  && offsetX - page * SCREEN_WIDTH <0.01) {
            page = page -1;
        }
    }else{
        isleft = NO;
    }
    
    UIImageView *firstImageView = (UIImageView *)[self viewWithTag:100+page];
    UIImageView *nextImageView = (UIImageView *)[self viewWithTag:100+page+1];
    HMScaleImageModel *firstModel = [self.dataArray objectAtIndex:page];
    HMScaleImageModel *nextModel = [self.dataArray objectAtIndex:page+1];
    
    CGFloat firtstImageHeiht = [self heightformodel:firstModel];
    CGFloat nextImageHeiht = [self heightformodel:nextModel];
    
    //设置Y
    CGFloat distanceY = isleft ? nextImageHeiht - firstImageView.height :firtstImageHeiht - firstImageView.height;
    CGFloat leftDistaceX = (page +1) * SCREEN_WIDTH - _lastPosition;
    CGFloat rightDistanceX = SCREEN_WIDTH - leftDistaceX;
    CGFloat distanceX = isleft ? leftDistaceX :rightDistanceX;
    
    
    //移动值
    CGFloat movingDistance = 0.0;
    if (distanceX != 0 && fabs(_lastPosition - currentPostion) > 0) {
        movingDistance = distanceY / distanceX * (fabs(_lastPosition - currentPostion));
    }
    
    CGFloat firstScale = firstModel.imageWidth / firstModel.imageHeiht;
    CGFloat nextScale = nextModel.imageWidth / nextModel.imageHeiht;
    
    
    firstImageView.frame = CGRectMake((firstImageView.frame.origin.x- movingDistance * firstScale), 0, (firstImageView.height+movingDistance)*firstScale, firstImageView.height+movingDistance);
    
    nextImageView.frame = CGRectMake(SCREEN_WIDTH*(page+1), 0, firstImageView.height * nextScale, firstImageView.height);
    //重新设置大小
    _mainScrollView.contentSize = CGSizeMake( SCREEN_WIDTH * self.dataArray.count, firstImageView.height);
    
    //重新设置高度
    CGRect frame = self.frame;
    frame.size.height = firstImageView.height;
    self.frame = frame;
    _mainScrollView.frame = self.bounds;
    
    
    int newpage = offsetX / SCREEN_WIDTH;
    if ( offsetX - newpage * SCREEN_WIDTH < 0.01) {
        _currentpage = newpage;
    }
    
    _lastPosition = currentPostion;
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(scaleScrollView:viewHeight:pageIndex:)]) {
        [_delegate scaleScrollView:self viewHeight:firstImageView.height pageIndex:_currentpage];
    }
}




@end
