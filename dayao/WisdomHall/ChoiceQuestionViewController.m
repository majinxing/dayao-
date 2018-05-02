//
//  ChoiceQuestionViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "ChoiceQuestionViewController.h"
#import "DYHeader.h"
#import "ChoiceQuestionTableViewCell.h"


@interface ChoiceQuestionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation ChoiceQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setQuestionModel];
    [self addTableView];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)setQuestionModel{
    _questionModel = [[QuestionModel alloc] init];
    
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, APPLICATION_WIDTH, APPLICATION_HEIGHT-104) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return _questionModel.qustionOptionsAry.count+1;
    }else if (section ==3){
        return 2;
    }
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChoiceQuestionTableViewCell * cell;
    
    if (!cell) {
        if (indexPath.section == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellFirst"];

            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:0];
            
        }else if (indexPath.section == 1){
            
                cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellSecond"];
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:1];
            
            
        }else if (indexPath.section == 2){
            if (indexPath.row==_questionModel.qustionOptionsAry.count) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellFifth"];
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:4];
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellThird"];
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:2];
            }
            
        }else if (indexPath.section == 3){
            if (indexPath.row ==1) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellSixth"];
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:5];
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellFourth"];
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:3];
            }

        }
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 450;
    }else if (indexPath.section == 1){
        return 90;
    }else if (indexPath.section == 2){
        if (indexPath.row == _questionModel.qustionOptionsAry.count) {
            return 60;
        }
        return 300;
    }
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * ary = @[@"题目内容",@"选择分值与难易程度",@"选项",@"参考答案"];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, 30)];
    view.backgroundColor = RGBA_COLOR(236, 236, 236, 1);
    UILabel * l = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
    l.font = [UIFont systemFontOfSize:15];
    
    [view addSubview:l];
    
    l.text = ary[(int)section];
    return view;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
