//
//  CreateVoteTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/3.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CreateVoteTableViewCellDelegate <NSObject>
-(void)textFileTextChangeDelegate:(UITextView *)textFile;


@end
@interface CreateVoteTableViewCell : UITableViewCell
@property (nonatomic,strong)id<CreateVoteTableViewCellDelegate>delegate;
-(void)addTableTextWithTextFile:(NSString *)labelText with:(NSString *)textFile withTag:(int)tag;
-(void)addSelectNumeberWithNumer:(NSString *)number withTag:(int)tag;
@end
