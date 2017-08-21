//
//  VoteOption.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/21.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "VoteOption.h"

@implementation VoteOption
-(void)setInfoWithDict:(NSDictionary *)dict{
    _optionId = [dict objectForKey:@"id"];
    _content = [dict objectForKey:@"content"];
}
@end
