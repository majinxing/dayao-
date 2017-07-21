//
//  Questions.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/22.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "Questions.h"
#import "UIUtils.h"
#import "FMDBTool.h"
#import "FMDatabase.h"
#import "DYHeader.h"

@interface Questions()
@property(nonatomic,strong)FMDatabase * db;//数据库

@end
@implementation Questions
-(instancetype)init{
    self = [super init];
    if (self) {
        self.questionsID = [UIUtils getCurrentDate];
        self.score = @"";
        self.difficulty = @"";
        self.optionsA = @"";
        self.optionsB = @"";
        self.optionsC = @"";
        self.optionsD = @"";
        self.answer = @"";
        self.multiSelect = @"";
        self.title = @"";
        _db = [FMDBTool createDBWithName:SQLITE_NAME];
    }
    return self;
}
/**
 * 判断试题属性是否为空
 **/
-(BOOL)whetherIsEmpty{
    if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",self.questionsID]]) {
        return NO;
    }else if ([UIUtils isBlankString:self.score]){
        return NO;
    }else if ([UIUtils isBlankString:self.difficulty]){
        return NO;
    }else if ([UIUtils isBlankString:self.optionsA]&&[UIUtils isBlankString:self.optionsB]&&[UIUtils isBlankString:self.optionsC]&&[UIUtils isBlankString:self.optionsD]){
        return NO;
    }else if ([UIUtils isBlankString:self.answer]){
        return NO;
    }else if ([UIUtils isBlankString:self.multiSelect]){
        return NO;
    }else if ([UIUtils isBlankString:self.title]){
        return NO;
    }
    return YES;
}
-(NSString *)returnQuestionAttribute:(NSString *)title{
    if ([title isEqualToString:@"测试题目："]) {
        return self.title;
    }else if ([title isEqualToString:@"试题分值："]){
        return self.score;
    }else if ([title isEqualToString:@"难易程度："]){
        return self.difficulty;
    }else if ([title isEqualToString:@"A:"]){
        return self.optionsA;
    }else if ([title isEqualToString:@"B:"]){
        return self.optionsB;
    }else if ([title isEqualToString:@"C:"]){
        return self.optionsC;
    }else if ([title isEqualToString:@"D:"]){
        return self.optionsD;
    }else if ([title isEqualToString:@"题目答案:"]){
        return self.answer;
    }
    return @"";
}
-(void)setAttributeFromStr:(NSString *)title withTextView:(NSString *)text{
    if ([title isEqualToString:@"测试题目："]) {
        self.title = text;
    }else if ([title isEqualToString:@"试题分值："]){
        self.score = text;
    }else if ([title isEqualToString:@"难易程度："]){
        self.difficulty = text;
    }else if ([title isEqualToString:@"A:"]){
        self.optionsA = text;
    }else if ([title isEqualToString:@"B:"]){
        self.optionsB = text;
    }else if ([title isEqualToString:@"C:"]){
        self.optionsC = text;
    }else if ([title isEqualToString:@"D:"]){
        self.optionsD = text;
    }else if ([title isEqualToString:@"题目答案:"]){
        self.answer = text;
    }
}
-(void)insertedIntoTextTable{
    [self creatTextTable:QUESTIONS_TABLE_NAME];
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"insert into %@ (questionsID, title,score,difficulty,optionsA,optionsB,optionsC,optionsD,answer,multiSelect) values ('%@', '%@','%@','%@','%@','%@','%@','%@','%@','%@')",QUESTIONS_TABLE_NAME,_questionsID,_title,_score,_difficulty,_optionsA,_optionsB,_optionsC,_optionsD,_answer,_multiSelect];
        BOOL rs = [FMDBTool insertWithDB:_db tableName:QUESTIONS_TABLE_NAME withSqlStr:sql];
        if (!rs) {
            NSLog(@"失败");
        }
    }
    [_db close];
}
-(void)creatTextTable:(NSString *)tableName{
    if ([_db open]) {
        BOOL result = [FMDBTool createTableWithDB:_db tableName:tableName
                                       parameters:@{
                                                    @"questionsID" : @"text",
                                                    @"title" : @"text",
                                                    @"score" : @"text",
                                                    @"difficulty" : @"text",
                                                    @"optionsA" : @"text",
                                                    @"optionsB" : @"text",
                                                    @"optionsC" :@"text",
                                                    @"optionsD":@"text",
                                                    @"answer" : @"text",
                                                    @"multiSelect":@"text",
                                                    }];
        if (result)
        {
            NSLog(@"建表成功");
        }
        else
        {
            NSLog(@"建表失败");
        }
    }
    [_db close];
}
-(void)selectContactTable{

}

@end
