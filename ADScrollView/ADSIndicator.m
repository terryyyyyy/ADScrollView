//
//  AdsIndicator.m
//
//  Created by everyWood on 15/12/21.
//

#import "ADSIndicator.h"

@interface ADSIndicator()

/**
 *  索引的类型
 */
@property (nonatomic,assign) AdsIndicatorType indicatorType;


@property (nonatomic,strong)UILabel *indexLabel;
@property (nonatomic,strong)UIPageControl *pageView;
@property (nonatomic,assign) NSInteger totalNum;
@end

@implementation ADSIndicator

- (instancetype)initWithADViewFrame:(CGRect)frame alignment:(IndicatorAlignment)alignment totalNum:(NSInteger)totalNum andType:(AdsIndicatorType)type
{
    CGFloat barHeight = 20;
    CGFloat y = frame.origin.y + frame.size.height - barHeight;
    CGRect selfFrame = CGRectMake(frame.origin.x, y, frame.size.width, barHeight);
    
    if (self = [super initWithFrame:selfFrame]) {
        self.indicatorType = type;
        self.totalNum = totalNum;
        self.frame = selfFrame;
        self.backgroundColor = [UIColor clearColor];
        switch (type) {
            case AdsIndicatorTypeNone: {
                [self removeFromSuperview];
                break;
            }
            case AdsIndicatorTypeNumber: {
                self.indexLabel = [[UILabel alloc]initWithFrame:self.bounds];
                _indexLabel.font = [UIFont boldSystemFontOfSize:16];
                switch (alignment) {
                    case IndicatorAlignmentLeft: {
                        _indexLabel.frame = CGRectMake(0, 0, 50, self.bounds.size.height);
                        break;
                    }
                    case IndicatorAlignmentMiddle: {
                        _indexLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
                        break;
                    }
                    case IndicatorAlignmentRight: {
                        _indexLabel.frame = CGRectMake(self.bounds.size.width - 50, 0, 50, self.bounds.size.height);
                        break;
                    }
                    default: {
                        break;
                    }
                }
                _indexLabel.backgroundColor = [UIColor clearColor];
                _indexLabel.textColor = [UIColor whiteColor];
                _indexLabel.textAlignment = NSTextAlignmentCenter;
                _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                _indexLabel.text = [NSString stringWithFormat:@"1/%ld",totalNum];
                [self addSubview:_indexLabel];
                break;
            }
            case AdsIndicatorTypeWhiteDot: {
                self.pageView = [[UIPageControl alloc] init];
                _pageView.numberOfPages = totalNum;
                CGSize pageSize = [_pageView sizeForNumberOfPages:totalNum];
                switch (alignment) {
                    case IndicatorAlignmentLeft: {
                        _pageView.frame = CGRectMake(15, 0, pageSize.width, self.bounds.size.height);
                        break;
                    }
                    case IndicatorAlignmentMiddle: {
                        _pageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
                        break;
                    }
                    case IndicatorAlignmentRight: {
                        _pageView.frame = CGRectMake(self.bounds.size.width - pageSize.width - 15, 0, pageSize.width, self.bounds.size.height);
                        break;
                    }
                    default: {
                        break;
                    }
                }
                [self addSubview:_pageView];
                break;
            }
            default: {
                break;
            }
        }
        return self;
    }
    return nil;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    switch (self.indicatorType) {
        case AdsIndicatorTypeNone: {
            
            break;
        }
        case AdsIndicatorTypeNumber: {
            if (!self.indexLabel) break;
            self.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",currentIndex,_totalNum];
            break;
        }
        case AdsIndicatorTypeWhiteDot: {
            if (!self.pageView) break;
            self.pageView.currentPage = currentIndex - 1;
            break;
        }
        default: {
            break;
        }
    }
}

@end
