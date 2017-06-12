//
//  QuestionsTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/23.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "QuestionsTableViewCell.h"

@implementation QuestionsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }return self;
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"QuestionsTableViewCellSecond";//对应xib中设置的identifier
    NSInteger index = 1; //xib中第几个Cell
    switch (indexPath.row) {
        case 0:
            identifier = @"QuestionsTableViewCellFirst";
            index = 0;
            break;
        case 1:
            identifier = @"QuestionsTableViewCellSecond";
            index = 1;
            break;
        default:
            break;
    }
    QuestionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QuestionsTableViewCell" owner:self options:nil] objectAtIndex:index];
    }
    return cell;
}
-(void)settitleTextViewText:(NSString *)text withAllQuestionNumber:(NSString *)allNum withquestionNumber:(NSString *)qNum{
    self.titleTextView.text = [NSString stringWithFormat:@"题目:  %@",text];
}
-(void)setOptionsText:(NSString *)options WithOptionsText:(NSString *)opionsText WithSelectState:(NSString *)select indexRow:(int)row{
    _optionsLabel.text = options;
    _optionsTextView.text = opionsText;
    if ([select isEqualToString:@"选中"]) {
        _selecteImage.image = [UIImage imageNamed:@"方形选中-fill"];
    }else{
        _selecteImage.image = [UIImage imageNamed:@"方形未选中"];
    }
    _selectBtn.tag = row;
    
}
- (IBAction)selectBtnPressed:(UIButton*)btn {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectBtnPressedDelegate:)]) {
        [self.delegate selectBtnPressedDelegate:btn];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
