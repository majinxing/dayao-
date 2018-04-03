//
//  CreateVoteTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/3.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CreateVoteTableViewCell.h"
#import "DYHeader.h"

@interface CreateVoteTableViewCell()<UITextViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) NSString * lableText;
@property (strong, nonatomic) IBOutlet UITextView *textFile;

@property (strong, nonatomic) IBOutlet UITextField *selectNumTextView;

@property (strong, nonatomic) IBOutlet UILabel *selectLabel;
@property (weak, nonatomic) IBOutlet UITextView *selectTextView;
@property (weak, nonatomic) IBOutlet UIButton *delectBtn;


@end
@implementation CreateVoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lableText = [[NSString alloc] init];
    _selectNumTextView.delegate = self;
    _selectTextView.delegate = self;
    _textFile.delegate = self;
    // Initialization code
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
-(void)addSelectNumeberWithNumer:(NSString *)number withTag:(int)tag{
    _selectNumTextView.text = number;
    _selectNumTextView.keyboardType = UIKeyboardTypeNumberPad;
    _selectNumTextView.placeholder = @"输入投票的最多选项输如：1";
    _selectNumTextView.tag = tag;
    [_selectNumTextView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)addSelectInfo:(NSString *)selectNumber withSelectText:(NSString *)selectText withTag:(int)tag{
    _selectLabel.text = selectNumber;
    _selectTextView.text = selectText;
    _selectTextView.tag = tag+1;
    _selectTextView.layer.masksToBounds = YES;
    _selectTextView.layer.cornerRadius = 5;
    _selectTextView.layer.borderWidth = 1;
    _selectTextView.layer.borderColor = RGBA_COLOR(224,224,224, 1).CGColor;
    _delectBtn.tag = tag+1;
}

-(void)addTableTextWithTextFile:(NSString *)labelText with:(NSString *)textFile withTag:(int)tag{
    if ([UIUtils isBlankString:textFile]) {
        _titleLabel.text = labelText;
    }else{
        _titleLabel.text = @"";
    }
    _lableText = labelText;
    _textFile.text = textFile;
    _textFile.tag = 111;
    
}
- (IBAction)delectSelectNumber:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(delectSelectNumberDelegate:)]) {
        
        [self.delegate delectSelectNumberDelegate:sender];
    }
}

- (IBAction)addSelectNumber:(UIButton *)sender {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(addSelectNumberDelegate:)]) {
        
        [self.delegate addSelectNumberDelegate:sender];
        
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark textFiledDelegate
-(void)textFieldDidChange:(UITextField *)textFile{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textFieldDidChangeDelegate:)]) {
        [self.delegate textFieldDidChangeDelegate:textFile];
    }
}

#pragma mark textViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textViewBeginChangeDelegate:)]) {
        [self.delegate textViewBeginChangeDelegate:textView];
    }
}




@end
