//
//  ChoiceQuestionTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "optionsModel.h"


@protocol ChoiceQuestionTableViewCellDelegate <NSObject>
-(void)firstSelectImageBtnDelegate:(UIButton *)sender;
-(void)selectScoreDeleate:(UIButton *)sender;
-(void)selectDifficultyDelegate:(UIButton *)sender;
-(void)thirthSelectOptionsImageBtnDelegate:(UIButton *)sender;
-(void)addOptionsDelegate:(UIButton *)sender;
@end

@interface ChoiceQuestionTableViewCell : UITableViewCell

@property (nonatomic,weak)id<ChoiceQuestionTableViewCellDelegate>delegate;

-(void)addFirstTitleTextView:(NSString *)textStr withImageAry:(NSMutableArray *)ary withIsEdit:(BOOL)edit;

-(void)setScoreAndDifficult:(NSString *)score withDifficult:(NSString *)difficult withEdit:(BOOL)edit;

-(void)addOptionWithModel:(optionsModel *)optionsModel withEdit:(BOOL)edit withIndexRow:(int)row;
@end
