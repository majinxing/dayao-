//
//  TextModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/18.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "TextModel.h"
#import "UIUtils.h"
#import "FMDBTool.h"
#import "FMDatabase.h"

@interface TextModel()
@property (nonatomic,strong)FMDatabase * db;

@end
@implementation TextModel
-(instancetype)init{
    self = [super init];
    if (self) {
        self.textState = @"未开始";
        self.textId = [NSString stringWithFormat:@"%@",[UIUtils getCurrentDate]];
        self.totalScore = @"0";
        self.totalNumber = @"0";
        _db = [FMDBTool createDBWithName:SQLITE_NAME];
    }
    return self;
}
/**
 *
 **/
-(BOOL)whetherIsEmpty{
    if ([UIUtils isBlankString:self.textId]) {
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
/**
 * 更改数据库试卷表中的题目总数和总分属性
 **/
-(void)changeTotalNumberWithTitle:(NSString *)titleScore{
    if ([_db open]) {
        NSString * n = [NSString stringWithFormat:@"%ld",[self.totalNumber integerValue]+1];
        NSString * sql = [NSString stringWithFormat:@"update %@ set totalNumber = '%@' where textId = '%@' ;",TEXT_TABLE_NAME,n,self.textId];
        BOOL rs = [FMDBTool updateWithDB:_db withSqlStr:sql];
        NSString * score = [NSString stringWithFormat:@"%ld",[self.totalScore integerValue]+[titleScore integerValue]];
        NSString * sql1 = [NSString stringWithFormat:@"update %@ set totalScore = '%@' where textId = '%@' ;",TEXT_TABLE_NAME,score,self.textId];
        BOOL r = [FMDBTool updateWithDB:_db withSqlStr:sql1];
    }
    [_db close];
}
-(void)selectContactTable{
    
}

@end
