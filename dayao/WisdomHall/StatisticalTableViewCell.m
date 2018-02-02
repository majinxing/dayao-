//
//  StatisticalTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/1/29.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "StatisticalTableViewCell.h"


@interface StatisticalTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *textLabelStr;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end
@implementation StatisticalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)addContentView:(NSString *)titleStr withText:(NSString *)textStr{
    _titleLabel.text = titleStr;
    _textLabelStr.text = [NSString stringWithFormat:@"%@   >",textStr];
}
- (IBAction)selectBtnPressed:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectBtnPressedDelegate:)]) {
        [self.delegate selectBtnPressedDelegate:sender];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
