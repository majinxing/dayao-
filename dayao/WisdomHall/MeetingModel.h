//
//  MeetingModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/20.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeetingModel : NSObject
@property (nonatomic,copy) NSString * meetingName;//会议名
@property (nonatomic,copy) NSString * meetingHost;//会议主持人
@property (nonatomic,copy) NSString * meetingPlace;//会议地点
@property (nonatomic,copy) NSString * meetingTime;//会议时间
@property (nonatomic,copy) NSString * meetingImage;//会议图片
@property (nonatomic,copy) NSString * peopleNumber;//会议人数

@end