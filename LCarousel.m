//
//  LCarousel.m
//  LCarousel
//
//  Created by huang on 2017/4/13.
//  Copyright © 2017年 huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCarousel.h"

typedef void(^LCarouselViewBlock)(void);

@interface LCarouselView : UIView
{
    LCarouselViewBlock _block;
}

@property (nonatomic, strong) UIImageView *widgetImage;

@property (nonatomic, strong) UILabel *widgetLabel;

- (void)carouselViewClick:(LCarouselViewBlock)block;

@end

@implementation LCarouselView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        LCarouselBgViewConfig *carouselBgViewConfig = [LCarouselConfig carouselConfig].carouselBgViewConfig;
        self.backgroundColor = carouselBgViewConfig.carouselBgViewBackgroundColor;
        self.widgetImage.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.widgetImage];
        self.widgetLabel.frame = CGRectMake(0, frame.size.height - 25, frame.size.width, 25);
        [self addSubview:self.widgetLabel];
    }
    
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_block) {
        LCarouselViewBlock block = [_block copy];
        block();
    }
}

- (void)carouselViewClick:(LCarouselViewBlock)block {
    if (block) {
        _block = block;
    }
}

- (UIImageView *)widgetImage {
    if (!_widgetImage) {
        LCarouselImageViewConfig *carouselImageViewConfig = [LCarouselConfig carouselConfig].carouselImageViewConfig;
        _widgetImage = [[UIImageView alloc] init];
        _widgetImage.backgroundColor = carouselImageViewConfig.carouselImageViewBackgroundColor;
        _widgetImage.contentMode = carouselImageViewConfig.carouselImageViewContentMode;
        _widgetImage.clipsToBounds = carouselImageViewConfig.carouselImageViewClipsToBounds;
        _widgetImage.userInteractionEnabled = YES;
    }
    
    return _widgetImage;
}

- (UILabel *)widgetLabel {
    if (!_widgetLabel) {
        LCarouselTitleViewConfig *carouselTitleViewConfig = [LCarouselConfig carouselConfig].carouselTitleViewConfig;
        _widgetLabel = [[UILabel alloc] init];
        _widgetLabel.backgroundColor = carouselTitleViewConfig.carouselTitleViewBackgroundColor;
        _widgetLabel.alpha = carouselTitleViewConfig.carouselTitleViewAlpha;
        _widgetLabel.textColor = carouselTitleViewConfig.carouselTitleViewTextColor;
        _widgetLabel.font = carouselTitleViewConfig.carouselTitleViewFont;
    }
    
    return _widgetLabel;
}

@end

@interface LCarousel ()<UIScrollViewDelegate>
{
    LCarouselBlock _carouselBlock;
}

@property (nonatomic, strong) UIScrollView *carouselView;

@property (nonatomic, strong) NSArray *resources;

@property (nonatomic, assign) NSInteger nowPage;

@property (nonatomic, strong) UIPageControl *pageControl;

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

- (void)resumeCarousel:(LCarouselBlock)block {
    
    if (self.timer) {
        dispatch_resume(_timer);
    }
    
    if (block) {
        _carouselBlock = block;
    }
}

- (void)cancelCarousel {
    if (self.timer) {
        dispatch_cancel(_timer);
    }
}

- (UIScrollView *)carouselView {
    if (!_carouselView) {
        LCarouselScrollViewConfig *carouselScrollViewConfig = [LCarouselConfig carouselConfig].carouselScrollViewConfig;
        _carouselView = [[UIScrollView alloc] init];
        _carouselView.backgroundColor = carouselScrollViewConfig.carouselScrollViewBackgroundColor;
        _carouselView.userInteractionEnabled = YES;
        _carouselView.delegate = self;
        _carouselView.pagingEnabled = YES;
        _carouselView.showsVerticalScrollIndicator = NO;
        _carouselView.showsHorizontalScrollIndicator = NO;
    }
    
    return _carouselView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        CGRect frame = _carouselView.frame;
        LCarouselPageControlConfig *carouselPageControlConfig = [LCarouselConfig carouselConfig].carouselPageControlConfig;
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height - 25, frame.size.width, 25);
        _pageControl.alpha = carouselPageControlConfig.carouselPageControlAlpha;
        _pageControl.backgroundColor = carouselPageControlConfig.carouselPageControlBackgroundColor;
        _pageControl.pageIndicatorTintColor = carouselPageControlConfig.carouselPageControlPageIndicatorTintColor;
        _pageControl.currentPageIndicatorTintColor = carouselPageControlConfig.carouselPageControlCurrentPageIndicatorTintColor;
        [_pageControl addTarget:self action:@selector(pageControlAct:) forControlEvents:UIControlEventValueChanged];
        _pageControl.accessibilityValue = @"carouselPageControl";
        [_carouselView.superview addSubview:_pageControl];
    }
    
    return _pageControl;
}

- (dispatch_source_t)timer {
    if (!_timer) {
        LCarouselTimerConfig *carouselTimerConfig = [LCarouselConfig carouselConfig].carouselTimerConfig;
        dispatch_queue_t queue = dispatch_queue_create("carousel", 0);
        _timer =  dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, carouselTimerConfig.carouselTimerInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_timer, ^{
            [self carouselRun];
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
        LCarouselView *view = (LCarouselView *)[_carouselView viewWithTag:100 + i];
        if (!view) {
            view = [[LCarouselView alloc] initWithFrame:CGRectMake(i * frame.size.width, 0, frame.size.width, frame.size.height)];
            [_carouselView addSubview:view];
        }
        [view carouselViewClick:^{
            if (_carouselBlock) {
                LCarouselBlock block = [_carouselBlock copy];
                block (_resources[_nowPage], _nowPage);
            }
        }];
        
        if ([dict[@"placeholderImage"] length] > 0) {
            NSString *placeholderImage = dict[@"placeholderImage"];
            view.widgetImage.image = [UIImage imageNamed:placeholderImage];
        }
        
        if ([dict[@"URL"] length] > 0 && (i != 0 || i != (array.count - 1))) {
            NSString *URLString = dict[@"URL"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
                NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30];
                NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                                            if (!error && responseCode == 200) {
                                                                UIImage *image = [UIImage imageWithData:data];
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    view.widgetImage.image = image;
                                                                });
                                                            }
                                                        }];
                [task resume];
            });
        }
        
        if ([dict[@"title"] length] > 0) {
            NSString *title = dict[@"title"];
            view.widgetLabel.text = title;
        }
    }
    
    self.pageControl.numberOfPages = _resources.count;
    CGFloat pageControlWidth = [_pageControl sizeForNumberOfPages:array.count].width;
    _pageControl.frame = CGRectMake(frame.origin.x + (frame.size.width - pageControlWidth), _pageControl.frame.origin.y, pageControlWidth, _pageControl.frame.size.height);
    _carouselView.contentSize = CGSizeMake(array.count * frame.size.width, 0);
    _nowPage = -1;
}

- (void)carouselRun {
    CGRect frame = _carouselView.frame;
    NSInteger num = _nowPage + 2 ;
    [_carouselView setContentOffset:CGPointMake(frame.size.width * num, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = _carouselView.frame;
    if (scrollView.contentOffset.x <= 0) {
        [_carouselView setContentOffset:CGPointMake(frame.size.width * _resources.count, 0) animated:NO];
    } else if (scrollView.contentOffset.x >= frame.size.width * (_resources.count + 1)) {
        [_carouselView setContentOffset:CGPointMake(frame.size.width, 0) animated:NO];
    }
    
    _nowPage = scrollView.contentOffset.x / frame.size.width - 1;
    _pageControl.currentPage = _nowPage;
}

#pragma mark - UIPageControl事件
- (void)pageControlAct:(UIPageControl *)sender
{
    NSInteger pageNum = sender.currentPage;
    if (_nowPage == pageNum) {
        return;
    }
    CGRect frame = _carouselView.frame;
    [_carouselView setContentOffset:CGPointMake((pageNum + 1) * frame.size.width, 0)];
}

@end
