//
//  HYCarousel.h
//  HYCarousel
//
//  Created by HEYANG on 16/4/5.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import <UIKit/UIKit.h>


//  需求：1、能够自动开始轮播
//       2、能够自定义设置时间间隔
//       3、点击轮播器的对应的图片，能够触发事件，实际可能会有的需求：广告跳转
//       4、提供公开的数组属性，这个数组就是存储网络返回来的字典数据


@interface HYCarousel : UIView
/**   */

/** 存储数据的数组 */
@property (nonatomic,strong)NSArray *carouselList;

/** 设置轮播器自动轮播一页的时间间隔 */
@property (nonatomic, assign) CGFloat carouselTimeInterval;

/** 是否自动轮播  */
@property (nonatomic, assign) BOOL isAutoCarousel;

@end




// 在工程中使用该HYCarousel控件的时候，为了避免计时器类别文件会与工程中的NSTimer(Addition)文件冲突，所以，这里本人将其单独抽离出来，放在这里
// 并且在方法名前适当的添加前缀hy_ ,这也是避免类别方法冲突。

/**
 *  提供计时器的开始和暂停的操作
 */

@interface NSTimer (HYAddition)

- (void)hy_pauseTimer;
- (void)hy_resumeTimer;
- (void)hy_resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end