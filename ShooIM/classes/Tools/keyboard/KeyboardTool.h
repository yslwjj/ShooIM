//
//  KeyboardTool.h
//  QCloud
//
//  Created by 鹰眼 on 14-7-1.
//  Copyright (c) 2014年 qcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KeyboardTool;
@protocol KeyboardToolDelegate <NSObject>

-(void)keyboardTool:(KeyboardTool *)tool didClickFinished:(UIButton *)button;


@end
@interface KeyboardTool : UIView
@property(nonatomic,weak)id<KeyboardToolDelegate>delegate;
@property(nonatomic,copy)NSString *buttonTitle;
@end
