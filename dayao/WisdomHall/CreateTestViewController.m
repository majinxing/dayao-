//
//  CreateTestViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/6.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CreateTestViewController.h"
#import "TextListViewController.h"
#import "TextModel.h"
#import "FMDBTool.h"
#import "FMDatabase.h"
#import "DYHeader.h"
@interface CreateTestViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *creatTextButton;
@property (nonatomic,strong)TextModel * textModle;
@property (nonatomic,strong)FMDatabase * db;//数据库
@property (nonatomic,strong)NSMutableArray * textArray;
@end

@implementation CreateTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle];
    _textArray = [NSMutableArray arrayWithCapacity:1];
    _textModle = [[TextModel alloc] init];
    _db = [FMDBTool createDBWithName:SQLITE_NAME];
    [self creatTextTable:TEXT_TABLE_NAME];
    [self addNotificationToTextFile];
    // Do any additional setup after loading the view from its nib.
}
-(void)addNotificationToTextFile{
    [_titleTextFile addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_typeTextFile addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_redoTextFile addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_indexPoint addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_timeLimitTextFile addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //[self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"创建测试";
}
- (IBAction)creatTextButtonPressed:(id)sender {
    
    if ([_textModle whetherIsEmpty]) {
        
        [self insertedIntoTextTable];
        
        TextListViewController * tqVC = [[TextListViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        tqVC.t = _textModle;
        [self.navigationController pushViewController:tqVC animated:YES];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"不能为空" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark textFileDelegate
-(void)textFieldTextDidChange:(UITextField *)textFile{
    if (textFile.tag == 1) {
        _textModle.title = textFile.text;
    }else if (textFile.tag == 2){
        _textModle.type = textFile.text;
    }else if (textFile.tag == 3){
        _textModle.indexPoint = textFile.text;
    }else if (textFile.tag == 4){
        _textModle.timeLimit = textFile.text;
    }else if (textFile.tag == 5){
        _textModle.redo = textFile.text;
    }
}
#pragma mark FMDB
-(void)insertedIntoTextTable{
    if ([_db open]) {
            NSString * sql = [NSString stringWithFormat:@"insert into %@ (textId, title,type,indexPoint,timeLimit,textState,redo,totalScore,totalNumber) values ('%@', '%@','%@','%@','%@','%@','%@','%@','%@')",TEXT_TABLE_NAME,_textModle.textId,_textModle.title,_textModle.type,_textModle.indexPoint,_textModle.timeLimit,_textModle.textState,_textModle.redo,_textModle.totalScore,_textModle.totalNumber];
            BOOL rs = [FMDBTool insertWithDB:_db tableName:TEXT_TABLE_NAME withSqlStr:sql];
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
                                                    @"textId" : @"text",
                                                    @"title" : @"text",
                                                    @"type" : @"text",
                                                    @"indexPoint" : @"text",
                                                    @"timeLimit" : @"text",
                                                    @"textState" : @"text",
                                                    @"redo" :@"text",
                                                    @"totalScore":@"text",
                                                    @"totalNumber" : @"text",
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
