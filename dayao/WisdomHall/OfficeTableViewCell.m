//
//  OfficeTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/23.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "OfficeTableViewCell.h"
#import "DYHeader.h"
#import "ShareButton.h"
#import "FMDBTool.h"


#define columns 4
#define buttonWH 60
#define marginHeight 25

@interface OfficeTableViewCell()
@property (strong, nonatomic) IBOutlet UIButton *signBtn;
@property (strong, nonatomic) IBOutlet UILabel *signIN;
@property (strong, nonatomic) IBOutlet UILabel *signBack;
@property (nonatomic,strong)FMDatabase * db;

@end
@implementation OfficeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _signBtn.layer.masksToBounds = YES;
    _signBtn.layer.cornerRadius = 40;
    _signBtn.backgroundColor = [UIColor colorWithHexString:@"#29a7e1"];
    [_signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self signState];
//    [self addSecondContentView];
    // Initialization code
}
-(void)signState{
    FMDatabase * db = [FMDBTool createDBWithName:SQLITE_NAME];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"select * from %@",DAILYCHECK_TABLE_NAME];
        FMResultSet * rs = [FMDBTool queryWithDB:db withSqlStr:sql];
        int n = 0;
        while (rs.next) {
            NSString * date = [rs stringForColumn:@"date"];
            NSString * today = [UIUtils getTime];
            if ([today isEqualToString:date]) {
                n = 1;
                NSString * signIn = [rs stringForColumn:@"signIn"];
                NSString * sInS = [rs stringForColumn:@"signInState"];
                if ([UIUtils isBlankString:signIn]) {
                    _signIN.text = @"签到状态:未签到";
                }else{
                    _signIN.text = [NSString stringWithFormat:@"签到状态:%@",sInS];
                }
                
                NSString * signBack = [rs stringForColumn:@"signBack"];
                NSString * sBS = [rs stringForColumn:@"signBackState"];
                if ([UIUtils isBlankString:signBack]) {
                    _signBack.text = @"签退状态:未签退";
                }else{
                    _signBack.text = [NSString stringWithFormat:@"签退状态:%@",sBS];
                }
                break;
            }
        }
    }
    [db close];

}
-(void)addSecondContentView{
   NSArray * array = @[
                       Meeting,
                       Announcement,
                       Leave,
                       Business,
                       Lotus,
                       Group
                       ];
    
    //水平间距
    int marginWidth = (APPLICATION_WIDTH - buttonWH * columns) / (columns + 1);
    //起始XY坐标
    int oneX = marginWidth;
    int oneY = marginHeight;
    
    for (int i = 0; i < array.count; i++)
    {
        //行
        int row = i / columns;
        //列
        int column = i % columns;
        
        int x = oneX + (buttonWH + marginWidth) * column;
        int y = oneY + (buttonWH + marginWidth) * row;
        
        ShareButton * button = [[ShareButton alloc] initWithFrame:CGRectMake(x, y, buttonWH, buttonWH) andType:array[i]];
        [button addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }
}
- (void)shareButtonClicked:(UIButton *)button
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(shareButtonClickedDelegate:)]) {
        [self.delegate shareButtonClickedDelegate:button.titleLabel.text];
    }

}
- (IBAction)signPressed:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(signBtnPressedDelegate:)]) {
        [self.delegate signBtnPressedDelegate:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
