//
//  SelectSchoolViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/30.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolModel.h"

typedef void (^ReturnTextBlock)(SchoolModel *returnText);

@interface SelectSchoolViewController : UIViewController
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
- (void)returnText:(ReturnTextBlock)block;
@end
