//
//  EditerTextViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/4/3.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditerTextViewController : UIViewController
-(instancetype)initWithText:(void(^)(NSString * text))textBlock;
@property (nonatomic,strong)UITextView * textView;
@property (nonatomic,copy) NSString * textStr;
@end
