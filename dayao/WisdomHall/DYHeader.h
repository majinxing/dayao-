//
//  DYHeader.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/25.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#ifndef DYHeader_h
#define DYHeader_h
//屏幕
#define APPLICATION_WIDTH [UIScreen mainScreen].bounds.size.width

#define APPLICATION_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define MAIN_SCREEN_FRAME     [[UIScreen mainScreen] bounds]

#ifdef __OBJC__
    @import UIKit;
    @import Foundation;

#endif

#endif /* DYHeader_h */
#import "UIColor+HexString.h"
#import "UIUtils.h"
#import "UIViewController+HUD.h"
#import "NetworkRequest.h"
#import "Appsetting.h"
#import "UserModel.h"


#define Collection_height 225

#define ShareType_Weixin_Friend     @"微信好友"
#define ShareType_Weixin_Circle     @"朋友圈"
#define ShareType_QQ_Friend         @"QQ好友"
#define ShareType_QQ_Zone           @"QQ空间"
#define ShareType_Weibo             @"新浪微博"
#define ShareType_Message           @"短信"
#define ShareType_Email             @"Email"
#define ShareType_Copy              @"复制链接"

#define InteractionType_Test        @"测试"
#define InteractionType_Discuss     @"讨论"
#define InteractionType_Vote        @"投票"
#define InteractionType_Responder   @"抢答"
#define InteractionType_Data        @"资料"
#define InteractionType_Add         @"更多"


//数据库的名字
#define SQLITE_NAME        @"Dayao"

#define TEXT_TABLE_NAME        @"textTable"//试卷表名字

#define QUESTIONS_TABLE_NAME   @"questionsTable"//题目表

#define CONTACT_TABLE_NAME     @"contactTable"//试卷和题目联系的表格

//接口116.62.161.250 192.168.1.81:8080
#define BaseURL @"http://192.168.1.81:8080/"

#define Login            @"course/user/login"       //登录

#define Register         @"course/user/register"    //注册

#define ResetPassword    @"course/user/modify"      //重置密码

#define SchoolDepartMent @"course/department/list"  // 院系列表

#define QueryClassRoom   @"course/classroom/select" //查询教室

#define QueryCourse      @"course/course/select"    //查询课堂

#define CreateClass      @"course/course/create"    //创建教室

#define CreateCoures     @"course/course/create/cycle" //创建课堂

#define CreateTemporaryCourse @"course/course/create/once" //创建临时课堂

#define QueryCourseMemBer     @"course/course/member"      //查询课堂成员

#define DelecateCourse         @"course/course/delete"   //删除课程

#define QueryMeeting     @"course/meeting/select/user"   //查询会议(参与者)

#define QueryMeetingSelfCreate @"course/meeting/select" //查询自己创建的会议

#define MeetingSign      @"course/meeting/sign"     //会议签到

#define ClassSign        @"course/course/sign"       //课程签到

#define ClassSign        @"course/course/sign"      //课程签到

#define QueryPeople     @"course/user/list"         //人员条件查询



