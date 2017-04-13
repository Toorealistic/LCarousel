//
//  LCarousel.h
//  LCarousel
//
//  Created by huang on 2017/4/13.
//  Copyright © 2017年 huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCarousel : NSObject

- (instancetype)initWithFrame:(CGRect)frame
                    superView:(UIView *)superView
                    resources:(NSArray *)resources;


- (void)runCarousel;

@end
