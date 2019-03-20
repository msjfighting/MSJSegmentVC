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
@end
@implementation NewsViewController
- (NSMutableArray *)titleLabels{
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpChildViewController];
    
   // 添加所有的子控制器对应的标题
    [self setUpTitle];
    
    // ios7会给导航控制器下的所有UIScrollView顶部添加额外滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 初始化scrollview
    [self setUpScrollView];
}
- (void)setUpScrollView{
    // 水平方向滚动
     NSUInteger count = self.childViewControllers.count;
    self.titleScrollView.contentSize = CGSizeMake(labelW * count, 0);
    // 隐藏水平滚动条
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
    self.contentScrollView.contentSize = CGSizeMake(MSJScreenWidth * count, 0);
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    
    // 开启分页效果
    self.contentScrollView.pagingEnabled = YES;
    // 关闭弹簧效果
    self.contentScrollView.bounces = NO;
    self.contentScrollView.delegate = self;
    
}
- (void)setUpTitle{
    NSUInteger count = self.childViewControllers.count;
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    for (int i = 0; i < count; i++) {
        UILabel *label = [[UILabel alloc] init];
        labelX = i * labelW;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.childViewControllers[i].title;
       // 默认不允许交互
        label.userInteractionEnabled = YES;
        label.highlightedTextColor = [UIColor redColor];
        label.tag = i;
       // 添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        [label addGestureRecognizer:tap];
        
        if (i == 0) {
            [self titleClick:tap];
        }
        [self.titleLabels addObject:label];
        [self.titleScrollView addSubview:label];
    }
}
- (void)setUpTitleCenter:(UILabel *)centerLabel{
    CGFloat offsetX = centerLabel.center.x - MSJScreenWidth * 0.5;
    if (offsetX <= 0) offsetX = 0;
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - MSJScreenWidth;
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 计算滚动到那一页
    CGFloat curPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    // 左边label角标
    NSInteger leftIndex = curPage;
    
    // 右边label角标
    NSInteger rigthIndex = curPage + 1;
    
    UILabel *leftLabel = self.titleLabels[leftIndex];
    UILabel *rightLabel;
    if (rigthIndex < self.titleLabels.count - 1) {
        rightLabel = self.titleLabels[rigthIndex];
    }
    
    // 计算右边缩放比例
    CGFloat rightScale = curPage - leftIndex;
    
    // 计算左边缩放比例
    CGFloat leftScale = 1 - rightScale;
    
    leftLabel.transform = CGAffineTransformMakeScale(leftScale * 0.3 + 1, leftScale * 0.3 + 1);
    
    rightLabel.transform = CGAffineTransformMakeScale(rightScale * 0.3 + 1, rightScale * 0.3 + 1);
    
    // 文字颜色渐变
    // 黑色: 0 0 0
    // 红色: 1 0 0
    leftLabel.textColor = [UIColor colorWithRed:leftScale green:0 blue:0 alpha:1.0];
    
    rightLabel.textColor = [UIColor colorWithRed:rightScale green:0 blue:0 alpha:1.0];
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / scrollView.bounds.size.width;
    
    // 把对应的标题选中
    UILabel *label = self.titleLabels[index];
    [self selectLabel:label];
    
    // 获取对应子控制的view
    [self showVC:index];
    
    [self setUpTitleCenter:label];

}
- (void)showVC:(NSInteger)index{
    CGFloat offsetX = index * MSJScreenWidth;
    // 给对应的位置添加对应的子控制器
    UIViewController *vc = self.childViewControllers[index];
    
    // 判断控制器是否加载过
    if (vc.isViewLoaded) return;
    vc.view.frame = CGRectMake(offsetX, 0, self.contentScrollView.bounds.size.width, self.contentScrollView.bounds.size.height);
    [self.contentScrollView addSubview:vc.view];
}
- (void)titleClick:(UITapGestureRecognizer *)tap{
    // 设置选中的label高亮状态下的颜色
    UILabel * selLabel = (UILabel *)tap.view;
    [self selectLabel:selLabel];
    
    // 滚动到的位置
    NSInteger index = selLabel.tag;
    // 计算滚动的位置
    CGFloat offsetX = index * MSJScreenWidth;
    self.contentScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    // 给对应的位置添加对应的子控制器
     [self showVC:index];
    
    [self setUpTitleCenter:selLabel];

}
// 选中label高亮
- (void)selectLabel:(UILabel *)label{
    // 取消之前形变
    _selLabel.transform = CGAffineTransformIdentity;
    // 取消之前高亮
    _selLabel.highlighted = NO;
    
    // 颜色恢复
    _selLabel.textColor = [UIColor blackColor];
    
    label.highlighted = YES;
    label.transform = CGAffineTransformMakeScale(radio, radio);
    _selLabel = label;
}
- (void)setUpChildViewController{
    TopLineViewController *top = [[TopLineViewController alloc] init];
    top.title = @"头条";
    [self addChildViewController:top];
    
    HotViewController *hot = [[HotViewController alloc] init];
     hot.title = @"热门";
    [self addChildViewController:hot];
    
    VideoViewController *video = [[VideoViewController alloc] init];
     video.title = @"视频";
    [self addChildViewController:video];
    
    SocialViewController *social = [[SocialViewController alloc] init];
     social.title = @"社会";
    [self addChildViewController:social];
    
    ReaderViewController *read = [[ReaderViewController alloc] init];
     read.title = @"阅读";
    [self addChildViewController:read];
    
    ScienceViewController *science = [[ScienceViewController alloc] init];
     science.title = @"科技";
    [self addChildViewController:science]; 
}


@end
