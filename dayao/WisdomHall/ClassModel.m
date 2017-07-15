//
//  ClassModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/3.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel
-(void)setInfoWithDict:(NSDictionary *)dict{
    self.sclassId = [dict objectForKey:@"id"];
    self.signWay = [dict objectForKey:@"signWay"];
    self.typeRoom = [dict objectForKey:@"roomName"];
    self.teacherId = [dict objectForKey:@"teacherId"];
    self.teacherName = [dict objectForKey:@"teacherName"];
    self.weekDayName = [dict objectForKey:@"weekDayName"];
    self.endTh = [dict objectForKey:@"endTh"];
    self.startTh = [dict objectForKey:@"startTh"];
    self.actEndTime = [dict objectForKey:@"actEndTime"];
    self.actStarTime = [dict objectForKey:@"actStartTime"];
    self.courseDetailId = [dict objectForKey:@"courseDetailId"];
    self.time = [dict objectForKey:@"time"];
    self.total = [dict objectForKey:@"total"];
    self.pictureId = [dict objectForKey:@"pictureId"];
    self.roomId = [dict objectForKey:@"roomId"];
    self.address = [dict objectForKey:@"address"];
    self.creatTime = [dict objectForKey:@"createTime"];
    self.name = [dict objectForKey:@"name"];
    self.status = [dict objectForKey:@"status"];
    self.mck = [dict objectForKey:@"mck"];
    
}
@end






