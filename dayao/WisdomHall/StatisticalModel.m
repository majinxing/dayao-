//
//  StatisticalModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/1/30.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "StatisticalModel.h"
#import "DYHeader.h"

@implementation StatisticalModel
-(BOOL)statisticalModelIsNil{
    if ([UIUtils isBlankString:self.departments]){
        return NO;
    }else if ([UIUtils isBlankString:self.startTime]){
        return NO;
    }else  if ([UIUtils isBlankString:self.endTime]){
        return NO;
    }
    return YES;
}
-(NSMutableDictionary *)returnDict{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"500" forKey:@"universityId"];
    if (![UIUtils isBlankString:self.departments]) {
        NSArray * ary = @[[NSString stringWithFormat:@"%@",self.departments]];
        [dict setObject:ary forKey:@"facultyIdList"];
    }
    if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",self.professional]]) {
        NSArray * ary = @[[NSString stringWithFormat:@"%@",self.professional]];
        [dict setObject:ary forKey:@"majorIdList"];
    }
    if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",self.theClass]]) {
        NSArray * ary = @[[NSString stringWithFormat:@"%@",self.theClass]];
        [dict setObject:ary forKey:@"classIdList"];
    }
    if (![UIUtils isBlankString:self.endTime]&&![UIUtils isBlankString:self.startTime]) {
        NSDictionary * d = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@ 00:00:00",self.startTime],@"startTime",[NSString stringWithFormat:@"%@ 23:59:59",self.endTime],@"endTime", nil];
        NSArray * ary = [[NSArray alloc] initWithObjects:d, nil];
        [dict setObject:ary forKey:@"timePeriodList"];
    }
    return dict;
}
@end
