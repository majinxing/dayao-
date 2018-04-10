//
//  selectPeopleView.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/4/9.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "selectPeopleView.h"

@interface selectPeopleView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;

@end
@implementation selectPeopleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)addContentView{
    UILabel * t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    t.textAlignment = NSTextAlignmentCenter;
    t.text = @"人员所在";
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
