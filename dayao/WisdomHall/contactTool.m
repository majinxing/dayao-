//
//  contactTool.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/23.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "contactTool.h"
#import "DYHeader.h"
#import "FMDBTool.h"
#import "FMDatabase.h"
#import "DYHeader.h"
#import "ContactModel.h"
#import "Questions.h"

@interface contactTool()
@property(nonatomic,strong)FMDatabase * db;//数据库
@end
@implementation contactTool
/**
 * 搜索试卷中所有的题目id
 **/
+(NSMutableArray *)querContactTableData:(FMDatabase *)db withTextId:(NSString *)textId{
    NSMutableArray * ary = [NSMutableArray arrayWithCapacity:10];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"select * from %@ where textId = '%@'",CONTACT_TABLE_NAME,textId];
        FMResultSet * rs = [FMDBTool queryWithDB:db withSqlStr:sql];
        while (rs.next) {
            ContactModel * c = [[ContactModel alloc] init];
            c.questionsID = [rs stringForColumn:@"questionsID"];
            c.textId = [rs stringForColumn:@"textId"];
            c.qid = [rs stringForColumn:@"qid"];
            [ary addObject:c];
        }
    }
    [db close];
    return ary;
}
+(NSMutableArray *)returnQuestion:(FMDatabase *)db withTextId:(NSString *)textId{
    NSMutableArray * qAry = [NSMutableArray arrayWithCapacity:10];
    
    NSMutableArray * ary = [NSMutableArray arrayWithCapacity:10];
    ary = [contactTool querContactTableData:db withTextId:textId];
    
    for (int i = 0; i<ary.count; i++) {
        ContactModel * c = ary[i];
        if ([db open]) {
            NSString * sql = [NSString stringWithFormat:@"select * from %@ where questionsID = '%@'",QUESTIONS_TABLE_NAME,c.questionsID];
            FMResultSet * rs = [FMDBTool queryWithDB:db withSqlStr:sql];
            while (rs.next) {
                Questions * q = [[Questions alloc] init];
                q.questionsID = [rs stringForColumn:@"questionsID"];
                q.title = [rs stringForColumn:@"title"];
                q.score = [rs stringForColumn:@"score"];
                q.difficulty = [rs stringForColumn:@"difficulty"];
                q.optionsA = [rs stringForColumn:@"optionsA"];
                q.optionsB = [rs stringForColumn:@"optionsB"];
                q.optionsC = [rs stringForColumn:@"optionsC"];
                q.optionsD = [rs stringForColumn:@"optionsD"];
                q.answer = [rs stringForColumn:@"answer"];
                q.multiSelect = [rs stringForColumn:@"multiSelect"];
                q.qid = c.qid;
                [qAry addObject:q];
            }
        }
        [db close];
    }
    return qAry;
}
+(NSMutableArray *)returnQuestion:(FMDatabase *)db{
    
    NSMutableArray * qAry = [NSMutableArray arrayWithCapacity:10];
    
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"select * from %@ ",QUESTIONS_TABLE_NAME];
        FMResultSet * rs = [FMDBTool queryWithDB:db withSqlStr:sql];
        while (rs.next) {
            Questions * q = [[Questions alloc] init];
            q.questionsID = [rs stringForColumn:@"questionsID"];
            q.title = [rs stringForColumn:@"title"];
            q.score = [rs stringForColumn:@"score"];
            q.difficulty = [rs stringForColumn:@"difficulty"];
            q.optionsA = [rs stringForColumn:@"optionsA"];
            q.optionsB = [rs stringForColumn:@"optionsB"];
            q.optionsC = [rs stringForColumn:@"optionsC"];
            q.optionsD = [rs stringForColumn:@"optionsD"];
            q.answer = [rs stringForColumn:@"answer"];
            q.multiSelect = [rs stringForColumn:@"multiSelect"];
            [qAry addObject:q];
        }
        [db close];
    }
    return qAry;
}
@end
