//
//  SAMKeyboardTool.m
//  ShooIM
//
//  Created by 杨森 on 15/8/21.
//  Copyright (c) 2015年 samyang. All rights reserved.
//

#import "SAMKeyboardTool.h"

@implementation SAMKeyboardTool

+ (instancetype)tool
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (IBAction)previous:(id)sender {
   
    if ([self.toolbarDelegate respondsToSelector:@selector(keyboardTool:didClickItem:)]) {
        [self.toolbarDelegate keyboardTool:self didClickItem:SAMKeyboardToolItemPrevious];
    }
}

- (IBAction)next:(id)sender {
       if ([self.toolbarDelegate respondsToSelector:@selector(keyboardTool:didClickItem:)]) {
        [self.toolbarDelegate keyboardTool:self didClickItem:SAMKeyboardToolItemNext];
    }
}

- (IBAction)done:(id)sender {
   
    if ([self.toolbarDelegate respondsToSelector:@selector(keyboardTool:didClickItem:)]) {
        [self.toolbarDelegate keyboardTool:self didClickItem:SAMKeyboardToolItemDone];
    }
}



@end
