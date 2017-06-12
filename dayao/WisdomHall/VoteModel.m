//
//  VoteModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/5.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "VoteModel.h"
#import "DYHeader.h"

@implementation VoteModel
-(instancetype)init{
    self = [super init];
    if (self) {
        _selectAry = [NSMutableArray arrayWithCapacity:4];
    }
    return self;
}
-(void)changeText:(UITextView *)textView{
    if (textView.tag == 0) {
        self.title = textView.text;
    }else if (textView.tag == 1){
        self.describe = textView.text;
    }else if (textView.tag == 2){
        self.largestNumbe = textView.text;
    }else if (textView.tag>2){
        [self.selectAry setObject:textView.text atIndexedSubscript:textView.tag-3];
    }

}
@end
