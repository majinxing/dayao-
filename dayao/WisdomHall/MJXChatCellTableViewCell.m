//
//  MJXChatCellTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/26.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "MJXChatCellTableViewCell.h"
#import <Hyphenate/Hyphenate.h>

#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]

@interface MJXChatCellTableViewCell()
@property (weak, nonatomic) IBOutlet UITextView *firstTextView;
@property (weak, nonatomic) IBOutlet UITextView *fifthTextView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageVIew;
@property (weak, nonatomic) IBOutlet UIImageView *sixthImageView;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *seventhBtn;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@property (weak, nonatomic) IBOutlet UILabel *eigthLabel;
@property (weak, nonatomic) IBOutlet UIButton *fourthBtn;
@property (weak, nonatomic) IBOutlet UIButton *eigthBtn;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fifthNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixthNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *seventhNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eigthNameLabel;


@end

@implementation MJXChatCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor =  RGBA_COLOR(241, 241, 241, 1);
    
    // Initialization code
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView EMMessage:(EMMessage *)message {
    NSString * identifier;
    NSInteger index = 0;
    if (message.direction == EMMessageDirectionReceive) {
        switch (message.body.type) {
            case EMMessageBodyTypeText: //文字
                identifier = @"MJXChatCellTableViewCellFirst";
                index = 0;
                break;
            case EMMessageBodyTypeImage://图片
                identifier = @"MJXChatCellTableViewCellSecond";
                index = 1;
                break;
            case EMMessageBodyTypeVideo://视频
                identifier = @"MJXChatCellTableViewCellThird";
                index = 2;
                break;
            case EMMessageBodyTypeVoice://语音
                identifier = @"MJXChatCellTableViewCellForth";
                index = 3;
                break;
                
            default:
                break;
        }
    }else{
        switch (message.body.type) {
            case EMMessageBodyTypeText://文字
                identifier = @"MJXChatCellTableViewCellFifth";
                index = 4;
                break;
            case EMMessageBodyTypeImage://图片
                identifier = @"MJXChatCellTableViewCellSixth";
                index = 5;
                break;
            case EMMessageBodyTypeVideo://视频
                identifier = @"MJXChatCellTableViewCellSeventh";
                index = 6;
                break;
            case EMMessageBodyTypeVoice://语音
                identifier = @"MJXChatCellTableViewCellEighth";
                index = 7;
                break;
                
            default:
                break;
        }
        
    }
    MJXChatCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MJXChatCellTableViewCell" owner:self options:nil] objectAtIndex:index];
    }
    [cell setInfoWithNumber:index withMessage:message];
    return cell;
}
-(void)setInfoWithNumber:(NSInteger) n withMessage:(EMMessage *)message{
    if (n==0) {
        // 收到的文字消息
        EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
        _firstTextView.text = textBody.text;
        _firstNameLabel.text = [NSString stringWithFormat:@"%@",message.from];
    }else if (n==1){
        
    }else if (n==2){
        
    }else if (n==3){
        
    }else if (n==4){
        EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
        _fifthTextView.text = textBody.text;
        _fifthNameLabel.text = message.from;
    }else if (n==5){
        
    }else if (n==6){
        
    }else if (n==7){
        
    }else if (n==8){
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
