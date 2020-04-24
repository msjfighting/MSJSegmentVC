//
//  MSJSegmentView.h
//  优券享
//
//  Created by YQX on 2019/4/9.
//  Copyright © 2019 YQX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSJSegmentView : UIView

+(instancetype)shareSegment;
- (void)setSegmentWithTitle:(NSArray *)titles rigthImage:(NSString *)imageName childViewControllers:(NSArray<__kindof UIViewController *>*)childViewControllers rightBtnSelectorName:(NSString *)selectorName;
@property (nonatomic,assign) CGFloat titleFont;
@property (nonatomic,strong) UIColor * titleColor;
@property (nonatomic,strong) UIColor * titleHlightedColor;

@property (nonatomic,assign) NSInteger  defaultIndex;
- (void)clickItem:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
