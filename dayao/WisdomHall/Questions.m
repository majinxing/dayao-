//
//  Questions.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/22.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "Questions.h"
#import "UIUtils.h"
#import "DYHeader.h"

@interface Questions()

@end
@implementation Questions
-(instancetype)init{
    self = [super init];
    if (self) {
        self.questionsID = [UIUtils getCurrentDate];
        self.score = @"";
        self.difficulty = @"";
        self.answer = @"";
        self.multiSelect = @"";
        self.title = @"";
    }
    return self;
}
/**
 * 判断试题属性是否为空
 **/
-(BOOL)whetherIsEmpty{
    
    return YES;
}
-(void)setSelfInfoWithDict:(NSDictionary *)dict{
    _title = [dict objectForKey:@"content"];
    _multiSelect = [dict objectForKey:@"typeName"];
    _questionsID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"examQuestionId"]];
    _answer = [[NSString alloc] init];
}

@end
