# LCarousel
自动轮播

使用方法 Example

1.初始化
LCarousel *carousel = [[LCarousel alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, 150) superView:self.view resources:@[@{@"URL" : @"https://testkqyy.zwjk.com/hospital/641/20161202/1480663013550.png", @"title" : @"test1"}, @{@"placeholderImage" : @"2.jpg", @"title" : @"test2"}, @{@"placeholderImage" : @"3.jpg", @"title" : @"test3"}, @{@"placeholderImage" : @"4.jpg", @"title" : @"test4"}]];

2.自动滚动
[carousel resumeCarousel:^(NSDictionary *dict, NSInteger num) {
        NSLog(@"%i = %@", (int)num, dict);
    }];
    
3.个性化轮播里的控件背景颜色等，请在LCarousel初始化前根据LCarouselConfig里面提供的属性进行修改。
Example

LCarouselPageControlConfig *carouselPageControlConfig = [LCarouselConfig carouselConfig].carouselPageControlConfig;
carouselPageControlConfig.carouselPageControlCurrentPageIndicatorTintColor = [UIColor blackColor];
