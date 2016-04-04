//
//  HYCarousel.m
//  HYCarousel
//
//  Created by HEYANG on 16/4/5.
//  Copyright © 2016年 HEYANG. All rights reserved.
//
//  cnBlog:http://www.cnblogs.com/goodboy-heyang/
//  github:https://github.com/HeYang123456789
//

#import "HYCarousel.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT 568
#define IMAGEVIEW_COUNT 3

@interface HYCarousel ()<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    UIImageView *_leftImageView;
    UIImageView *_centerImageView;
    UIImageView *_rightImageView;
    UIPageControl *_pageControl;
    UILabel *_label;
    NSMutableDictionary *_imageData;//图片数据
    int _currentImageIndex;//当前图片索引
    int _imageCount;//图片总数
}

/** NSTimer */
@property (nonatomic,strong)NSTimer *timer;

@end

@implementation HYCarousel

#pragma mark - 初始化方法
// 加载xib会调用的这个初始化方法
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}
// 代码创建HYCarousel控件会调用的这个初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - 私有方法
- (void)setUp{
    //加载数据
    [self loadImageData];
    //添加滚动控件
    [self addScrollView];
    //添加图片控件
    [self addImageViews];
    //添加分页控件
    [self addPageControl];
    //添加图片信息描述控件
    [self addLabel];
    //加载默认图片
    [self setDefaultImage];
    //添加计时器
    [self useTimer];
}
#pragma mark - 使用计时器
-(void)useTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.carouselTimeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}

-(void)nextPage{
    NSLog(@"开始切换到下一页%lf",_scrollView.contentOffset.x);
    
    [_scrollView setContentOffset:CGPointMake(2 * SCREEN_WIDTH, 0) animated:YES];
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}

#pragma mark 加载图片数据
-(void)loadImageData{
    
    //读取程序包路径中的资源文件
    NSString *path=[[NSBundle mainBundle] pathForResource:@"imageInfo" ofType:@"plist"];
    _imageData=[NSMutableDictionary dictionaryWithContentsOfFile:path];
    _imageCount=(int)_imageData.count;
}

#pragma mark 添加控件
-(void)addScrollView{
    _scrollView=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self addSubview:_scrollView];
    //设置代理
    _scrollView.delegate=self;
    //设置contentSize
    _scrollView.contentSize=CGSizeMake(IMAGEVIEW_COUNT*SCREEN_WIDTH, SCREEN_HEIGHT) ;
    //设置当前显示的位置为中间图片
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    //设置分页
    _scrollView.pagingEnabled=YES;
    //去掉滚动条
    _scrollView.showsHorizontalScrollIndicator=NO;
}

#pragma mark 添加图片三个控件
-(void)addImageViews{
    // 左边分页
    _leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _leftImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_leftImageView];
    // 中间分页
    _centerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _centerImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_centerImageView];
    // 右边分页
    _rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _rightImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_rightImageView];
}
#pragma mark 设置默认显示图片
-(void)setDefaultImage{
    //加载默认图片
    _leftImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",_imageCount-1]];
    _centerImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",0]];
    _rightImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",1]];
    _currentImageIndex=0;
    //设置当前页
    _pageControl.currentPage=_currentImageIndex;
    NSString *imageName=[NSString stringWithFormat:@"%i.jpg",_currentImageIndex];
    _label.text=_imageData[imageName];
}

#pragma mark 添加分页控件
// 分页控制器的个数要根据图片的个数而决定
-(void)addPageControl{
    _pageControl=[[UIPageControl alloc]init];
    //注意此方法可以根据页数返回UIPageControl合适的大小
    CGSize size= [_pageControl sizeForNumberOfPages:_imageCount];
    _pageControl.bounds=CGRectMake(0, 0, size.width, size.height);
    _pageControl.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-100);
    //设置颜色
    _pageControl.pageIndicatorTintColor=[UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
    //设置当前页颜色
    _pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    //设置总页数
    _pageControl.numberOfPages=_imageCount;
    
    [self addSubview:_pageControl];
}

#pragma mark 添加信息描述控件
-(void)addLabel{
    
    _label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH,30)];
    _label.textAlignment=NSTextAlignmentCenter;
    _label.textColor=[UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    
    [self addSubview:_label];
}

#pragma mark 滚动事件
//滚动停止事件
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //重新加载图片
    [self reloadImage];
    //移动到中间
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    //设置分页
    _pageControl.currentPage=_currentImageIndex;
    //设置描述
    NSString *imageName=[NSString stringWithFormat:@"%i.jpg",_currentImageIndex];
    _label.text=_imageData[imageName];
    NSLog(@"偏移量：%lf",_scrollView.contentOffset.x);
}
// 开始拖拽的时候 需要计时器暂停
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer hy_pauseTimer];
}
// 结束拖拽的时候，需要开启定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.timer hy_resumeTimer];
}

#pragma mark 重新加载图片
-(void)reloadImage{
    int leftImageIndex,rightImageIndex;
    CGPoint offset=[_scrollView contentOffset];
    if (offset.x>SCREEN_WIDTH) { //向右滑动
        _currentImageIndex=(_currentImageIndex+1)%_imageCount;
    }else if(offset.x<SCREEN_WIDTH){ //向左滑动
        _currentImageIndex=(_currentImageIndex+_imageCount-1)%_imageCount;
    }
    //UIImageView *centerImageView=(UIImageView *)[_scrollView viewWithTag:2];
    _centerImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",_currentImageIndex]];
    
    //重新设置左右图片
    leftImageIndex=(_currentImageIndex+_imageCount-1)%_imageCount;
    rightImageIndex=(_currentImageIndex+1)%_imageCount;
    _leftImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",leftImageIndex]];
    _rightImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",rightImageIndex]];
}

#pragma mark - set和get方法
-(CGFloat)carouselTimeInterval{
    if (_carouselTimeInterval == 0.0) {
        _carouselTimeInterval = 2.0f;
    }
    return _carouselTimeInterval;
}

@end


@implementation NSTimer (HYAddition)

-(void)hy_pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


-(void)hy_resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)hy_resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end