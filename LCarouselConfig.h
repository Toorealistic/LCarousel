//
//  LCarouselConfig.h
//  LCarousel
//
//  Created by huang on 2017/4/14.
//  Copyright © 2017年 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LCarouselTimerConfig;
@class LCarouselScrollViewConfig;
@class LCarouselBgViewConfig;
@class LCarouselImageViewConfig;
@class LCarouselTitleViewConfig;
@class LCarouselPageControlConfig;

@interface LCarouselConfig : NSObject

+ (LCarouselConfig *)carouselConfig;

@property (nonatomic, readwrite, strong) LCarouselTimerConfig *carouselTimerConfig;
@property (nonatomic, readwrite, strong) LCarouselScrollViewConfig *carouselScrollViewConfig;
@property (nonatomic, readwrite, strong) LCarouselBgViewConfig *carouselBgViewConfig;
@property (nonatomic, readwrite, strong) LCarouselImageViewConfig *carouselImageViewConfig;
@property (nonatomic ,readwrite, strong) LCarouselTitleViewConfig *carouselTitleViewConfig;
@property (nonatomic, readwrite, strong) LCarouselPageControlConfig *carouselPageControlConfig;

@end

@interface LCarouselTimerConfig : NSObject

/**
 滚动间隔
 */
@property (nonatomic, readwrite, assign) CGFloat carouselTimerInterval;

@end

@interface LCarouselScrollViewConfig : NSObject

/**
 背景色
 */
@property (nonatomic, readwrite, strong) UIColor *carouselScrollViewBackgroundColor;

@end

@interface LCarouselBgViewConfig : NSObject

/**
 背景色
 */
@property (nonatomic, readwrite, strong) UIColor *carouselBgViewBackgroundColor;

@end

@interface LCarouselImageViewConfig : NSObject

/**
 背景色
 */
@property (nonatomic, readwrite, strong) UIColor *carouselImageViewBackgroundColor;

/**
 图片适应
 */
@property (nonatomic, readwrite) UIViewContentMode carouselImageViewContentMode;

/**
 是否裁剪
 */
@property (nonatomic, readwrite) BOOL carouselImageViewClipsToBounds;

@end

@interface LCarouselTitleViewConfig : NSObject

/**
 背景色
 */
@property (nonatomic, readwrite, strong) UIColor *carouselTitleViewBackgroundColor;

/**
 透明度
 */
@property (nonatomic, readwrite, assign) CGFloat carouselTitleViewAlpha;

/**
 字体颜色
 */
@property (nonatomic, readwrite, strong) UIColor *carouselTitleViewTextColor;

/**
 字体
 */
@property (nonatomic, readwrite, strong) UIFont *carouselTitleViewFont;

@end

@interface LCarouselPageControlConfig : NSObject

/**
 是否显示
 */
@property (nonatomic, readwrite) BOOL isShow;

/**
 指示器颜色
 */
@property (nonatomic, readwrite, strong) UIColor *carouselPageControlPageIndicatorTintColor;

/**
 当前的页的颜色
 */
@property (nonatomic, readwrite, strong) UIColor *carouselPageControlCurrentPageIndicatorTintColor;

/**
 背景色
 */
@property (nonatomic, readwrite, strong) UIColor *carouselPageControlBackgroundColor;

/**
 透明度
 */
@property (nonatomic, readwrite, assign) CGFloat carouselPageControlAlpha;

@end
