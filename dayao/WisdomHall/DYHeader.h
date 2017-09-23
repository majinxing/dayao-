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

#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
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

#define Vote_delecate               @"删除"
#define Vote_Modify                 @"修改"
#define Vote_Stare                  @"开始"
#define Vote_Stop                   @"结束"

#define Test_Scores_Query           @"查询成绩"

#define Meeting                     @"会议"
#define Announcement                @"公告"
#define Leave                       @"请假"
#define Business                    @"出差"
#define Lotus                       @"审批"

//数据库的名字
#define SQLITE_NAME            @"Dayao"

#define TEXT_TABLE_NAME        @"textTable"                         //试卷表名字

#define QUESTIONS_TABLE_NAME   @"questionsTable"                    //题目表

#define CONTACT_TABLE_NAME     @"contactTable"                      //试卷和题目联系的表格

#define NOTICE_TABLE_NAME      @"noticeTable"                       //通知表

#define TOKENTIME_TABLE_NAME   @"tokenTimeTable"                    //记录token有效期的

//接口116.62.161.250:8080 192.168.1.81:8080 api.dayaokeji.com
#define BaseURL                 @"http://api.dayaokeji.com/"

#define Login                   @"course/user/login"                //登录

#define Register                @"course/user/register"             //注册

#define ResetPassword           @"course/user/modify"               //重置密码

#define SchoolDepartMent        @"course/department/list"           //院系列表

#define QueryClassRoom          @"course/classroom/select"          //查询教室

#define QueryCourse             @"course/course/select"             //查询课堂

#define CreateClass             @"course/course/create"             //创建教室

#define QuertyClassNumber       @"course/course/maxnum"             //查询教室节数

#define CreateCoures            @"course/course/create/cycle"       //创建课堂

#define CreateTemporaryCourse   @"course/course/create/once"        //创建临时课堂

#define QueryCourseMemBer       @"course/course/member"             //查询课堂成员

#define DelecateCourse          @"course/course/delete"             //删除课程

#define QueryMeeting            @"course/meeting/select/user"       //查询会议(参与者)

#define QueryMeetingSelfCreate  @"course/meeting/select"            //查询自己创建的会议

#define MeetingSign             @"course/meeting/sign"              //会议签到

#define MeetingDelect           @"course/meeting/delete"            //会议删除

#define ClassSign               @"course/course/sign"               //课程签到

#define ClassSign               @"course/course/sign"               //课程签到

#define QueryPeople             @"course/user/list"                 //人员条件查询

#define QuerySelfInfo           @"course/user/detail"               //查询个人信息

#define ChangeSelfInfo          @"course/user/update"               //修改个人信息

#define QueryApp                @"course/app/select"                //查询版本号

#define QueryMeetingPeople      @"course/meeting/member"            //查询与会者信息

#define QueryAdvertising        @"course/resource/select"           //查询广告

#define FeedBack                @"course/feedback/create"           //意见反馈

#define QueryMeetingRoom        @"course/meetingroom/select"        //查询会议室

#define CreateMeeting           @"course/meeting/create"            //创建会议

#define JoinCourse              @"course/course/addMember"          //个人加入课程

#define JoinMeeting             @"course/meeting/addMember"         //个人加入会议

#define FileUpload              @"course/resource/upload"           //上传资料

#define FileDownload            @"course/resource/download"         //资料下载

#define FileList                @"course/resource/list"             //资料列表

#define FileDelegate            @"course/resource/delete"           //删除

#define CreateVote              @"course/vote/create"               //创建投票

#define QueryVote               @"course/vote/list"                 //查询投票

#define QueryListOption         @"course/vote/listOption"           //查询投票选项

#define PeopleVote              @"course/vote/vote"                 //用户投票接口

#define VoteEditor              @"course/vote/update"               //修改投票主题，包含投票状态

#define VoteDelect              @"course/vote/delete"               //删除投票

#define QueryVoteResult         @"course/vote/listOption"           //查询投票结果

#define QueryTest               @"course/exam/queryTestExamAll"     //查询考试列表

#define CreateLib               @"course/exam/createLib"            //创建题库

#define QueryLibList            @"course/exam/qureyLib"             //查询题库

#define QueryTextList           @"course/exam/queryExamQuestion"    //查询试题列表

#define QueryQuestionList       @"course/exam/queryExamQuestion"    //查询试卷题目

#define HandIn                  @"course/exam/commitExam"           //交卷

#define StartText               @"course/exam/ExamUnderway"         //开始考试

#define StopText                @"course/exam/ExamCompleted"        //结束考试

#define DelecateText            @"course/exam/deleteExam"           //删除考试

#define QuertyTestScores        @"course/exam/queryExamGradeTeacher"//查询考试成绩

#define StudentStart            @"course/exam/startExam"            //学生开始考试

#define QuertyQusetionBank      @"course/exam/qureyLib"             //查询题库列表

#define CreateQuestion          @"course/exam/createQuestion"       //创建题目

#define QuertyBankQuestionList  @"course/exam/queryQuestion"        //查询题库题目列表

#define CreateText              @"course/exam/createExam"           //创建考试

#define Update                  @"course/user/password/update"      //修改密码











