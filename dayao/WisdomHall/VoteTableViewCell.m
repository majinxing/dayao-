//
//  VoteTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "VoteTableViewCell.h"


@interface VoteTableViewCell()

@property (strong, nonatomic) IBOutlet UILabel *voteState;
@property (strong, nonatomic) IBOutlet UITextView *voteTitle;
@property (strong, nonatomic) IBOutlet UILabel *voteCreateTime;

@end
@implementation VoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addContentView];
    // Initialization code
}
-(void)addContentView{
    _voteState.layer.masksToBounds = YES;
    _voteState.layer.cornerRadius = 10;
    
}
-(void)voteTitle:(NSString *)title withCreateTime:(NSString *)time withState:(NSString *)state{
    _voteTitle.text = [NSString stringWithFormat:@"投票主题：%@",title];
    _voteCreateTime.text = [NSString stringWithFormat:@"创建时间：%@",time];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
