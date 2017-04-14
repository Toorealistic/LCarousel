//
//  LCarousel.h
//  LCarousel
//
//  Created by huang on 2017/4/13.
//  Copyright © 2017年 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCarouselConfig.h"

typedef void(^LCarouselBlock)(NSDictionary *, NSInteger);

@interface LCarousel : NSObject

/**
 初始化轮播控件

 @param frame 轮播frame
 @param superView 轮播的父视图
 @param resources 轮播展示的资源 URL为地址图片、placeholderImage为本地图片、title为图片所对应标题
 @return 轮播控件LCarousel
 */
- (instancetype)initWithFrame:(CGRect)frame
                    superView:(UIView *)superView
                    resources:(NSArray *)resources;


/**
 必须初始化后再进行启动轮播自动翻滚

 @param block 每张图片点击后返回对应的内容和标识num
 */
- (void)resumeCarousel:(LCarouselBlock)block;

/**
 取消轮播自动翻滚
 */
- (void)cancelCarousel;

@end
