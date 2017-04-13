//
//  LCarousel.m
//  LCarousel
//
//  Created by huang on 2017/4/13.
//  Copyright © 2017年 huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCarousel.h"

@interface LCarouselButton : UIButton

@property (nonatomic, strong) UIImageView *widgetImage;

@property (nonatomic, strong) UILabel *widgetLabel;

@end

@implementation LCarouselButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.widgetImage.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.widgetImage];
        self.widgetLabel.frame = CGRectMake(0, frame.size.height - 25, frame.size.width, 25);
        [self addSubview:self.widgetLabel];
    }
    
    return self;
}

- (UIImageView *)widgetImage {
    if (!_widgetImage) {
        _widgetImage = [[UIImageView alloc] init];
        _widgetImage.contentMode = UIViewContentModeScaleAspectFill;
        _widgetImage.clipsToBounds = YES;
        _widgetImage.userInteractionEnabled = YES;
    }
    
    return _widgetImage;
}

- (UILabel *)widgetLabel {
    if (!_widgetLabel) {
        _widgetLabel = [[UILabel alloc] init];
        _widgetLabel.backgroundColor = [UIColor blackColor];
        _widgetLabel.alpha = 0.7f;
        _widgetLabel.textColor = [UIColor whiteColor];
        _widgetLabel.font = [UIFont systemFontOfSize:12];
    }
    
    return _widgetLabel;
}

@end

@interface LCarousel ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *carouselView;

@property (nonatomic, strong) NSArray *resources;

@property (nonatomic, assign) NSInteger nowPage;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation LCarousel

- (instancetype)initWithFrame:(CGRect)frame
                    superView:(UIView *)superView
                    resources:(NSArray *)resources {
    self = [super init];
    if (self) {
        self.carouselView.frame = frame;
        [superView addSubview:self.carouselView];
        self.resources = resources;
    }
    
    return self;
}

- (void)runCarousel {
    
    if (self.timer) {
        dispatch_resume(_timer);
    }
}

- (UIScrollView *)carouselView {
    if (!_carouselView) {
        _carouselView = [[UIScrollView alloc] init];
        _carouselView.backgroundColor = [UIColor whiteColor];
        _carouselView.delegate = self;
        _carouselView.pagingEnabled = YES;
        _carouselView.showsVerticalScrollIndicator = NO;
        _carouselView.showsHorizontalScrollIndicator = NO;
    }
    
    return _carouselView;
}

- (dispatch_source_t)timer {
    if (!_timer) {
        dispatch_queue_t queue = dispatch_queue_create("carousel", 0);
        _timer =  dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(_timer, ^{
            [weakSelf carouselRun];
        });
    }
    
    return _timer;
}

- (void)setResources:(NSArray *)resources {
    if (resources && resources.count > 0) {
        _resources = resources;
        NSMutableArray *tempArray = [NSMutableArray new];
        [tempArray addObject:[resources lastObject]];
        [tempArray addObjectsFromArray:resources];
        [tempArray addObject:[resources firstObject]];
        
        [self setWidget:tempArray];
    }
#ifdef DEBUG
    else {
        NSLog(@"carousel:============轮播资源文件为空");
    }
#endif
}

- (void)setWidget:(NSArray<NSDictionary *> *)array {
    CGRect frame = _carouselView.frame;
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:array[i]];
        LCarouselButton *button = (LCarouselButton *)[_carouselView viewWithTag:100 + i];
        if (!button) {
            button = [[LCarouselButton alloc] initWithFrame:CGRectMake(i * frame.size.width, 0, frame.size.width, frame.size.height)];
            button.tag = 100 + i;
            [button addTarget:self action:@selector(buttonAct:) forControlEvents:UIControlEventTouchUpInside];
            [_carouselView addSubview:button];
        }
        
        if ([dict[@"placeholderImage"] length] > 0) {
            NSString *placeholderImage = dict[@"placeholderImage"];
            button.widgetImage.image = [UIImage imageNamed:placeholderImage];
        }
        
        if ([dict[@"URL"] length] > 0) {
            NSString *URLString = dict[@"URL"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
                NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30];
                [session dataTaskWithRequest:request
                           completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                               NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                               if (!error && responseCode == 200) {
                                   UIImage *image = [UIImage imageWithData:data];
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       button.widgetImage.image = image;
                                   });
                               }
                           }];
            });
        }
        
        if ([dict[@"title"] length] > 0) {
            NSString *title = dict[@"title"];
            button.widgetLabel.text = title;
        }
    }
    
    _carouselView.contentSize = CGSizeMake(array.count * frame.size.width, 0);
    _nowPage = -1;
}

- (void)carouselRun {
    CGRect frame = _carouselView.frame;
    NSInteger num = _nowPage + 2 ;
    [_carouselView setContentOffset:CGPointMake(frame.size.width * num, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    if (_timer) {
//        dispatch_cancel(_timer);
//    }
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (_timer) {
//        dispatch_resume(_timer);
//    }
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidScroll");
    CGRect frame = _carouselView.frame;
    if (scrollView.contentOffset.x <= 0) {
        [_carouselView setContentOffset:CGPointMake(frame.size.width * _resources.count, 0) animated:NO];
    } else if (scrollView.contentOffset.x >= frame.size.width * (_resources.count + 1)) {
        [_carouselView setContentOffset:CGPointMake(frame.size.width, 0) animated:NO];
    }
    
    _nowPage = scrollView.contentOffset.x / frame.size.width - 1;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndScrollingAnimation");
}


#pragma mark - 轮播点击事件

- (void)buttonAct:(UIButton *)sender {
    
}


@end
