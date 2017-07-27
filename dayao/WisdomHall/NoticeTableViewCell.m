//
//  NoticeTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/10.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "NoticeTableViewCell.h"

@interface NoticeTableViewCell()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *noticeName;
@property (strong, nonatomic) IBOutlet UILabel *noticeTime;

@property (strong, nonatomic) IBOutlet UITextView *noteContent;


@end
@implementation NoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setContentView:(NSString *)time withNoticContent:(NSString *)content{
    _noticeTime.text = time;
    _noteContent.text = content;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    if ([_labelText.text isEqualToString:@"题目答案:"]) {
//        if (self.delegate&&[self.delegate respondsToSelector:@selector(retuanAnswerDelegate)]) {
//            [self.delegate retuanAnswerDelegate];
//        }
//        return NO;
//    }
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
//    [self returnTextViewTextWithLabel:_labelText.text withTextViewText:textView.text];
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
