//
//  SAMKeyboardTool.h
//  ShooIM
//
//  Created by 杨森 on 15/8/21.
//  Copyright (c) 2015年 samyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SAMKeyboardToolItemPrevious,
    SAMKeyboardToolItemNext,
    SAMKeyboardToolItemDone
} SAMKeyboardToolItem;

@class SAMKeyboardTool;

@protocol SAMKeyboardToolDelegate <NSObject>

@optional
- (void)keyboardTool:(SAMKeyboardTool *)tool didClickItem:(SAMKeyboardToolItem)item;

@end

@interface SAMKeyboardTool : UIToolbar
@property (weak, nonatomic, readonly) IBOutlet UIBarButtonItem *nextItem;
@property (weak, nonatomic, readonly) IBOutlet UIBarButtonItem *previousItem;

+ (instancetype)tool;

/** 代理 */
@property (nonatomic, weak) id<SAMKeyboardToolDelegate> toolbarDelegate;

@end
