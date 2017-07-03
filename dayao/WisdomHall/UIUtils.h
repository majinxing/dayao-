//
//  UIUtils.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/26.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYHeader.h"
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
 * 获取当前时间
 **/
+(NSString *)getTime;
@end
