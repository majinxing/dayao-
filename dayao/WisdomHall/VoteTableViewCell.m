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
@property (strong, nonatomic) IBOutlet UILabel *voteTitle;

@property (strong, nonatomic) IBOutlet UILabel *voteCreateTime;
@property (strong, nonatomic) IBOutlet UIView *backView;

@property (assign,nonatomic) int temp;

@end
@implementation VoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_voteTitle endEditing:NO];
    
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 5;
    
    // Initialization code
}
-(void)addContentView{
    _voteState.layer.masksToBounds = YES;
    _voteState.layer.cornerRadius = 10;
    
}
-(void)voteTitle:(NSString *)title withCreateTime:(NSString *)time withState:(NSString *)state withIndex:(int)n withVoteStatus:(NSString *)voteStatus{
    _voteTitle.text = [NSString stringWithFormat:@"%@",title];
    _voteCreateTime.text = [NSString stringWithFormat:@"%@",time];
    _voteState.text = [NSString stringWithFormat:@"%@:%@",voteStatus,state];
    _temp = n;
    
}
- (IBAction)more:(UIButton *)btn {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(moreVoteTableViewCellDelegate:)]) {
        btn.tag = _temp;
        [self.delegate moreVoteTableViewCellDelegate:btn];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
