//
//  optionsModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "optionsModel.h"

@implementation optionsModel
-(instancetype)init{
    self = [super init];
    if (self) {
        _optionsImageAry = [NSMutableArray arrayWithCapacity:1];
        _optionsImageIdAry = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}
@end
