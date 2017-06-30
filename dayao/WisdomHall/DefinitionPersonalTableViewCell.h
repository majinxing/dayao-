//
//  DefinitionPersonalTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/30.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DefinitionPersonalTableViewCellDelegate <NSObject>
-(void)textFileDidChangeForDPTableViewCellDelegate:(UITextField *)textFile;
-(void)textFieldDidBeginEditingDPTableViewCellDelegate:(UITextField *)textFile;
-(void)gggDelegate:(UIButton *)btn;
@end

@interface DefinitionPersonalTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *textFile;

@property (nonatomic,weak)id<DefinitionPersonalTableViewCellDelegate>delegate;
-(void)addContentView:(NSString *)infoLabelText withTextFileText:(NSString *)textFile withIndex:(int)n;
@end