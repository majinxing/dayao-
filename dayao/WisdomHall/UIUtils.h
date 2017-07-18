//
//  UIUtils.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/26.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYHeader.h"
#import "ClassRoomModel.h"
@interface UIUtils : NSObject
+(void)addNavigationWithView:(UIView *)view withTitle:(NSString *)str;
//判断电话号码是否正确
+(BOOL)testCellPhoneNumber:(NSString *)mobileNum;
/**
 *  获取当地日期
 */
+(NSString *)getCurrentDate;
/**
 * 判断字符串是否为空
 **/
+(BOOL)isBlankString:(NSString *)string;
/**
*  判断电话是否是11位数字
**/

+(BOOL)isSimplePhone:(NSString *)phone;
/**
 * 判断是否全是数字
 **/
+(BOOL)isPureInt:(NSString *)string;
/**
 * 获取当前时间
 **/
+(NSString *)getTime;
+(NSString *)getMoreMonthTime;
/**
 * 获取当前的无线信号
 **/
+(NSMutableDictionary *)getWifiName;
/**
 * 规范路由器地址
 **/
+(NSString *)specificationMCKAddress:(NSString *)str;
//判断今天是否在这个时间段内
+(BOOL)validateWithStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime;
//比较两个时间的早晚
+(NSString *)compareTimeStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime;
//获取学期数
+(int)getTermId;
//创建课程
+(NSMutableDictionary *)createCourseWith:(NSMutableArray *)ary ClassRoom:(ClassRoomModel *)c joinClassPeople:(NSMutableArray *)joinPeopleAry m1:(int)m1 m2:(int)m2 m3:(int)m3 week:(int)week class1:(int)class1 class2:(int)class2;
//创建临时课程
+(NSMutableDictionary *)createTemporaryCourseWith:(NSMutableArray *)ary ClassRoom:(ClassRoomModel *)c joinClassPeople:(NSMutableArray *)joinPeopleAry week:(int)week class1:(int)class1 class2:(int)class2;
@end
