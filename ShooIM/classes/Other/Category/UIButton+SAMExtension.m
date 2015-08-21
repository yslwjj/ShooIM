//
//  UIButton+SAMExtension.m
//  百思不得姐
//
//  Created by 杨森 on 15/7/26.
//  Copyright (c) 2015年 samyang. All rights reserved.
//

#import "UIButton+SAMExtension.h"

@implementation UIButton (SAMExtension)

- (void)setRound:(CGFloat)Round
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = Round;
}

- (CGFloat)Round
{
    return 0;
}


@end
