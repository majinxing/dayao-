//
//  CreateVoteTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/3.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CreateVoteTableViewCellDelegate <NSObject>

-(void)textFieldDidChangeDelegate:(UITextField *)textFile;

-(void)textViewBeginChangeDelegate:(UITextView *)textView;

-(void)addSelectNumberDelegate:(UIButton *)sender;

-(void)delectSelectNumberDelegate:(UIButton *)sender;

@end
@interface CreateVoteTableViewCell : UITableViewCell

@property (nonatomic,weak)id<CreateVoteTableViewCellDelegate>delegate;

-(void)addTableTextWithTextFile:(NSString *)labelText with:(NSString *)textFile withTag:(int)tag;

-(void)addSelectNumeberWithNumer:(NSString *)number withTag:(int)tag;

-(void)addSelectInfo:(NSString *)selectNumber withSelectText:(NSString *)selectText withTag:(int)tag;

@end
