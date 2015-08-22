//
//  SAMLogin.h
//  ShooIM
//
//  Created by 杨森 on 15/8/22.
//  Copyright (c) 2015年 samyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAMLogin : NSObject


/** 状态 */
@property (nonatomic, copy) NSString *state;
/** token */
@property (nonatomic, copy) NSString *token;
/** userId */
@property (nonatomic, copy) NSString *userId;

@end
