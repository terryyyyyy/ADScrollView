//
//  FAFAdsView.m
//  
//
//  Created by LiuBo on 15/12/16.
//  Copyright © 2015年 SnowWolfSoftware. All rights reserved.
//

#import "FAFAdsView.h"
#import "SDWebImageManager+FAF.h"
#define IsURLStr(str)  [str containsString:@"://"]

@interface FAFAdsView()
/**
 *  展示的图片数组，内装图片的链接或者图片的名字
 */
@property (nonatomic,copy)NSArray *photos;

/**
 *  监听图片点击事件的代理
 */
@property (nonatomic,weak)id<FAFADsViewDelegate> ADsDelegate;

@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,strong) NSTimer *adTimer;
@property (nonatomic,copy)   NSString *placeHolderStr;
//展示的图片序号
@property (nonatomic,assign) NSInteger lastShowingIndex;
@property (nonatomic,assign) NSInteger currentShowingIndex;
@property (nonatomic,assign) NSInteger nextShowingIndex;
// 三张展示的UIImageView
@property (nonatomic,strong)UIImageView *lastImageView;
@property (nonatomic,strong)UIImageView *currentImageView;
@property (nonatomic,strong)UIImageView *nextImageView;
//索引
@property (nonatomic,strong)FAFAdsIndicator *indicator;
@end
@implementation FAFAdsView

- (instancetype)initWithFrame:(CGRect)frame
                       Photos:(NSArray *)photos
                     delegate:(id<FAFADsViewDelegate>)delegate
               placeHolderStr:(NSString *)placeHolder
{
   return [self initWithFrame:frame Photos:photos delegate:delegate placeHolderStr:placeHolder indicatorType:FAFAdsIndicatorTypeNone indicatorAlignment:0];
}

- (instancetype)initWithFrame:(CGRect)frame
                       Photos:(NSArray *)photos
                     delegate:(id<FAFADsViewDelegate>)delegate
               placeHolderStr:(NSString *)placeHolder
                indicatorType:(FAFAdsIndicatorType)type
{
    return [self initWithFrame:frame Photos:photos delegate:delegate placeHolderStr:placeHolder indicatorType:type  indicatorAlignment:IndicatorAlignmentMiddle];
}

- (instancetype)initWithFrame:(CGRect)frame
                       Photos:(NSArray *)photos
                     delegate:(id<FAFADsViewDelegate>)delegate
               placeHolderStr:(NSString *)placeHolder
                indicatorType:(FAFAdsIndicatorType)type
           indicatorAlignment:(IndicatorAlignment)alignment
{
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    //开始下载所有图片,是链接的就下载，不是链接的就不用了
    for (NSString *imageName in photos) {
        FAFAssertNotNil([imageName isKindOfClass:[NSString class]], @"%@ is not a NSString Class",imageName);
        if (IsURLStr(imageName)) {
            [SDWebImageManager downloadWithURL:[NSURL URLWithString:imageName]];
        }
    }
    //存储相关属性
    self.width = frame.size.width;
    self.height = frame.size.height;
    self.photos = photos;
    self.placeHolderStr = placeHolder;
    self.ADsDelegate = delegate;
    self.indicatorAlignment = alignment;
    
    //添加索引
    [self addIndicatorWihtType:(type || (photos.count != 1)) ? type : FAFAdsIndicatorTypeNone];

    //设置滑动属性
    [self setScrollView];

    return self;
}

//添加索引条
- (void)addIndicatorWihtType:(FAFAdsIndicatorType)type
{
    self.indicator = [[FAFAdsIndicator alloc] initWithADViewFrame:self.frame alignment:self.indicatorAlignment totalNum:self.photos.count andType:type];
    //在自己添加上去之后再添加索引条，不然会被挡着
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.superview addSubview:self.indicator];
    });
}

- (void)setScrollView
{
    //基本属性设置
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    self.pagingEnabled = YES;
    self.delegate = self;
    self.bounces = NO;
    self.directionalLockEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor greenColor];
    if (self.photos.count == 0 || self.photos == nil) {
        return;
    }
    
    //如果图片数多于一张，则用三个view来循环展示
    if (self.photos.count == 1) {
        self.contentSize = CGSizeMake(self.width, self.height);
        self.contentOffset = CGPointZero;
        self.currentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.currentImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.currentImageView];
        self.currentShowingIndex = 1;
    }else{
        UIImageView * (^createImageViewByIndex)(int) = ^(int index){
            CGRect frmae = CGRectMake(index * _width,0, _width, _height);
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:frmae];
            imageView.contentMode = UIViewContentModeScaleToFill;
            imageView.backgroundColor = [UIColor blackColor];
//            imageView.image = [UIImage imageNamed:@"background"];
            [self addSubview:imageView];
            return imageView;
        };
        self.contentSize = CGSizeMake(self.width * 3, self.height);
        self.contentOffset = CGPointMake(self.width, 0);
        self.lastImageView = createImageViewByIndex(0);
        self.currentImageView = createImageViewByIndex(1);
        self.nextImageView = createImageViewByIndex(2);
        //始终显示中间的view，默认一开始中间的index为第一张
        self.currentShowingIndex = 1;
        //开始自动滑动
        [self startTimer];
    }
    //只有中间的view可以点击
    self.currentImageView.userInteractionEnabled = YES;
    [self.currentImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)]];
}

#pragma mark - ScrollView Deleget
static CGFloat originalOffsetX = -1;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.photos.count <= 1) {
        return;
    }
    if (scrollView.contentOffset.x == self.width) {
        return;
    }
    //这句不要会出现bug，连续手动滑动时会出现跳页
    if (originalOffsetX == self.width && (scrollView.contentOffset.x == self.width * 2 || scrollView.contentOffset.x == 0)) {
        originalOffsetX = -1;
        [scrollView setContentOffset:CGPointMake(self.width, 0)];
        return;
    }
    if (scrollView.contentOffset.x == 0) {
        self.currentShowingIndex--;
    }
    if (scrollView.contentOffset.x == self.width * 2) {
        self.currentShowingIndex++;
    }
    originalOffsetX = scrollView.contentOffset.x;
}
//需要打开时可以打开
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self invalidateTimer];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    [self startTimer];
//}

#pragma mark - 私有方法

//自动滚动
- (void)autoScroll
{
    [self setContentOffset:CGPointMake(self.width * 2, 0) animated:YES];
}

//复写set方法,设置的时候就显示该图片到中间
- (void)setCurrentShowingIndex:(NSInteger)currentShowingIndex
{
    if (self.photos.count <= 1) {
        [self showADPhots];
        return;
    }
    //调整序号，实现循环的播放
    _currentShowingIndex = currentShowingIndex;
    _currentShowingIndex = _currentShowingIndex != 0 ? currentShowingIndex :self.photos.count;
    _currentShowingIndex = _currentShowingIndex != self.photos.count + 1 ? _currentShowingIndex : 1;
    //调整索引编号
    self.indicator.currentIndex = _currentShowingIndex;
    //设置前一张的序号
    if (_currentShowingIndex == 1) {
        self.lastShowingIndex = self.photos.count;
    }else
        self.lastShowingIndex = self.currentShowingIndex -1;
    //设置后一张的序号
    if (_currentShowingIndex == self.photos.count) {
        self.nextShowingIndex = 1;
    }else
        self.nextShowingIndex = self.currentShowingIndex + 1;
    //展示图片，并调整offset
    [self showADPhots];
    [self setContentOffset:CGPointMake(self.width, 0) animated:NO];
}


- (void)showADPhots
{
    //只有一张图就好办了
    if (self.photos.count <= 1) {
        if (IsURLStr(self.photos[0])) {
            [self.currentImageView faf_setImageWithURL:[NSURL URLWithString:self.photos[0]] placeholderImage:[UIImage imageNamed:self.placeHolderStr]];
        }else
        {
            self.currentImageView.image = [UIImage imageNamed:self.photos[0]];
        }
        return;
    }
    //开始设置图片
    void (^showPhototAt)(UIImageView *,NSInteger) = ^(UIImageView *imageView, NSInteger index){
        NSString *urlStr = self.photos[index - 1];
        if (IsURLStr(urlStr)) {
            [imageView faf_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:self.placeHolderStr]];
        }else
        {
            imageView.image = [UIImage imageNamed:urlStr];
        }
    };
    //第一张
    showPhototAt(self.lastImageView,self.lastShowingIndex);
    //第二张
    showPhototAt(self.currentImageView,self.currentShowingIndex);
    //第三张
    showPhototAt(self.nextImageView,self.nextShowingIndex);
}
//选择当前的图片广告
- (void)singleTap
{
    [self.ADsDelegate performSelector:@selector(ADsViewDidSelectImageOfIndex:) withObject:[NSNumber numberWithInteger:self.currentShowingIndex]];
}

- (void)setTimeIntevel:(CGFloat)timeIntevel
{
    //用户设置自定义时间后，重新开始计时器
    [self invalidateTimer];
    _timeIntevel = timeIntevel;
    [self startTimer];
}

//定时器开关
- (void)startTimer
{
    if (!self.timeIntevel) {
        //这里不用set方法
        _timeIntevel = 3.0;
    }
    self.adTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeIntevel target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
}

- (void)invalidateTimer
{
    [self.adTimer invalidate];
    self.adTimer = nil;
}

@end
