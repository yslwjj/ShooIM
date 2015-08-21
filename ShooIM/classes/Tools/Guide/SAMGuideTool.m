//
//  SAMGuideTool.m
//  ShooIM
//
//  Created by 杨森 on 15/8/21.
//  Copyright (c) 2015年 samyang. All rights reserved.
//


#import "SAMGuideTool.h"
#import "SAMLoginViewController.h"
#import "SAMNavgationController.h"

@implementation SAMGuideTool

+ (UIViewController *)chooseRootViewController
{
    // 初始化登录控制器
    UIStoryboard *loginStoryBorad = [UIStoryboard storyboardWithName:NSStringFromClass([SAMLoginViewController class]) bundle:nil];
    SAMLoginViewController *login = (SAMLoginViewController *)[loginStoryBorad instantiateInitialViewController];
    SAMNavgationController *nav = [[SAMNavgationController alloc] initWithRootViewController:login];
    
    return nav;
}

@end
