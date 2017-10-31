//
//  MeetingTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/10/24.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "MeetingTableViewCell.h"
#import "MeetingModel.h"
#import "DYHeader.h"
#import "ShareButton.h"

#define columns 4
#define buttonWH 60
#define marginHeight 25

@interface MeetingTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *meetName;
@property (strong, nonatomic) IBOutlet UILabel *meetTime;
@property (strong, nonatomic) IBOutlet UILabel *meetPlace;
@property (strong, nonatomic) IBOutlet UILabel *meetHost;
@property (strong, nonatomic) IBOutlet UILabel *meetCode;
@property (weak, nonatomic) IBOutlet UIButton *singNumber;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UIButton *code;


@end
@implementation MeetingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)addFirstContentView:(MeetingModel *)meetModel{
    if ([UIUtils isBlankString:meetModel.meetingName]) {
        _meetName.text = @"会议名称：";
    }else{
        _meetName.text = [NSString stringWithFormat:@"会议名称：%@",meetModel.meetingName];
    }
    if ([UIUtils isBlankString:meetModel.meetingHost]) {
        _meetHost.text = @"主持人：";
    }else{
        _meetHost.text = [NSString stringWithFormat:@"主持人：%@",meetModel.meetingHost];
    }
    _meetTime.text = [NSString stringWithFormat:@"时间：%@",meetModel.meetingTime];
    _meetCode.text = [NSString stringWithFormat:@"邀请码：%@",meetModel.meetingId];
    _meetPlace.text = [NSString stringWithFormat:@"地址：%@",meetModel.meetingPlace];
}
-(void)addFirstCOntentViewWithClassModel:(ClassModel *)classModel{
    _meetName.text = [NSString stringWithFormat:@"课程名：%@",classModel.name];
    NSMutableString *strUrl = [NSMutableString stringWithFormat:@"%@",classModel.time];
    [strUrl deleteCharactersInRange:NSMakeRange(strUrl.length-3, 3)];
    _meetTime.text = [NSString stringWithFormat:@"时间：%@",strUrl];
    _meetPlace.text = [NSString stringWithFormat:@"教室：%@",classModel.typeRoom];
    _meetHost.text = [NSString stringWithFormat:@"主持人：%@",classModel.teacherName];
    _meetCode.text = [NSString stringWithFormat:@"邀请码：%@",classModel.sclassId];
}
-(void)addSecondContentView:(MeetingModel *)meetModel{
    [_singNumber setTitle:[NSString stringWithFormat:@"已签/未签：%ld/%ld",(long)meetModel.n,(long)meetModel.m] forState:UIControlStateNormal];
}
-(void)addSecondContentViewWithClassModel:(ClassModel *)classModel{
    [_singNumber setTitle:[NSString stringWithFormat:@"已签/未签：%ld/%ld",(long)classModel.n,(long)classModel.m] forState:UIControlStateNormal];

}
-(void)addFourthContentView:(MeetingModel *)meetModel{
    NSArray * array = @[
                         InteractionType_Data,
                         InteractionType_Vote,
                         InteractionType_Responder,
                         InteractionType_Discuss,
                         InteractionType_Sit
                         ];
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    if ([[NSString stringWithFormat:@"%@",user.peopleId] isEqualToString:[NSString stringWithFormat:@"%@",meetModel.meetingHostId]]) {
        array = @[
                  InteractionType_Data,
                  InteractionType_Vote,
                  InteractionType_Responder,
                  InteractionType_Discuss,
                  ];
    }
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
-(void)addFourthContentViewWithClassModel:(ClassModel *)classModel{
    NSArray * array = @[
                              InteractionType_Data,
                              InteractionType_Vote,
                              InteractionType_Responder,
                              InteractionType_Test,
                              InteractionType_Discuss
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
-(void)addThirdContentView:(MeetingModel *)meetModel{
    if ([[NSString stringWithFormat:@"%@",meetModel.signStatus] isEqualToString:@"1"]) {
        [_signBtn setTitle:@"签到状态：未签到" forState:UIControlStateNormal];
        [_code setTitle:@"二维码签到" forState:UIControlStateNormal];
        [_signBtn setEnabled:YES];

    }else if([[NSString stringWithFormat:@"%@",meetModel.signStatus] isEqualToString:@"2"]){
        [_signBtn setTitle:@"签到状态：已签到" forState:UIControlStateNormal];
        [_code setTitle:@"生成二维码" forState:UIControlStateNormal];
        [_signBtn setEnabled:NO];
    }else if ([[NSString stringWithFormat:@"%@",meetModel.signStatus] isEqualToString:@"3"]){
        [_signBtn setTitle:@"签到状态：正在签到，请不要退出界面" forState:UIControlStateNormal];
        [_code setTitle:@"二维码签到" forState:UIControlStateNormal];
        [_signBtn setEnabled:NO];
    }else if ([[NSString stringWithFormat:@"%@",meetModel.signStatus] isEqualToString:@"4"]){
        [_signBtn setTitle:@"签到状态：连接数据流量后再次点击" forState:UIControlStateNormal];
        [_code setTitle:@"二维码签到" forState:UIControlStateNormal];
        [_signBtn setEnabled:YES];

    }
}
-(void)addThirdContentViewWithClassModel:(ClassModel *)meetModel{
    if ([[NSString stringWithFormat:@"%@",meetModel.signStatus] isEqualToString:@"1"]) {
        [_signBtn setTitle:@"签到状态：未签到" forState:UIControlStateNormal];
        [_code setTitle:@"二维码签到" forState:UIControlStateNormal];
        [_signBtn setEnabled:YES];
        
    }else if([[NSString stringWithFormat:@"%@",meetModel.signStatus] isEqualToString:@"2"]){
        [_signBtn setTitle:@"签到状态：已签到" forState:UIControlStateNormal];
        [_code setTitle:@"生成二维码" forState:UIControlStateNormal];
        [_signBtn setEnabled:NO];
    }else if ([[NSString stringWithFormat:@"%@",meetModel.signStatus] isEqualToString:@"3"]){
        [_signBtn setTitle:@"签到状态：正在签到，请不要退出界面" forState:UIControlStateNormal];
        [_code setTitle:@"二维码签到" forState:UIControlStateNormal];

        [_signBtn setEnabled:NO];
    }else if ([[NSString stringWithFormat:@"%@",meetModel.signStatus] isEqualToString:@"4"]){
        [_signBtn setTitle:@"签到状态：连接数据流量后再次点击" forState:UIControlStateNormal];
        [_code setTitle:@"二维码签到" forState:UIControlStateNormal];

        [_signBtn setEnabled:YES];
        
    }
}
-(void)shareButtonClicked:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(shareButtonClickedDelegate:)]) {
        [self.delegate shareButtonClickedDelegate:btn.titleLabel.text];
    }
}
- (IBAction)peopleManagement:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(peopleManagementDelegate)]) {
        [self.delegate peopleManagementDelegate];
    }
}
- (IBAction)signNOPeople:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(signNOPeopleDelegate)]) {
        [self.delegate signNOPeopleDelegate];
    }
}
- (IBAction)signBtnPressed:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(signBtnPressedDelegate:)]) {
        [self.delegate signBtnPressedDelegate:sender];
    }
}
- (IBAction)codePressed:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(codePressedDelegate:)]) {
        [self.delegate codePressedDelegate:sender];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
