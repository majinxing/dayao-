//
//  JoinVoteTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/7.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "JoinVoteTableViewCell.h"


@interface JoinVoteTableViewCell()
@property (strong, nonatomic) IBOutlet UITextView *firstTextView;
@property (strong, nonatomic) IBOutlet UILabel *firstLabel;

@property (strong, nonatomic) IBOutlet UITextView *secondTextVIew;
@property (strong, nonatomic) IBOutlet UIButton *voteBtn;

@end
@implementation JoinVoteTableViewCell

- (void)awakeFromNib {
    [_voteBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [super awakeFromNib];
    // Initialization code
}
-(void)setTileOrdescribe:(NSString *)title withLableText:(NSString *)labelText{
    _firstTextView.text = [NSString stringWithFormat:@"%@",title];
    _firstLabel.text = [NSString stringWithFormat:@"%@",labelText];
}
-(void)setSelectText:(NSString *)selectText withTag:(int)tag{
    _secondTextVIew.text = selectText;
    _voteBtn.tag = tag;
}
- (IBAction)voteBtnPressed:(UIButton *)btn {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(voteBtnDelegatePressed:)]) {
        [self.delegate voteBtnDelegatePressed:btn];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
