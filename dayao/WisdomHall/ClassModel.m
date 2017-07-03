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
    self.typeRoom = [dict objectForKey:@"typeRomm"];
    self.teacherId = [dict objectForKey:@"teacherId"];
    self.time = [dict objectForKey:@"time"];
    self.total = [dict objectForKey:@"total"];
    self.pictureId = [dict objectForKey:@"pictureId"];
    self.roomId = [dict objectForKey:@"roomId"];
    self.address = [dict objectForKey:@"address"];
    self.creatTime = [dict objectForKey:@"createTime"];
    self.name = [dict objectForKey:@"name"];
    self.status = [dict objectForKey:@"status"];
}
@end






