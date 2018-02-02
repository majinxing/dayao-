//
//  StatisticalModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/1/30.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticalModel : NSObject
@property (nonatomic,copy)NSString * departments;
@property (nonatomic,copy)NSString * professional;
@property (nonatomic,copy)NSString * theClass;
@property (nonatomic,copy)NSString * startTime;
@property (nonatomic,copy)NSString * endTime;
@property (nonatomic,copy)NSString * result;
-(BOOL)statisticalModelIsNil;
-(NSMutableDictionary *)returnDict;
@end
