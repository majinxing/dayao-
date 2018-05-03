//
//  ChoiceQuestionTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "ChoiceQuestionTableViewCell.h"
#import "DYHeader.h"
#import "UIImageView+WebCache.h"


@interface ChoiceQuestionTableViewCell()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *firstBtnAWith;
@property (strong, nonatomic) IBOutlet UILabel *firstLabel;
@property (strong, nonatomic) IBOutlet UITextView *firstTitleTextView;
@property (strong, nonatomic) IBOutlet UIButton *firstBtnA;
@property (strong, nonatomic) IBOutlet UIButton *firstBtnB;
@property (strong, nonatomic) IBOutlet UIButton *firsthBtnC;
@property (strong, nonatomic) IBOutlet UIButton *firstBtnD;
@property (strong, nonatomic) IBOutlet UIButton *firstBtnE;
@property (strong, nonatomic) IBOutlet UIButton *firstBtnF;

@property (strong, nonatomic) IBOutlet UILabel *orderNumber;
@property (strong, nonatomic) IBOutlet UITextView *thirdOptionText;
@property (strong, nonatomic) IBOutlet UIButton *thirdBtnA;
@property (strong, nonatomic) IBOutlet UIButton *thirdBtnB;
@property (strong, nonatomic) IBOutlet UIButton *thirdBtnC;


@property (strong, nonatomic) IBOutlet UITextView *fourthAnswerTextView;
@property (strong, nonatomic) IBOutlet UILabel *fourthLabel;


@property (strong, nonatomic) IBOutlet UIButton *secondScoreBtn;
@property (strong, nonatomic) IBOutlet UIButton *secondDifficultBtn;

@property (nonatomic,strong) NSMutableArray * imageAry;

@property (nonatomic,strong) NSMutableArray * optionsImageAry;
@property (strong, nonatomic) IBOutlet UIButton *addCellNumberi;//选择题增加选项，填空提增加答案

@end


@implementation ChoiceQuestionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_firstBtnB setEnabled:NO];
    [_firsthBtnC setEnabled:NO];
    [_firstBtnD setEnabled:NO];
    [_firstBtnD setEnabled:NO];
    [_firstBtnE setEnabled:NO];
    
//    [_thirdBtnA setEnabled:NO];
    [_thirdBtnB setEnabled:NO];
    [_thirdBtnC setEnabled:NO];
    
    _imageAry = [[NSMutableArray alloc] init];
    
    _optionsImageAry = [NSMutableArray arrayWithCapacity:1];
    
    for (int i = 0; i<6;i++) {
        UIButton *btn = (UIButton *)[self.contentView viewWithTag:i+101];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height)];
        
        [_imageAry addObject:image];
    }
    for (int i = 0; i<3; i++) {
        UIButton *btn = (UIButton *)[self.contentView viewWithTag:i+1];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height)];
        
        [_optionsImageAry addObject:image];
    }
    // Initialization code
}
-(void)addFirstTitleTextView:(NSString *)textStr withImageAry:(NSMutableArray *)ary withIsEdit:(BOOL)edit{
    _firstTitleTextView.text = textStr;
    _firstLabel.text = @"";
    
    if (!edit) {
        if (ary.count>0) {
            
        }else{
            _firstBtnAWith.constant = 0;
        }
        for (int i=0; i<ary.count; i++) {
            UIImageView * image =_imageAry[i];
            
            UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
            
            NSString * baseUrl = user.host;
            
            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseUrl,FileDownload,ary[i]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            
            [self.contentView addSubview:image];
            
            UIButton *btn1 = [self viewWithTag:i+101];
            
            [btn1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
            [btn1 setEnabled:YES];
        }
    }else{
        for (int i = 0; i<ary.count; i++) {
            UIButton *btn = (UIButton *)[self.contentView viewWithTag:i+101];
            
            [btn setBackgroundImage:ary[i] forState:UIControlStateNormal];
            
            [btn setEnabled:YES];
        }
        
        if (ary.count<6) {
            UIButton *btn1 = [self viewWithTag:ary.count+101];
            
            [btn1 setEnabled:YES];
            
            [btn1 setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
        }
    }
    
}
-(void)setScoreAndDifficult:(NSString *)score withDifficult:(NSString *)difficult withEdit:(BOOL)edit{
    if (edit) {
        [_secondDifficultBtn setEnabled:YES];
        [_secondScoreBtn setEnabled:YES];
    }else{
        [_secondDifficultBtn setEnabled:NO];
        [_secondScoreBtn setEnabled:NO];
    }
    [_secondScoreBtn setTitle:[NSString stringWithFormat:@"  分数            %@",score] forState:UIControlStateNormal];
    [_secondDifficultBtn setTitle:[NSString stringWithFormat:@"  难度            %@",difficult] forState:UIControlStateNormal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)addOptionWithModel:(optionsModel *) optionsM withEdit:(BOOL)edit withIndexRow:(int)row{
    _orderNumber.text = [NSString stringWithFormat:@"%c、",65+row];
    
    _thirdOptionText.text = optionsM.optionsTitle;
    
    _thirdBtnA.tag = (row+1)*1000+1;
    _thirdBtnB.tag = (row+1)*1000+2;
    _thirdBtnC.tag = (row+1)*1000+3;
    
    if (!edit) {
        if (optionsM.optionsImageIdAry.count>0) {
            
        }else{
            
        }
        
        for (int i=0; i<optionsM.optionsImageIdAry.count; i++) {
            UIImageView * image = _optionsImageAry[i];
            
            UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
            
            NSString * baseUrl = user.host;
            
            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseUrl,FileDownload,optionsM.optionsImageIdAry[i]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            
            [self.contentView addSubview:image];
            
            UIButton *btn1 = [self viewWithTag:i+(row+1)*1000+1];
            
            [btn1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

            [btn1 setEnabled:YES];
        }
    }else{
        for (int i = 0; i<optionsM.optionsImageAry.count; i++) {
            UIButton *btn = (UIButton *)[self.contentView viewWithTag:i+(row+1)*1000+1];
            
            [btn setBackgroundImage:optionsM.optionsImageAry[i] forState:UIControlStateNormal];
            
            [btn setEnabled:YES];
        }
        
        if (optionsM.optionsImageAry.count<3) {
            UIButton *btn1 = [self viewWithTag:optionsM.optionsImageAry.count+(row+1)*1000+1];
            
            [btn1 setEnabled:YES];
            
            [btn1 setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)addOption:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(addOptionsDelegate:)]) {
        [self.delegate addOptionsDelegate:sender];
    }
}
- (IBAction)createTheTitle:(UIButton *)sender {
    
}
- (IBAction)selectScore:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectScoreDeleate:)]) {
        [self.delegate selectScoreDeleate:sender];
    }
}
- (IBAction)selectDifficulty:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectDifficultyDelegate:)]) {
        [self.delegate selectDifficultyDelegate:sender];
    }
}

- (IBAction)firstSelectImageBtn:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(firstSelectImageBtnDelegate:)]) {
        [self.delegate firstSelectImageBtnDelegate:sender];
    }
}
- (IBAction)thirthSelectOptionsImageBtn:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(thirthSelectOptionsImageBtnDelegate:)]) {
        [self.delegate thirthSelectOptionsImageBtnDelegate:sender];
    }
}

@end
