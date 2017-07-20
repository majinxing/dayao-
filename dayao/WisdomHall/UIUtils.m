//
//  UIUtils.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/26.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "UIUtils.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "DYHeader.h"
#import "ClassRoomModel.h"
#import "SignPeople.h"

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
    if ([string isEqualToString:@"(null)"]) {
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
+(NSString *)getMoreMonthTime{
    
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
    if (nowCmps.day<9) {
        day = [NSString stringWithFormat:@"0%ld",(long)nowCmps.day+1];
    }else{
        day = [NSString stringWithFormat:@"%ld",(long)nowCmps.day+1];
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
    startTime = [NSString stringWithFormat:@"%@ %@:%@",ary[0],ary1[0],ary1[1]];
    long n = [expireTime integerValue];
    if (n == 12||n == 24) {
        n = 1;
        ary1[0] = [NSString stringWithFormat:@"%ld",n];
    }else {
        n = n+1;
        ary1[0] = [NSString stringWithFormat:@"%ld",n];
    }
    expireTime = [NSString stringWithFormat:@"%@ %@:%@",ary[0],ary1[0],ary1[1]];
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
+(NSString *)compareTimeStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime {
    
    NSArray *ary = [startTime componentsSeparatedByString:@" "];
    
    NSString * str = ary[1];
    NSArray * ary1 = [str componentsSeparatedByString:@":"];
    startTime = [NSString stringWithFormat:@"%@ %@:%@",ary[0],ary1[0],ary1[1]];
    
    NSArray *aryX = [expireTime componentsSeparatedByString:@" "];
    NSString * strX = ary[1];
    NSArray * aryX1 = [strX componentsSeparatedByString:@":"];
    expireTime = [NSString stringWithFormat:@"%@ %@:%@",aryX[0],aryX1[0],aryX1[1]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *start = [dateFormat dateFromString:startTime];
    NSDate *expire = [dateFormat dateFromString:expireTime];
    NSComparisonResult result = [start compare:expire];
    NSString * ci;
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            ci=@"1"; break;
            //date02比date01小
        case NSOrderedDescending:
            ci=@"-1"; break;
            //date02=date01
        case NSOrderedSame:
            ci=@"0"; break;
        default:
             break;
    }
    return ci;
}
+(NSMutableDictionary *)createTemporaryCourseWith:(NSMutableArray *)ary ClassRoom:(ClassRoomModel *)c joinClassPeople:(NSMutableArray *)joinPeopleAry week:(int)week class1:(int)class1 class2:(int)class2{
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    for (int i = 1; i<ary.count; i++) {
        if ([UIUtils isBlankString:ary[i]]) {
            return dict;
            break;
        }
    }
    [dict setObject:ary[1] forKey:@"name"];
    
    UserModel * users = [[Appsetting sharedInstance] getUsetInfo];
    
    [dict setObject:[NSString stringWithFormat:@"%@",users.peopleId] forKey:@"teacherId"];
    
    [dict setObject:@"1" forKey:@"signWay"];
    
    [dict setObject:[NSString stringWithFormat:@"%@",c.classRoomId] forKey:@"roomId"];
    
    NSMutableArray * userList = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i<joinPeopleAry.count; i++) {
        SignPeople * s = joinPeopleAry[i];
        if (![[NSString stringWithFormat:@"%@",s.userId] isEqualToString:[NSString stringWithFormat:@"%@",users.peopleId]]) {
            [userList addObject:s.userId];
        }
    }
    
    [dict setObject:userList forKey:@"userList"];
    
    [dict setObject:@"0" forKey:@"pictureId"];
    
    [dict setObject:users.school forKey:@"universityId"];
    
    [dict setObject:ary[7] forKey:@"startTime"];
    
    [dict setObject:[NSString stringWithFormat:@"%d",class1+1] forKey:@"startTh"];
    
    [dict setObject:[NSString stringWithFormat:@"%d",class2+1] forKey:@"endTh"];
    
    return dict;
}

+(NSMutableDictionary *)createCourseWith:(NSMutableArray *)ary ClassRoom:(ClassRoomModel *)c joinClassPeople:(NSMutableArray *)joinPeopleAry m1:(int)m1 m2:(int)m2 m3:(int)m3 week:(int)week class1:(int)class1 class2:(int)class2{
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    for (int i = 1; i<ary.count; i++) {
        if ([UIUtils isBlankString:ary[i]]) {
            return dict;
            break;
        }
    }
    [dict setObject:ary[1] forKey:@"name"];
    UserModel * users = [[Appsetting sharedInstance] getUsetInfo];
    [dict setObject:[NSString stringWithFormat:@"%@",users.peopleId] forKey:@"teacherId"];
    [dict setObject:@"1" forKey:@"signWay"];
    [dict setObject:[NSString stringWithFormat:@"%@",c.classRoomId] forKey:@"roomId"];
    
    NSMutableArray * userList = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i<joinPeopleAry.count; i++) {
        SignPeople * s = joinPeopleAry[i];
        if (![[NSString stringWithFormat:@"%@",s.userId] isEqualToString:[NSString stringWithFormat:@"%@",users.peopleId]]) {
            [userList addObject:s.userId];
        }
    }
    
    [dict setObject:userList forKey:@"userList"];
    
    [dict setObject:@"0" forKey:@"pictureId"];
    [dict setObject:[NSString stringWithFormat:@"%d",[UIUtils getTermId]] forKey:@"termId"];
    [dict setObject:ary[7] forKey:@"firstDay"];
    
    if (m3 == 0) {
        NSArray * aryT = [[NSArray alloc] initWithObjects:@{@"startWeek":[NSString stringWithFormat:@"%d",m1],@"endWeek":[NSString stringWithFormat:@"%d",m2]}, nil];
        [dict setObject:aryT forKey:@"courseWeekList"];
        
    }else if (m3 == 1){
        NSMutableArray * aryT1 = [NSMutableArray arrayWithCapacity:1];
        if (m1%2==0) {
            for (int i = m1+1; i<=m2; i=i+2) {
                NSDictionary * d = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"startWeek",[NSString stringWithFormat:@"%d",i],@"endWeek", nil];
                
                [aryT1 addObject:d];
            }
            
        }else{
            for (int i = m1; i<=m2; i= i+2) {
                NSDictionary * d = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"startWeek",[NSString stringWithFormat:@"%d",i],@"endWeek", nil];
                
                [aryT1 addObject:d];
            }
        }
        [dict setObject:aryT1 forKey:@"courseWeekList"];
        
    }else if (m3 == 2){
        NSMutableArray * aryT1 = [NSMutableArray arrayWithCapacity:1];
        if (m1%2==0) {
            for (int i = m1; i<=m2; i=i+2) {
                NSDictionary * d = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"startWeek",[NSString stringWithFormat:@"%d",i],@"endWeek", nil];
                [aryT1 addObject:d];
            }
            
        }else{
            for (int i = m1+1; i<=m2; i=i+2) {
                NSDictionary * d = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"startWeek",[NSString stringWithFormat:@"%d",i],@"endWeek", nil];
                [aryT1 addObject:d];
            }
        }
        [dict setObject:aryT1 forKey:@"courseWeekList"];
    }
    [dict setObject:users.school forKey:@"universityId"];
    
    
    NSDictionary * w = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",week+1],@"weekDay",[NSString stringWithFormat:@"%d",class1+1],@"startTh",[NSString stringWithFormat:@"%d",class2+1],@"endTh",nil];
    
    NSArray * aa = [[NSArray alloc] initWithObjects:w, nil];
    [dict setObject:aa forKey:@"courseTimeList"];
    
    return dict;
}

+(int)getTermId{
    NSString * time = [UIUtils getTime];
    NSString * year = [time substringWithRange:NSMakeRange(0, 4)];
    NSString * month = [time substringWithRange:NSMakeRange(5, 2)];
    int y = [year intValue];
    int m = [month intValue];
    int  n = (y - 2017)*2;
    if (m>8) {
        n = n + 1;
    }else{
        n = n + 0;
    }
    return n;
}
+(BOOL)isPureInt:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];

}

+(NSMutableArray *)returnAry:(UserModel *)user{
    NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];
    [ary addObject:[NSString stringWithFormat:@"%@",user.userName]];
    [ary addObject:[NSString stringWithFormat:@"%@",user.studentId]];
    [ary addObject:[NSString stringWithFormat:@"%@",user.schoolName]];
    [ary addObject:[NSString stringWithFormat:@"%@",user.departmentsName]];
    [ary addObject:[NSString stringWithFormat:@"%@",user.professionalName]];
    [ary addObject:[NSString stringWithFormat:@"%@",user.userPhone]];

    if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",user.email]]) {
        [ary addObject:[NSString stringWithFormat:@""]];

    }else{
        [ary addObject:[NSString stringWithFormat:@"%@",user.email]];
    }
    if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",user.region]]) {
        [ary addObject:[NSString stringWithFormat:@""]];
        
    }else{
        [ary addObject:[NSString stringWithFormat:@"%@",user.region]];
    }
    if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",user.sex]]) {
        [ary addObject:[NSString stringWithFormat:@""]];
        
    }else{
        [ary addObject:[NSString stringWithFormat:@"%@",user.sex]];
    }
    if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",user.birthday]]) {
        [ary addObject:[NSString stringWithFormat:@""]];
        
    }else{
        [ary addObject:[NSString stringWithFormat:@"%@",user.birthday]];
    }
    if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",user.sign]]) {
        [ary addObject:[NSString stringWithFormat:@""]];
        
    }else{
        [ary addObject:[NSString stringWithFormat:@"%@",user.sign]];
    }

    return ary;
}

@end





























