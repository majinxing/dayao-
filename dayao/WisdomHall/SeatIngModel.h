//
//  SeatIngModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeatIngModel : NSObject
@property (nonatomic,copy)NSString * seatTable;
@property (nonatomic,copy)NSString * seatTableId;
@property (nonatomic,copy)NSString * seatTableNamel;
-(void)setInfoWithDict:(NSDictionary *)dict;
@end
