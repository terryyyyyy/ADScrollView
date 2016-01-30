//
//  ViewController.m
//  ADScrollViewExample
//
//  Created by everyWood on 16/1/30.
//

#import "ViewController.h"
#import "ADScrollView.h"
#define kADSviewTag 10000

@interface ViewController ()<ADScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat ScrenW = self.view.bounds.size.width;
    NSArray *AD1Array = @[@"http://img3.imgtn.bdimg.com/it/u=4267841340,2720552563&fm=206&gp=0.jpg",@"http://pic31.nipic.com/20130719/2531170_210952222000_2.jpg",@"http://img0.imgtn.bdimg.com/it/u=1130142371,509737531&fm=206&gp=0.jpg",@"http://img4.imgtn.bdimg.com/it/u=2659806443,1632006785&fm=206&gp=0.jpg"];
    NSArray *AD2Array = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg",];
    NSArray *AD3Array = @[@"http://img3.imgtn.bdimg.com/it/u=4267841340,2720552563&fm=206&gp=0.jpg",@"1.jpg",@"2.jpg",@"http://pic31.nipic.com/20130719/2531170_210952222000_2.jpg",@"4.jpg",@"5.jpg"];
    
    //网络图片轮播
    ADScrollView *AD1 = [[ADScrollView alloc] initWithFrame:CGRectMake(0, 40, ScrenW, 180) Photos:AD1Array delegate:self placeHolderStr:@"placeHolder" indicatorType:AdsIndicatorTypeNumber indicatorAlignment:IndicatorAlignmentMiddle];
    AD1.tag = kADSviewTag;
    [self.view addSubview:AD1];
    
    //本地图片轮播
    ADScrollView *AD2 = [[ADScrollView alloc] initWithFrame:CGRectMake(0, 240, ScrenW, 180) Photos:AD2Array delegate:self placeHolderStr:@"placeHolder" indicatorType:AdsIndicatorTypeWhiteDot indicatorAlignment:IndicatorAlignmentRight];
    AD2.timeIntevel = 5;
    AD2.tag = kADSviewTag + 1;
    [self.view addSubview:AD2];
    
    //混合图片轮播
    ADScrollView *AD3 = [[ADScrollView alloc] initWithFrame:CGRectMake(0, 440, ScrenW, 180) Photos:AD3Array delegate:self placeHolderStr:@"placeHolder"];
    AD3.timeIntevel = 2;
    AD3.tag = kADSviewTag + 2;
    [self.view addSubview:AD3];
}


- (void)ADsView:(ADScrollView *)ADSview didSelectImageOfIndex:(NSNumber *)index
{
    switch (ADSview.tag) {
        case kADSviewTag:
            NSLog(@"网络图片第%@张被点击",index);
            break;
        case kADSviewTag + 1:
            NSLog(@"本地图片第%@张被点击",index);
            break;
        case kADSviewTag + 2:
            NSLog(@"混合图片第%@张被点击",index);
            break;
        default:
            break;
    }
}

@end
