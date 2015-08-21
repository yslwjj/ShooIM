//
//  UIImage+SAMExtension.m
//  百思不得姐
//
//  Created by 杨森 on 15/8/4.
//  Copyright (c) 2015年 samyang. All rights reserved.
//

#import "UIImage+SAMExtension.h"

@implementation UIImage (SAMExtension)

- (UIImage *)circleImage
{
    //  NO代表不透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获得上下文
    CGContextRef ctx= UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 将图片画上去
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
