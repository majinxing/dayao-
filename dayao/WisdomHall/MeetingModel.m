//
//  MeetingModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/20.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "MeetingModel.h"
#import "SignPeople.h"
@implementation MeetingModel
-(instancetype)init{
    self = [super init];
    if (self) {
        _signAry = [NSMutableArray arrayWithCapacity:1];
        _n = 0;
        _m = 0;
    }
    return self;
}
-(void)setMeetingInfoWithDict:(NSDictionary *)dict{
    self.meetingId = [dict objectForKey:@"id"];
    self.mck = [dict objectForKey:@"mck"];
    self.meetingHostId = [dict objectForKey:@"teacherId"];
    self.meetingHost = [dict objectForKey:@"userName"];
    self.meetingTime = [dict objectForKey:@"time"];
    self.meetingPlace = [dict objectForKey:@"roomName"];
    self.meetingPlaceId = [dict objectForKey:@"roomId"];
    self.meetingTotal = [dict objectForKey:@"total"];
    self.signWay = [dict objectForKey:@"signType"];
    self.imageUrl = [dict objectForKey:@"url"];
    self.meetingStatus = [dict objectForKey:@"status"];
    self.meetingName = [dict objectForKey:@"name"];
    self.signStatus = [dict objectForKey:@"signStatus"];
    self.url = [dict objectForKey:@"url"];
    self.userSeat = [dict objectForKey:@"userSeat"];
    [self setSignPeopleWithNSArray:[dict objectForKey:@"userSeatList"]];
}
-(void)setSignPeopleWithNSArray:(NSArray *)ary{
    for (int i =0 ; i<ary.count; i++) {
        SignPeople * sign = [[SignPeople alloc] init];
        [sign setInfoWithDict:ary[i]];
        if ([[NSString stringWithFormat:@"%@",sign.signStatus] isEqualToString:@"1"]) {
            _n = _n +1;
        }else{
            _m = _m+1;
        }
        [_signAry addObject:sign];
    }
}


@end
