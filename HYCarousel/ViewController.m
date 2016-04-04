//
//  ViewController.m
//  HYCarousel
//
//  Created by HEYANG on 16/4/5.
//  Copyright © 2016年 HEYANG. All rights reserved.
//
//  cnBlog:http://www.cnblogs.com/goodboy-heyang/
//  github:https://github.com/HeYang123456789
//

#import "ViewController.h"
#import "HYCarousel.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HYCarousel* carousel = [[HYCarousel alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:carousel];
    
}

@end
