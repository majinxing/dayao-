//
//  QuestionModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "QuestionModel.h"
#import "optionsModel.h"

@implementation QuestionModel
-(instancetype)init{
    self = [super init];
    if (self) {
        _questionTitleImageAry = [NSMutableArray arrayWithCapacity:1];
        
        _questionTitleImageIdAry = [NSMutableArray arrayWithCapacity:1];
        
        [self addOptions];
    }
    return self;
}
-(void)addOptions{
    _qustionOptionsAry = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i<4; i++) {
        optionsModel * o = [[optionsModel alloc] init];
        [_qustionOptionsAry addObject:o];
    }
    
}
@end
