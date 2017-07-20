//
//  PersonalDataTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/10.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "PersonalDataTableViewCell.h"
#import "DYHeader.h"

@interface PersonalDataTableViewCell()<UITextFieldDelegate>


@end
@implementation PersonalDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UserModel * userl = [[Appsetting sharedInstance] getUsetInfo];
    _placeholder = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",userl.userName],[NSString stringWithFormat:@"%@",userl.studentId],[NSString stringWithFormat:@"%@",userl.schoolName],[NSString stringWithFormat:@"%@",userl.departmentsName],[NSString stringWithFormat:@"%@",userl.professionalName], nil];
    
    _labelAry = [NSArray arrayWithObjects:@"姓名",@"学号",@"学校",@"院系",@"专业", nil];
    
    // Initialization code
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"PersonalDataTableViewCellSecond";//对应xib中设置的identifier
    NSInteger index = 1; //xib中第几个Cell
    switch (indexPath.section) {
        case 0:
            identifier = @"PersonalDataTableViewCellFirst";
            index = 0;
            break;
        case 1:
            identifier = @"PersonalDataTableViewCellSecond";
            index = 1;
        default:
            break;
    }
    PersonalDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalDataTableViewCell" owner:self options:nil] objectAtIndex:index];
    }
    return cell;
}
-(void)setInfo:(NSString *)labelText withTextAry:(NSString *)textText isEdictor:(BOOL)edictor withRow:(NSInteger)n{
    _dataLabel.text = labelText;
    _textFilePh.placeholder = labelText;
    _textFilePh.text = textText;
    _textFilePh.delegate = self;
    _textFilePh.tag = n;
    [_textFilePh addTarget:self action:@selector(textFileDidChange:) forControlEvents:UIControlEventEditingChanged];
    if (edictor) {
        if (n<6) {
            _dataLabel.alpha = 0.5;
            _textFilePh.alpha = 0.5;
        }else{
            _textFilePh.enabled = YES ;
        }
    }else{
        _dataLabel.alpha = 1;
        _textFilePh.alpha = 1;
        _textFilePh.enabled = NO ;
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)textFileDidChange:(UITextField *)textField{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textFieldDidChangeDelegate:)]) {
        [self.delegate textFieldDidChangeDelegate:textField];
    }
}
@end
