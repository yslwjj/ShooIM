//
//  SAMCommon.m
//  ShooIM
//
//  Created by 杨森 on 15/8/22.
//  Copyright (c) 2015年 samyang. All rights reserved.
//

#import "SAMCommon.h"

#import "MBProgressHUD.h"
#import "SystemConfiguration/SystemConfiguration.h"
#include "netdb.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "SAMNavgationController.h"
#import "SAMMainViewController.h"

#define LoginStatusKey @"LoginStatus"
#define KLoginSuccessNotification @"KLoginSuccessNotification"
#define KLoginOutNotification @"KLoginOutNotification"
#define LocalCityKey @"LocalCity"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access

@implementation SAMCommon

/**
 *  登录成功的时候修改状态
 */
+ (void)setLoginStatus
{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setBool:YES forKey:LoginStatusKey];
    [accountDefaults synchronize];
    //[[NSNotificationCenter defaultCenter]postNotificationName:KLoginSuccessNotification object:nil];
}

/**
 *  退出登录的时候修改状态
 */
+ (void)setSignOutStatus
{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setBool:NO forKey:LoginStatusKey];
    [accountDefaults synchronize];
    // [[NSNotificationCenter defaultCenter]postNotificationName:KLoginOutNotification object:nil];
}

/**
 *  获取登录状态
 */
+ (BOOL)getLoginStatus{
    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    return [accountDefaults boolForKey:LoginStatusKey];
    
}


+ (void)setMemNum :(NSString *)memberid
{
    if (memberid ==nil) {
        return;
    }
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:memberid forKey:@"kMemNum"];
    [accountDefaults synchronize];
    //[[NSNotificationCenter defaultCenter]postNotificationName:KLoginSuccessNotification object:nil];
}

+ (void)setUserName:(NSString *)userName pwd:(NSString *)pwd{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:userName forKey:@"kUserName"];
    [accountDefaults setObject:pwd forKey:@"kPWD"];
    [accountDefaults synchronize];
}


+ (id)getUserName{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    return [accountDefaults objectForKey:@"kUserName"];
}


+ (id)getPWD{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    return [accountDefaults objectForKey:@"kPWD"];
}


+ (void)setIMToken :(NSString *)code
{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:code forKey:@"kSecureCode"];
    [accountDefaults synchronize];
}

+ (id)getIMToken{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    return [accountDefaults objectForKey:@"kSecureCode"];
    
}


//顯示提示文字訊息
+ (void)alertShowMessage:(NSString *)message
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [alert show];
}

+ (BOOL)isValidateMobile:(NSString *) mobile {
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0-9])|(14[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    // NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}


+ (BOOL)connectedToNetwork
{
    // 创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    /**
     *  SCNetworkReachabilityRef: 用来保存创建测试连接返回的引用
     *
     *  SCNetworkReachabilityCreateWithAddress: 根据传入的地址测试连接.
     *  第一个参数可以为NULL或kCFAllocatorDefault
     *  第二个参数为需要测试连接的IP地址,当为0.0.0.0时则可以查询本机的网络连接状态.
     *  同时返回一个引用必须在用完后释放.
     *  PS: SCNetworkReachabilityCreateWithName: 这个是根据传入的网址测试连接,
     *  第二个参数比如为"www.apple.com",其他和上一个一样.
     *
     *  SCNetworkReachabilityGetFlags: 这个函数用来获得测试连接的状态,
     *  第一个参数为之前建立的测试连接的引用,
     *  第二个参数用来保存获得的状态,
     *  如果能获得状态则返回TRUE，否则返回FALSE
     *
     */
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flagsn");
        return NO;
    }
    
    /**
     *  kSCNetworkReachabilityFlagsReachable: 能够连接网络
     *  kSCNetworkReachabilityFlagsConnectionRequired: 能够连接网络,但是首先得建立连接过程
     *  kSCNetworkReachabilityFlagsIsWWAN: 判断是否通过蜂窝网覆盖的连接,
     *  比如EDGE,GPRS或者目前的3G.主要是区别通过WiFi的连接.
     *
     */
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}


+ (NSString *)md5:(NSString *)str
{

    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    
    return [NSString stringWithFormat:
            
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ];
    
}

+ (NSData *)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

+ (UIImage *) getImageFromURL:(NSString *)fileURL {
    
    NSLog(@"执行图片下载函数");
    
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    
    result = [UIImage imageWithData:data];
    
    return result;
    
}
+ (NSString *)getNow
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@", strDate);
    return strDate;
}
// Get IP Address
+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
// 加上 千位分隔符
+ (NSString *)separatedDigitStringWithStr:(NSString *)digitString

{
    NSLog(@"The begin string:%@",digitString);
    if (digitString.length <= 3) {
        return digitString;
    } else {
        NSMutableString *processString = [NSMutableString stringWithString:digitString];
        
        // 1
        int location = (int)processString.length - 3;
        NSMutableArray *processArray = [NSMutableArray array];
        while (location >= 0) {
            NSString *temp = [processString substringWithRange:NSMakeRange(location, 3)];
            
            [processArray addObject:temp];
            if (location < 3 && location > 0)
            {
                NSString *t = [processString substringWithRange:NSMakeRange(0, location)];
                [processArray addObject:t];
            }
            location -= 3;
        }
        //    NSLog(@"processArray = %@",processArray);
        
        // 2
        NSMutableArray *resultsArray = [NSMutableArray array];
        int k = 0;
        for (NSString *str in processArray)
        {
            k++;
            NSMutableString *tmp = [NSMutableString stringWithString:str];
            if (str.length > 2 && k < processArray.count )
            {
                [tmp insertString:@"," atIndex:0];
                [resultsArray addObject:tmp];
            } else {
                [resultsArray addObject:tmp];
            }
        }
        //    NSLog(@"resultsArray = %@",resultsArray);
        
        // 3
        NSMutableString *resultString = [NSMutableString string];
        for (int i =(int)resultsArray.count - 1 ; i >= 0; i--)
        {
            NSString *tmp = [resultsArray objectAtIndex:i];
            [resultString appendString:tmp];
        }
        //    NSLog(@"resultStr = %@",resultString);
        return resultString;
    }
}
+(void)CallPhone :(NSString*)telnum
{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",telnum];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}
/*邮箱验证 MODIFIED BY HELENSONG*/
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL) isValidateTWMobile:(NSString *)mobile
{
    
    NSString *phoneRegex = @"09[0-9]{2}[0-9]{6}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}
+(BOOL)isValidatePassword:(NSString *)password
{
    NSString *Regex = @"\\w{6,16}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [passwordTest evaluateWithObject:password];
}

#pragma mark - 躒轉到主控制器
+ (void)MoveToMainViewController
{
    SAMMainViewController *main = [[SAMMainViewController alloc] init];
    SAMKeyWindow.rootViewController = [[SAMNavgationController alloc] initWithRootViewController:main];
    main.navigationItem.leftBarButtonItem.customView = [[UIView alloc] init];
    
    CATransition *anim = [CATransition animation];
    anim.duration = 0.5;
    anim.type = @"rippleffect";
    [SAMKeyWindow.layer addAnimation:anim forKey:nil];
    
}


@end
