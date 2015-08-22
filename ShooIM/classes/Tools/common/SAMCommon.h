//
//  SAMCommon.h
//  ShooIM
//
//  Created by 杨森 on 15/8/22.
//  Copyright (c) 2015年 samyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAMCommon : NSObject

/**
 *  登錄
 */
+ (void)setLoginStatus;

/**
 *  退出登录
 */
+ (void)setSignOutStatus;


#pragma mark - 设置用户信息和取得用户信息
+ (void)setUserName:(NSString *)userName pwd:(NSString *)pwd;
+ (id)getUserName;
+ (id)getPWD;
+ (void)setIMToken :(NSString *)code;
+ (id )getIMToken;
+(void)setMemNum :(NSString *)memberid;


/**
 *  获取登录状态
 */
+ (BOOL)getLoginStatus;

/**
 *  显示提示信息
 */
+ (void)alertShowMessage:(NSString *)message;

/**
 *  字符串转MD5
 */
+ (NSString *)md5:(NSString *)str;

/**
 *  验证电话号码是否有效
 */
+ (BOOL) isValidateMobile:(NSString *) mobile;

/**
 *  是否连接上网络
 */
+ (BOOL) connectedToNetwork;

/**
 *  图片转数据
 *
 *  @param image   图片
 *  @param newSize 缩放比例
 *
 *  @return 上传数据
 */
+ (NSData *)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;

/**
 *  获取网络图片
 */
+ (UIImage *) getImageFromURL:(NSString *)fileURL;

/**
 *  给字符串添加千分位
 */
+ (NSString *)separatedDigitStringWithStr:(NSString *)digitString;

/**
 *  打电话
 
 */
+ (void)CallPhone :(NSString*)telnum;

//驗證是否有效資料
+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL) isValidateTWMobile:(NSString *)mobile;
+ (BOOL)isValidatePassword:(NSString *)password;

#pragma mark - 躒轉到主控制器
+ (void)MoveToMainViewController;

@end
