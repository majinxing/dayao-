//
//  SeatIngModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "SeatIngModel.h"

@implementation SeatIngModel
-(void)setInfoWithDict:(NSDictionary *)dict{
    _seatTable = [dict objectForKey:@"seat"];
    _seatTableId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    _seatTableNamel = [dict objectForKey:@"name"];
}
@end
