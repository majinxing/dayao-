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
@implementation MJXChatCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor =  RGBA_COLOR(241, 241, 241, 1);

    // Initialization code
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView EMMessage:(EMMessage *)message {
    NSString * identifier;
    NSInteger index = 0;
    switch (message.body.type) {
        case EMMessageBodyTypeText://文字
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
    MJXChatCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MJXChatCellTableViewCell" owner:self options:nil] objectAtIndex:index];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
