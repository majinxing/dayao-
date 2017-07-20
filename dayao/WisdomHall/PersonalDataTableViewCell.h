//
//  PersonalDataTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/10.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PersonalDataTableViewCellDelegate <NSObject>

-(void)textFieldDidChangeDelegate:(UITextField *)textFile;

@end
@interface PersonalDataTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UITextField *textFilePh;
@property (nonatomic,weak)id<PersonalDataTableViewCellDelegate>delegate;
@property (nonatomic,strong)NSArray * placeholder;
@property (nonatomic,strong)NSArray * labelAry;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
-(void)setInfo:(NSString *)labelText withTextAry:(NSString *)textText isEdictor:(BOOL)edictor withRow:(NSInteger)n;
@end
