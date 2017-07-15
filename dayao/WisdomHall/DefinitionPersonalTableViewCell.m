//
//  DefinitionPersonalTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/30.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "DefinitionPersonalTableViewCell.h"


@interface DefinitionPersonalTableViewCell ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic,assign)int temp;
@property (nonatomic,strong)UIButton * g;

@end
@implementation DefinitionPersonalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _g = [UIButton buttonWithType:UIButtonTypeCustom];
    _g.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_g];
    [_g addTarget:self action:@selector(ggg:) forControlEvents:UIControlEventTouchUpInside];
    // Initialization code
}
-(void)addContentView:(NSString *)infoLabelText withTextFileText:(NSString *)textFile withIndex:(int)n{
    _infoLabel.text = infoLabelText;
    _textFile.tag = n;
    _textFile.placeholder = infoLabelText;
    _textFile.text = textFile;
    _textFile.delegate = self;
    if (n==5||n==8) {
        _textFile.keyboardType = UIKeyboardTypeNumberPad;
    }else if (n==4){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 40);
    }
    [_textFile addTarget:self action:@selector(textFileDidChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)addCourseContentView:(NSString *)infoLabelText withTextFileText:(NSString *)textFile withIndex:(int)n{
    _infoLabel.text = infoLabelText;
    _textFile.tag = n;
    _textFile.placeholder = infoLabelText;
    _textFile.text = textFile;
    _textFile.delegate = self;
    if (n==3) {
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 3;
    }else if (n==5){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 5;
    }else if (n == 4){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 4;
    }else if (n == 6){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 6;
    }else if (n == 7){
        _textFile.placeholder = [NSString stringWithFormat:@"%@ yyyy-mm-dd",infoLabelText];
    }else if (n == 8){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 8;
    }
    
    [_textFile addTarget:self action:@selector(textFileDidChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)addTemporaryCourseContentView:(NSString *)infoLabelText withTextFileText:(NSString *)textFile withIndex:(int)n{
    _infoLabel.text = infoLabelText;
    _textFile.tag = n;
    _textFile.placeholder = infoLabelText;
    _textFile.text = textFile;
    _textFile.delegate = self;
    if (n==3) {
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 3;
    }else if (n==5){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 5;
    }else if (n == 4){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 4;
    }else if (n == 6){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 6;
    }else if (n == 7){
        _textFile.placeholder = [NSString stringWithFormat:@"%@ yyyy-mm-dd",infoLabelText];
    }
    
    [_textFile addTarget:self action:@selector(textFileDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)textFileDidChange:(UITextField *)textFile{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textFileDidChangeForDPTableViewCellDelegate:)]) {
        [self.delegate textFileDidChangeForDPTableViewCellDelegate:textFile];
    }
}
-(void)ggg:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(gggDelegate:)]) {
        [self.delegate gggDelegate:btn];
    }
}
#pragma mark UITextFileDelegae
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textFieldDidBeginEditingDPTableViewCellDelegate:)]) {
        
        [self.delegate textFieldDidBeginEditingDPTableViewCellDelegate:textField];
    }
}
@end
