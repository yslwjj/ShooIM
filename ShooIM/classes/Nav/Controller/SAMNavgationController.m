//
//  SAMNavgationController.m
//  ShooIM
//
//  Created by 杨森 on 15/8/21.
//  Copyright (c) 2015年 samyang. All rights reserved.
//

#import "SAMNavgationController.h"
#import "SAMMainViewController.h"

@interface SAMNavgationController ()<UIGestureRecognizerDelegate>

@end

@implementation SAMNavgationController

+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    [bar setBarTintColor:SAMRGBColor(251, 92, 51)];
    
    [bar setTintColor:[UIColor whiteColor]];
    
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [bar setTitleTextAttributes:titleAttr];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 防止手势冲突
    self.interactivePopGestureRecognizer.enabled = NO;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    
    pan.delegate = self;
    
    [self.view addGestureRecognizer:pan];

}

#pragma mark - 手势代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return (![self.topViewController isKindOfClass:[SAMMainViewController class]]);
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 设置导航条左边按钮的内容,把系统的返回按钮给覆盖,导航控制器的滑动返回功能就木有啦
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    
    [super pushViewController:viewController animated:animated];
}


- (void)back
{
    [self popViewControllerAnimated:YES];
}


@end
