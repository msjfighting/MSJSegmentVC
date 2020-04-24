//
//  NewsViewController.m
//  MSJSegmentViewController
//
//  Created by zlhj on 2019/3/20.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import "NewsViewController.h"
#import "TopLineViewController.h"
#import "HotViewController.h"
#import "VideoViewController.h"
#import "SocialViewController.h"
#import "ScienceViewController.h"
#import "ReaderViewController.h"

#import "MSJSegmentView.h"
#define MSJScreenWidth [UIScreen mainScreen].bounds.size.width
#define MSJScreenHeight [UIScreen mainScreen].bounds.size.height
#define MSJTabBarHeight 44
#define MSJNavHeight 64

static CGFloat const labelW = 100;
static CGFloat const labelH = 44;
static CGFloat const radio = 1.3;

@interface NewsViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *titleScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic,strong) UILabel * selLabel;
@property (nonatomic,strong) NSMutableArray * titleLabels;
@property (nonatomic,strong) NSArray * titles;

@property (nonatomic,strong) MSJSegmentView * segmentV;
@end
@implementation NewsViewController
- (NSMutableArray *)titleLabels{
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}
- (MSJSegmentView *)segmentV{
    if (_segmentV == nil) {
        _segmentV = [[MSJSegmentView alloc] initWithFrame:CGRectMake(0, MSJNavHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    return _segmentV;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[@"头条",@"热门",@"视频",@"视频",@"视频",@"视频",@"视频",@"视频"];
    [self setUpChildVC];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segmentV];
    [self.segmentV setSegmentWithTitle:self.titles rigthImage:@"" childViewControllers:self.childViewControllers rightBtnSelectorName:@""];
    
}
- (void)setUpChildVC{
    for (int i = 0; i < self.titles.count ; i++) {
        if (i % 2 == 0) {
            TopLineViewController *vc = [[TopLineViewController alloc] init];
            [self addChildViewController:vc];
        }else{
            HotViewController *vc = [[HotViewController alloc] init];
            [self addChildViewController:vc];
        }
    }
}

//- (void)setUpChildViewController{
//    TopLineViewController *top = [[TopLineViewController alloc] init];
//    top.title = @"头条";
//    [self addChildViewController:top];
//
//    HotViewController *hot = [[HotViewController alloc] init];
//     hot.title = @"热门";
//    [self addChildViewController:hot];
//
//    VideoViewController *video = [[VideoViewController alloc] init];
//     video.title = @"视频";
//    [self addChildViewController:video];
//
//    SocialViewController *social = [[SocialViewController alloc] init];
//     social.title = @"社会";
//    [self addChildViewController:social];
//
//    ReaderViewController *read = [[ReaderViewController alloc] init];
//     read.title = @"阅读";
//    [self addChildViewController:read];
//
//    ScienceViewController *science = [[ScienceViewController alloc] init];
//     science.title = @"科技";
//    [self addChildViewController:science];
//}


@end
