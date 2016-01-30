//
//  FAFAdsView.h
//  
//
//  Created by LiuBo on 15/12/16.
//  Copyright © 2015年 SnowWolfSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAFAdsIndicator.h"

@protocol FAFADsViewDelegate <NSObject>
@required
/**
 *  点击图片的代理方法
 *
 *  @param index 点击的图片的序号，从1开始，注意与数组序号区分
 */
- (void)ADsViewDidSelectImageOfIndex:(NSNumber *)index;
@end

@interface FAFAdsView : UIScrollView<UIScrollViewDelegate>
/**
 自动切换到广告的时间间隔，不设置则为默认的3S
 */
@property (nonatomic,assign) CGFloat timeIntevel;
/**
 *  索引的对齐方式，默认为居中对齐
 */
@property (nonatomic,assign) IndicatorAlignment indicatorAlignment;

/**
 *  初始化方法
 *
 *  @param frame       广告浏览器的frame
 *  @param photos      装图片的数组，里面为nssting，图片的链接或者是本地图片名字
 *  @param delegate    监听点击事件的代理
 *  @param placeHolder 占位图
 *
 *  @return 返回广告浏览实例
 */
- (instancetype)initWithFrame:(CGRect)frame
                       Photos:(NSArray *)photos
                     delegate:(id<FAFADsViewDelegate>)delegate
               placeHolderStr:(NSString *)placeHolder
                indicatorType:(FAFAdsIndicatorType)type
           indicatorAlignment:(IndicatorAlignment)alignment;

- (instancetype)initWithFrame:(CGRect)frame
                       Photos:(NSArray *)photos
                     delegate:(id<FAFADsViewDelegate>)delegate
               placeHolderStr:(NSString *)placeHolder
                indicatorType:(FAFAdsIndicatorType)type;

- (instancetype)initWithFrame:(CGRect)frame
                       Photos:(NSArray *)photos
                     delegate:(id<FAFADsViewDelegate>)delegate
               placeHolderStr:(NSString *)placeHolder;

@end
