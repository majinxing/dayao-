//
//  MeetingModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/20.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "MeetingModel.h"

@implementation MeetingModel
-(instancetype)init{
    self = [super init];
    if (self) {
        _meetingName = @"总结大会";
        _meetingHost = @"李老师";
        _meetingPlace = @"图书馆";
        _meetingTime = @"9-1 3:00 pm";
        _meetingImage = @"";
        _peopleNumber = @"25";
    }
    return self;
}
@end
