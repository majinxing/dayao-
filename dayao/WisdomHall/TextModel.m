//
//  TextModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/18.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "TextModel.h"
#import "UIUtils.h"


@interface TextModel()

@end
@implementation TextModel
-(instancetype)init{
    self = [super init];
    if (self) {
        self.textState = @"未开始";
        self.textId = [NSString stringWithFormat:@"%@",[UIUtils getCurrentDate]];
        self.totalScore = @"0";
        self.totalNumber = @"0";
    }
    return self;
}
/**
 *
 **/
-(BOOL)whetherIsEmpty{
    if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",self.textId]]) {
        return NO;
    }else if ([UIUtils isBlankString:self.title]){
        return NO;
    }else if ([UIUtils isBlankString:self.type]){
        return NO;
    }else if ([UIUtils isBlankString:self.indexPoint]){
        return NO;
    }else if ([UIUtils isBlankString:self.timeLimit]){
        return NO;
    }else if ([UIUtils isBlankString:self.textState]){
        return NO;
    }else if ([UIUtils isBlankString:self.redo]){
        return NO;
    }
    return YES;
}

-(void)setSelfInfoWithDict:(NSDictionary *)dict{
    _textId = [dict objectForKey:@"id"];
    _createName = [dict objectForKey:@"createName"];
    _statusName = [dict objectForKey:@"statusName"];
    _createUserId = [dict objectForKey:@"createUser"];
    _score = [dict objectForKey:@"score"];
    _title = [dict objectForKey:@"name"];
    
}

@end
