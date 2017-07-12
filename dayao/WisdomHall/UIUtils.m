//
//  UIUtils.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/26.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "UIUtils.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation UIUtils
+(void)addNavigationWithView:(UIView *)view withTitle:(NSString *)str{
//    UIView *navigation = [[UIView alloc] initWithFrame:CGRectMake(0, 0,APPLICATION_WIDTH, 65)];
//    navigation.backgroundColor=[UIColor whiteColor];
//    [view addSubview:navigation];
//    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/2.0-100,34,200, 20)];
//    title.text=str;
//    title.textColor=[UIColor colorWithHexString:@"#333333"];
//    title.font=[UIFont systemFontOfSize:17];
//    title.textAlignment=NSTextAlignmentCenter;
//    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, 1)];
//    line.backgroundColor=[UIColor colorWithHexString:@"#e5e5e5"];
//    [view addSubview:line];
//    [view addSubview:title];
}
/**
 *  获取当地日期
 */
+(NSString *)getCurrentDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //获得当前时间的年月日时分
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSString *nowDate = [NSString stringWithFormat:@"%ld-%ld-%ld-%ld-%ld-%ld",(long)nowCmps.year,(long)nowCmps.month,(long)nowCmps.day,(long)nowCmps.hour,(long)nowCmps.minute,(long)nowCmps.second];
    return nowDate;
}

+(BOOL)testCellPhoneNumber:(NSString *)mobileNum{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//判断字符串是否为空
+(BOOL)isBlankString:(NSString *)string
{
    if (string == nil)
    {
        return YES;
    }
    if (string == NULL)
    {
        return YES;
    }
//    if (string.length == 0)
//    {
//        return YES;
//    }
    return NO;
}
//电话正则表达式
+(BOOL)isSimplePhone:(NSString *)phone{
    NSString *phoneRegex = @"^1[0-9]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}
+(NSString *)getTime{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //获得当前时间的年月日时分
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSString *month;
    if (nowCmps.month<10) {
        month = [NSString stringWithFormat:@"0%ld",(long)nowCmps.month];
    }else{
        month = [NSString stringWithFormat:@"%ld",(long)nowCmps.month];
    }
    NSString * day;
    if (nowCmps.day<10) {
        day = [NSString stringWithFormat:@"0%ld",(long)nowCmps.day];
    }else{
        day = [NSString stringWithFormat:@"%ld",(long)nowCmps.day];
    }
    NSString *nowDate = [NSString stringWithFormat:@"%ld-%@-%@",(long)nowCmps.year,month,day];
    
    return nowDate;
}
//获取当前的无线信号

+(NSMutableDictionary *)getWifiName

{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    NSString *wifiName = nil;
    
    
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    
    
    if (!wifiInterfaces) {
        
        return dict;
        
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    
    for (NSString *interfaceName in interfaces) {
        
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        
        
        if (dictRef) {
            
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            
           // NSLog(@"network info -> %@", networkInfo);
            dict = networkInfo;
            wifiName = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
            
        }
        
    }
    
    CFRelease(wifiInterfaces);
    
    return dict;
    
}

+(NSString *)specificationMCKAddress:(NSString *)str{
    NSMutableString * bssid = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@",str]];
    
    NSArray * ary = [bssid componentsSeparatedByString:@":"];
    
    NSString * str1 = [[NSString alloc] init];
    for (int i = 0; i<ary.count; i++) {
        NSString * s = [NSString stringWithFormat:@"%@",ary[i]];
        if (s.length==2) {
            str1 = [NSString stringWithFormat:@"%@%@",str1,s];
        }else{
            str1 = [NSString stringWithFormat:@"%@0%@",str1,s];
        }
    }
    
    //            bssid = [bssid stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    bssid = [str1 uppercaseString];
    return bssid;
}

/**
 *  判断当前时间是否处于某个时间段内
 *
 *  @param startTime        开始时间
 *  @param expireTime       结束时间
 */

+(BOOL)validateWithStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime {
    
    NSArray *ary = [startTime componentsSeparatedByString:@" "];
    expireTime = ary[1];
    NSMutableArray * ary1 = [expireTime componentsSeparatedByString:@":"];
    expireTime = ary1[0];
    long n = [expireTime integerValue];
    if (n == 12||n == 24) {
        n = 1;
        ary1[0] = [NSString stringWithFormat:@"%ld",n];
    }else {
        n = n+1;
        ary1[0] = [NSString stringWithFormat:@"%ld",n];
    }
    expireTime = [NSString stringWithFormat:@"%@ %@-%@",ary[0],ary1[0],ary1[1]];
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *start = [dateFormat dateFromString:startTime];
    NSDate *expire = [dateFormat dateFromString:expireTime];
    
    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}
@end





























