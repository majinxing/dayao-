//
//  TextsTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/8.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextModel.h"
@interface TextsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *moreImage;
@property (strong, nonatomic) IBOutlet UIButton *moreBtn;

-(void)addContentView:(TextModel *)t withIndex:(int)n;
@end
