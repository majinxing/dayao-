//
//  CreateTextTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/12.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateTextTableViewCellDelegate <NSObject>
-(void)createTopicPressedDelegate;
-(void)returnTextViewTextWithLabelDelegate:(NSString *)labelText withTextViewText:(NSString *)textViewText;
-(void)retuanAnswerDelegate;
@end
@interface CreateTextTableViewCell : UITableViewCell

@property (nonatomic,strong) id<CreateTextTableViewCellDelegate>delegate;
-(void)textLabelText:(NSString *)textStr;
-(void)textViewText:(NSString *)text;
@end
