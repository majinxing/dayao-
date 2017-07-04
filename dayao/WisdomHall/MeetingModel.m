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
        
    }
    return self;
}
-(void)setMeetingInfoWithDict:(NSDictionary *)dict{
    self.meetingId = [dict objectForKey:@"id"];
    self.mac = [dict objectForKey:@"mac"];
    self.meetingHost = [dict objectForKey:@"teacherId"];
    self.meetingTime = [dict objectForKey:@"time"];
    self.meetingPlace = [dict objectForKey:@"roomName"];
    self.meetingTotal = [dict objectForKey:@"total"];
    self.signWay = [dict objectForKey:@"signWay"];
    self.imageUrl = [dict objectForKey:@"url"];
    self.meetingStatus = [dict objectForKey:@"status"];
    self.meetingName = [dict objectForKey:@"name"];
    
}
@end
