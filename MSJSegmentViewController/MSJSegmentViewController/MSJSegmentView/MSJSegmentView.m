//
//  MSJSegmentView.m
//  优券享
//
//  Created by YQX on 2019/4/9.
//  Copyright © 2019 YQX. All rights reserved.
//

#import "MSJSegmentView.h"
#import "Masonry.h"
#define MSJScreenWidth [UIScreen mainScreen].bounds.size.width
#define MSJScreenHeight [UIScreen mainScreen].bounds.size.height
static CGFloat const labelH = 40;
static CGFloat const radio = 1.2;
static CGFloat const padding = 10;
static CGFloat const lineHeigth = 2;
static CGFloat const btnWidth = 20;
@interface MSJSegmentView ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIButton * searchButton;
@property (nonatomic,strong) NSArray * titles;
@property (nonatomic,strong) UIScrollView * titleScrollView;
@property (nonatomic,strong) UIScrollView * contentScrollView;
@property (nonatomic,strong) UILabel * selLabel;
@property (nonatomic,strong) NSMutableArray * titleLabels;
@property (nonatomic,assign) NSInteger  maxWidth;
@property (nonatomic,strong) UIView * lineView;
@property (nonatomic,strong) UIButton * rigthBtn;

@property (nonatomic,strong) NSArray<__kindof UIViewController *> * childViewControllers;
@property (nonatomic,copy) NSString * imageName;
@property (nonatomic,assign) NSInteger  currentIndex;
@property (nonatomic,assign) BOOL isFirst;
@end

@implementation MSJSegmentView
+ (instancetype)shareSegment{
    static MSJSegmentView *segmentV;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        segmentV = [[MSJSegmentView alloc] init];
    });
    return segmentV;
}
- (NSMutableArray *)titleLabels{
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}
- (UIScrollView *)titleScrollView{
    if (_titleScrollView == nil) {
        _titleScrollView = [[UIScrollView alloc] init];
    }
    return _titleScrollView;
}
- (UIScrollView *)contentScrollView{
    if (_contentScrollView == nil) {
        _contentScrollView = [[UIScrollView alloc] init];
    }
    return _contentScrollView;
}
- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(padding, labelH, 0, lineHeigth)];
        _lineView.backgroundColor = [UIColor colorWithRed:121/255.0 green:176/255.0 blue:224/255.0 alpha:1.0];
    }
    return _lineView;
}
- (UIButton *)rigthBtn{
    if (_rigthBtn == nil) {
        _rigthBtn = [[UIButton alloc] init];
        [_rigthBtn setBackgroundImage:[UIImage imageNamed:self.imageName] forState:UIControlStateNormal];
    }
    return _rigthBtn;
}
- (void)setSegmentWithTitle:(NSArray *)titles rigthImage:(NSString *)imageName childViewControllers:(NSArray<__kindof UIViewController *>*)childViewControllers rightBtnSelectorName:(NSString *)selectorName{
    self.titles = titles;
    self.imageName = imageName;
    if (self.titleFont == 0) {
        self.titleFont = 15;
    }
    
    self.defaultIndex = 0;
    self.childViewControllers = childViewControllers;
    [self setLabel];
    [self setUpScrollView];
    if (selectorName.length != 0) {
        [self.rigthBtn addTarget:[self getCurrentViewController] action:NSSelectorFromString(selectorName) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)setUpScrollView{
    [self addSubview:self.titleScrollView];
    [self.titleScrollView addSubview:self.lineView];
    [self addSubview:self.contentScrollView];
    
    
    [self.titleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.height.equalTo(@(labelH + lineHeigth));
        make.left.equalTo(self);
    }];
    if (self.imageName == nil || self.imageName.length <= 0) {
        [self.titleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self);
        }];
    }else{
        [self addSubview:self.rigthBtn];
        [self.titleScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.frame.size.width - btnWidth));
        }];
        [self.rigthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).equalTo(@(-3));
            make.width.height.equalTo(@(btnWidth));
            make.centerY.equalTo(self.titleScrollView);
        }];
    }
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleScrollView.mas_bottom);
        make.width.equalTo(self);
        make.height.equalTo(self);
        make.left.equalTo(self);
    }];
    
    
    // 水平方向滚动
    NSUInteger count = self.childViewControllers.count;
    self.titleScrollView.contentSize = CGSizeMake(_maxWidth, 0);
    // 隐藏水平滚动条
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    self.titleScrollView.delegate = self;
    self.contentScrollView.contentSize = CGSizeMake(MSJScreenWidth * count, 0);
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    
    // 开启分页效果
    self.contentScrollView.pagingEnabled = YES;
    // 关闭弹簧效果
    self.contentScrollView.bounces = NO;
    self.contentScrollView.delegate = self;
}

#pragma mark 添加label
- (void)setLabel{
    NSInteger count = self.childViewControllers.count;
    for (int i = 0; i < count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.titles[i];
        
        label.font = [UIFont systemFontOfSize:self.titleFont];
        NSInteger width = 0;
        if (count > 4) {
            width = [self getWidthWithText:label.text height:labelH font:self.titleFont];
        } else{
            width = (MSJScreenWidth - padding * (count -1)) /count;
        }
        
        label.frame = CGRectMake(_maxWidth + padding, 0, width, labelH);
        _maxWidth = _maxWidth + width  + padding;
        // 默认不允许交互
        label.userInteractionEnabled = YES;
        if (self.titleHlightedColor == nil) {
            self.titleHlightedColor = [UIColor colorWithRed:219/255.0 green:99/255.0 blue:155/255.0 alpha:1.0];
        }
        if (self.titleColor == nil) {
            self.titleColor = [UIColor colorWithRed:44/255.0 green:44/255.0 blue:44/255.0 alpha:1.0];
        }
        label.textColor = self.titleColor;
        label.highlightedTextColor = self.titleHlightedColor;
        label.tag = i;
        // 添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        [label addGestureRecognizer:tap];
        
        
        [self.titleLabels addObject:label];
        [self.titleScrollView addSubview:label];
        if (i == self.defaultIndex) {
            self.isFirst = YES;
            [self titleClick:tap];
        }
    }
}
- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    return rect.size.width + 30;
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.titleScrollView) return;
    // 计算滚动到那一页
    CGFloat curPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    // 左边label角标
    NSInteger leftIndex = curPage;
    
    // 右边label角标
    NSInteger rigthIndex = curPage + 1;
    
    UILabel *leftLabel = self.titleLabels[leftIndex];
    UILabel *rightLabel;
    if (rigthIndex <= self.titleLabels.count - 1) {
        rightLabel = self.titleLabels[rigthIndex];
    }
    
    
    // 计算右边缩放比例
    CGFloat rightScale = curPage - leftIndex;
    
    // 计算左边缩放比例
    CGFloat leftScale = 1 - rightScale;
    
    leftLabel.transform = CGAffineTransformMakeScale(leftScale * 0.2 + 1, leftScale * 0.2 + 1);
    
    rightLabel.transform = CGAffineTransformMakeScale(rightScale * 0.2 + 1, rightScale * 0.2 + 1);
    
    // 文字颜色渐变
    // 黑色: 0 0 0
    // 红色: 1 0 0
    leftLabel.textColor = [UIColor colorWithRed:leftScale green:0 blue:0 alpha:1.0];
    
    rightLabel.textColor = [UIColor colorWithRed:rightScale green:0 blue:0 alpha:1.0];
    
    
    CGRect frame = self.lineView.frame;
    frame.size.width = (leftLabel.frame.size.width * leftScale) + (rightLabel.frame.size.width * rightScale);
    frame.origin.x = (leftLabel.frame.origin.x * leftScale) + (rightLabel.frame.origin.x * rightScale);
    self.lineView.frame = frame;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.titleScrollView) return;
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / scrollView.bounds.size.width;

    // 把对应的标题选中
    UILabel *label = self.titleLabels[index];
    [self selectLabel:label];
    
    // 获取对应子控制的view
    [self showVC:index];
    
    [self setUpTitleCenter:label];
    
}
#pragma mark 让label居中显示
- (void)setUpTitleCenter:(UILabel *)centerLabel{
    CGFloat offsetX = centerLabel.center.x - MSJScreenWidth * 0.5;
    if (offsetX <= 0) offsetX = 0;
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - MSJScreenWidth + btnWidth;
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}
#pragma mark 显示控制器
- (void)showVC:(NSInteger)index{
    CGFloat offsetX = index * MSJScreenWidth;
    // 给对应的位置添加对应的子控制器
    UIViewController *vc = self.childViewControllers[index];
    
    // 判断控制器是否加载过
    if (vc.isViewLoaded) return;
    vc.view.frame = CGRectMake(offsetX, 0, self.contentScrollView.bounds.size.width, self.contentScrollView.bounds.size.height);
    [self.contentScrollView addSubview:vc.view];
}
- (void)clickItem:(NSString *)title{
    
       NSInteger index =  [self.titles indexOfObject:title];
       UILabel *selLabel = self.titleLabels[index];
        [self selectLabel:selLabel];
        // 滚动到的位置
    
        // 计算滚动的位置
        CGFloat offsetX = index * MSJScreenWidth;
        self.contentScrollView.contentOffset = CGPointMake(offsetX, 0);
    
        // 给对应的位置添加对应的子控制器
        [self showVC:index];
    
        [self setUpTitleCenter:selLabel];
    
        CGRect frame = self.lineView.frame;
        frame.size.width = selLabel.frame.size.width;
        frame.origin.x = selLabel.frame.origin.x;
        self.lineView.frame = frame;
}
#pragma mark 点击事件
- (void)titleClick:(UITapGestureRecognizer *)tap{
   
    // 设置选中的label高亮状态下的颜色
    UILabel * selLabel = (UILabel *)tap.view;
    NSInteger index = selLabel.tag;

    [self selectLabel:selLabel];
    // 滚动到的位置
    
    // 计算滚动的位置
    CGFloat offsetX = index * MSJScreenWidth;
    self.contentScrollView.contentOffset = CGPointMake(offsetX, 0);
 
    // 给对应的位置添加对应的子控制器
    [self showVC:index];
    
    [self setUpTitleCenter:selLabel];

    CGRect frame = self.lineView.frame;
    frame.size.width = selLabel.frame.size.width;
    frame.origin.x = selLabel.frame.origin.x;
    self.lineView.frame = frame;
    
}
#pragma mark 选中label高亮
- (void)selectLabel:(UILabel *)label{
    if (!self.isFirst){
        NSInteger index = label.tag;
        if (index == self.titles.count - 1) {
            UILabel *label = self.titleLabels[index - 1];
            label.textColor = self.titleColor;
            
        }else if (index == 0){
            UILabel *label = self.titleLabels[index + 1];
            label.textColor = self.titleColor;
        }else{
            UILabel *leftlabel = self.titleLabels[index - 1];
            leftlabel.textColor = self.titleColor;
            UILabel *rightlabel = self.titleLabels[index + 1];
            rightlabel.textColor = self.titleColor;
        }
        // 点击同一个标签时不做操作 默认除外
        if (self.currentIndex == label.tag) {
            return;
        }
    }
    // 取消之前形变
    _selLabel.transform = CGAffineTransformIdentity;
    // 取消之前高亮
    _selLabel.highlighted = NO;
    
    // 颜色恢复
    _selLabel.textColor = self.titleColor;
    
    label.highlighted = YES;
    label.transform = CGAffineTransformMakeScale(radio, radio);
    self.currentIndex = label.tag;

    
    _selLabel = label;
    
}
- (UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {if ([next isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)next;
    }
        next = [next nextResponder];
    } while (next !=nil);
    return nil;
}
@end
