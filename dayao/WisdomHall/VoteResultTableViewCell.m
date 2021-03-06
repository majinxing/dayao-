//
//  VoteResultTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/26.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "VoteResultTableViewCell.h"
#import "VoteOption.h"
#import "DYHeader.h"
@interface VoteResultTableViewCell()<UITextViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextView *optionList;

@property (strong, nonatomic) IBOutlet UILabel *votes;
@property (strong, nonatomic) UIView *redView;
@property (strong, nonatomic) IBOutlet UIView *garyView;
@property (strong, nonatomic) IBOutlet UILabel *percentage;
@property (strong, nonatomic) IBOutlet UILabel *voteNumber;

@end
@implementation VoteResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _garyView.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    
    _redView = [[UIView alloc] init];
    
    _redView.backgroundColor = [UIColor colorWithHexString:@"#0071FD"];
    
    [_garyView addSubview:_redView];
    
    _garyView.layer.masksToBounds = YES;
    
    _garyView.layer.cornerRadius = 5;
    
    _percentage.textColor = [UIColor colorWithRed:0/255.0 green:118/255.0 blue:253/255.0 alpha:1/1.0];
    
    _percentage.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    
    // Initialization code
}
-(void)addContentViewWith:(VoteOption *)voteOption withAllVotes:(NSString *)allNumber withIndex:(int)n{
    
    _optionList.text = [NSString stringWithFormat:@"选项%d: %@",n,voteOption.content];
    
    _votes.text = [NSString stringWithFormat:@"%@票",voteOption.count];
    
    double a = [voteOption.count doubleValue]/[allNumber doubleValue];
    
    CGFloat b = APPLICATION_WIDTH-50;
    
    
    _redView.frame = CGRectMake(0,0, a*b, 10);
    
    _redView.layer.masksToBounds = YES;
    
    _redView.layer.cornerRadius = 5;
    
    _percentage.text = [NSString stringWithFormat:@"%.0f%%",a*100];
}
-(void)addSecondContentView:(NSString *)n{
    _voteNumber.text = [NSString stringWithFormat:@"%@人提交",n];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark textFiledDelegate
-(void)textFieldDidChange:(UITextField *)textFile{
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(textFieldDidChangeDelegate:)]) {
//        [self.delegate textFieldDidChangeDelegate:textFile];
//    }
}

#pragma mark textViewDelegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    CGRect bounds = textView.bounds;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size = newSize;
    textView.bounds = bounds;
    // 让 table view 重新计算高度
    UITableView *tableView = [self tableView];
    
    [tableView beginUpdates];
    [tableView endUpdates];
    
//    if (textView.text.length>0) {
//        _titleLabel.text = @"";
//    }else if (textView.text.length == 0){
//        _titleLabel.text = _lableText;
//    }
//    
    [self voteTextFileTextChange:textView];
    
    //    [self returnTextViewTithLabel:_labelText.text withTextViewText:textView.text];
}
-(void)voteTextFileTextChange:(UITextView *)textView{
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(textFileTextChangeDelegate:)]) {
//        [self.delegate textFileTextChangeDelegate:textView];
//    }
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}
@end
