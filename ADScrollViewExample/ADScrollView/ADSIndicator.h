//
//  AdsIndicator.h
//
//  Created by everyWood on 15/12/21.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AdsIndicatorType) {
    AdsIndicatorTypeNone,
    AdsIndicatorTypeNumber,
    AdsIndicatorTypeWhiteDot
};

typedef NS_ENUM(NSUInteger, IndicatorAlignment) {
    IndicatorAlignmentLeft = -1,
    IndicatorAlignmentMiddle = 0,
    IndicatorAlignmentRight = 1
};
@interface ADSIndicator : UIView

/**
 *  当前展示的广告的索引
 */
@property (nonatomic,assign) NSInteger currentIndex;

/**
 *  初始化方法
 *
 *  @param frame    展示的frame
 *  @param totalNum 所展示的广告的总数
 *  @param type     展示的类型，
 *
 *  @return 返回索引
 */
- (instancetype)initWithADViewFrame:(CGRect)frame alignment:(IndicatorAlignment)alignment totalNum:(NSInteger)totalNum andType:(AdsIndicatorType)type;

@end
