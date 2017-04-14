//
//  LCarouselConfig.m
//  LCarousel
//
//  Created by huang on 2017/4/14.
//  Copyright © 2017年 huang. All rights reserved.
//

#import "LCarouselConfig.h"

@implementation LCarouselConfig

+ (LCarouselConfig *)carouselConfig {
    static LCarouselConfig *_config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _config = [[self alloc] init];
        _config.carouselTimerConfig = [[LCarouselTimerConfig alloc] init];
        _config.carouselScrollViewConfig = [[LCarouselScrollViewConfig alloc] init];
        _config.carouselBgViewConfig = [[LCarouselBgViewConfig alloc] init];
        _config.carouselImageViewConfig = [[LCarouselImageViewConfig alloc] init];
        _config.carouselTitleViewConfig = [[LCarouselTitleViewConfig alloc] init];
        _config.carouselPageControlConfig = [[LCarouselPageControlConfig alloc] init];
    });
    
    return _config;
}

@end

@implementation LCarouselTimerConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.carouselTimerInterval = 3.0f;
    }
    
    return self;
}

@end

@implementation LCarouselScrollViewConfig

- (UIColor *)carouselScrollViewBackgroundColor
{
    if (!_carouselScrollViewBackgroundColor) {
        _carouselScrollViewBackgroundColor = [UIColor whiteColor];
    }
    
    return _carouselScrollViewBackgroundColor;
}

@end

@implementation LCarouselBgViewConfig

- (UIColor *)carouselBgViewBackgroundColor
{
    if (!_carouselBgViewBackgroundColor) {
        _carouselBgViewBackgroundColor = [UIColor whiteColor];
    }
    
    return _carouselBgViewBackgroundColor;
}

@end

@implementation LCarouselImageViewConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.carouselImageViewContentMode = UIViewContentModeScaleAspectFill;
        self.carouselImageViewClipsToBounds = YES;
    }
    
    return self;
}

- (UIColor *)carouselImageViewBackgroundColor
{
    if (!_carouselImageViewBackgroundColor) {
        _carouselImageViewBackgroundColor = [UIColor whiteColor];
    }
    
    return _carouselImageViewBackgroundColor;
}

@end

@implementation LCarouselTitleViewConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.carouselTitleViewAlpha = 0.7f;
    }
    
    return self;
}

- (UIColor *)carouselTitleViewBackgroundColor
{
    if (!_carouselTitleViewBackgroundColor) {
        _carouselTitleViewBackgroundColor = [UIColor blackColor];
    }
    
    return _carouselTitleViewBackgroundColor;
}

- (UIColor *)carouselTitleViewTextColor
{
    if (!_carouselTitleViewTextColor) {
        _carouselTitleViewTextColor = [UIColor whiteColor];
    }
    
    return _carouselTitleViewTextColor;
}

- (UIFont *)carouselTitleViewFont
{
    if (!_carouselTitleViewFont) {
        _carouselTitleViewFont = [UIFont systemFontOfSize:12];
    }
    
    return _carouselTitleViewFont;
}

@end

@implementation LCarouselPageControlConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isShow = YES;
        self.carouselPageControlAlpha = 1.0f;
    }
    
    return self;
}

- (UIColor *)carouselPageControlCurrentPageIndicatorTintColor
{
    if (!_carouselPageControlCurrentPageIndicatorTintColor) {
        _carouselPageControlCurrentPageIndicatorTintColor = [UIColor colorWithRed:0 green:0.52549 blue:0.862745 alpha:1];
    }
    
    return _carouselPageControlCurrentPageIndicatorTintColor;
}

- (UIColor *)carouselPageControlPageIndicatorTintColor
{
    if (!_carouselPageControlPageIndicatorTintColor) {
        _carouselPageControlPageIndicatorTintColor = [UIColor colorWithRed:0.760784 green:0.788235 blue:0.8 alpha:1];
    }
    
    return _carouselPageControlPageIndicatorTintColor;
}

- (UIColor *)carouselPageControlBackgroundColor
{
    if (!_carouselPageControlBackgroundColor) {
        _carouselPageControlBackgroundColor = [UIColor clearColor];
    }
    
    return _carouselPageControlBackgroundColor;
}

@end

