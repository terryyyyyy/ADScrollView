//
//  FAFAdsView.h
//  
//
//  Created by everyWood on 15/12/16.
//

#import <UIKit/UIKit.h>
#import "ADSIndicator.h"

@class ADScrollView;
@protocol ADScrollViewDelegate <NSObject>
@required
/**
 *  点击图片的代理方法
 *
 *  @param index 点击的图片的序号，从1开始，注意与数组序号区分
 */
- (void)ADsView:(ADScrollView *)ADSview didSelectImageOfIndex:(NSNumber *)index;
@end

@interface ADScrollView : UIScrollView<UIScrollViewDelegate>
/**
 自动切换到广告的时间间隔，不设置则为默认的3S
 */
@property (nonatomic,assign) CGFloat timeIntevel;


/**
 *  初始化方法,全参数
 *
 *  @param frame       广告浏览器的frame
 *  @param photos      装图片的数组，里面为nssting，图片的链接或者是本地图片名字
 *  @param delegate    监听点击事件的代理
 *  @param placeHolder 占位图
 *  @pa
 *
 *  @return 返回广告浏览实例
 */
- (instancetype)initWithFrame:(CGRect)frame
                       Photos:(NSArray *)photos
                     delegate:(id<ADScrollViewDelegate>)delegate
               placeHolderStr:(NSString *)placeHolder
                indicatorType:(AdsIndicatorType)type
           indicatorAlignment:(IndicatorAlignment)alignment;

/**
 *  初始化方法,索引默认居中
 */
- (instancetype)initWithFrame:(CGRect)frame
                       Photos:(NSArray *)photos
                     delegate:(id<ADScrollViewDelegate>)delegate
               placeHolderStr:(NSString *)placeHolder
                indicatorType:(AdsIndicatorType)type;

/**
 *  初始化方法,默认为无索引
 */
- (instancetype)initWithFrame:(CGRect)frame
                       Photos:(NSArray *)photos
                     delegate:(id<ADScrollViewDelegate>)delegate
               placeHolderStr:(NSString *)placeHolder;

@end
