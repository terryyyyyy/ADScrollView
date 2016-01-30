# ADScrollView
一款图片轮播工具
====================================
支持网络图片和本地图片轮播,使用简单，一句话创建图片轮播
-----------------------------------
![演示图片](https://github.com/terryyyyyy/ADScrollView/raw/master/demo.gif)  
###图片下载使用SDWebImage
你可以使用下面几个初始化方法来创建该控件[br]
```
```objective-c
```- (instancetype)initWithFrame:(CGRect)frame
Photos:(NSArray *)photos
delegate:(id<ADScrollViewDelegate>)delegate
placeHolderStr:(NSString *)placeHolder
indicatorType:(AdsIndicatorType)type
indicatorAlignment:(IndicatorAlignment)alignment;
```
---------------------------------------------------------

###另外提供两种方法，提供默认设置.
目前有两种索引类型，可以自行扩展

###第一次写代码到github，希望大家多多支持，有好的建议或者代码的错误请联系我
####我的邮箱：13076010@qq.com