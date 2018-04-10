//
//  CreateVoteViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/2.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CreateVoteViewController.h"
#import "DYHeader.h"
#import "CreateVoteTableViewCell.h"
#import "VoteModel.h"
#import "EditerTextViewController.h"


@interface CreateVoteViewController ()<UITableViewDataSource,UITableViewDelegate,CreateVoteTableViewCellDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)VoteModel * voteModel;
@property (nonatomic,strong)NSMutableArray * labeAry;
@property (nonatomic,assign)int rowNumber;//cell的显示行数
@property (nonatomic,assign)int temp;
@end

@implementation CreateVoteViewController

-(void)dealloc{
    NSLog(@"%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationTitle];
    
    [self addTableView];
    
    [self addInfo];
    
    [self keyboardNotification];
    // Do any additional setup after loading the view from its nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"投票";
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(saveVote)];
    [myButton setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = myButton;
    
}

-(void)saveVote{
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    if ([_type isEqualToString:@"meeting"]) {
        NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];
        
        for (int i = 0; i<_voteModel.selectAry.count; i++) {
            
            if (![UIUtils isBlankString:_voteModel.selectAry[i]]) {
                [ary addObject:_voteModel.selectAry[i]];
                
            }
        }
        if (ary.count>0) {
            
        }else{
            [UIUtils showInfoMessage:@"投票选项不能为空" withVC:self];
            [self hideHud];
            return;
        }
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_voteModel.title,@"title",_voteModel.largestNumbe,@"type",ary,@"contentList",_meetModel.meetingId,@"relId",@"2",@"relType",nil];
        
        [[NetworkRequest sharedInstance] POST:CreateVote dict:dict succeed:^(id data) {
            NSString *str = [[data objectForKey:@"header"] objectForKey:@"message"];
            if ([str isEqualToString:@"成功"]) {
                [UIUtils showInfoMessage:@"创建成功" withVC:self];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [UIUtils showInfoMessage:@"创建失败" withVC:self];
                
            }
            [self hideHud];
            NSLog(@"%@",data);
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"创建失败" withVC:self];
            
            [self hideHud];
            NSLog(@"%@",error);
        }];
        
    }else{
        NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];
        for (int i = 0; i<_voteModel.selectAry.count; i++) {
            if (![UIUtils isBlankString:_voteModel.selectAry[i]]) {
                [ary addObject:_voteModel.selectAry[i]];
            }
        }
        if (ary.count>0) {
            
        }else{
            [UIUtils showInfoMessage:@"投票选项不能为空" withVC:self];
            
            [self hideHud];
            return;
        }
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_voteModel.title,@"title",_voteModel.largestNumbe,@"type",ary,@"contentList",_classModel.sclassId,@"relId",@"1",@"relType",nil];
        
        [[NetworkRequest sharedInstance] POST:CreateVote dict:dict succeed:^(id data) {
            NSString *str = [[data objectForKey:@"header"] objectForKey:@"message"];
            if ([str isEqualToString:@"成功"]) {
                [UIUtils showInfoMessage:@"创建成功" withVC:self];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [UIUtils showInfoMessage:@"创建失败" withVC:self];
                
            }
            [self hideHud];
            NSLog(@"%@",data);
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"创建失败" withVC:self];
            
            [self hideHud];
            NSLog(@"%@",error);
        }];
        
    }
    
}
/**
 * 键盘监听
 **/
-(void)keyboardNotification{
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)addInfo{
    _voteModel = [[VoteModel alloc] init];
    
    _voteModel.selectAry = [NSMutableArray arrayWithCapacity:6];
    
    for (int i = 0; i<4; i++) {
        [_voteModel.selectAry addObject:@""];
    }
    
    _labeAry = [NSMutableArray arrayWithCapacity:4];
    
    [_labeAry addObject:@"请输入投票主题"];
    
    [_labeAry addObject:@"请输入描述"];
    
    _rowNumber = 7;
}

-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 60;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.tableView.contentInset = UIEdgeInsetsZero;
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_rowNumber>0) {
        return _rowNumber;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreateVoteTableViewCell * cell;
    if (indexPath.row == 1) {
        cell = [_tableView dequeueReusableCellWithIdentifier:@"CreateVoteTableViewCellSecond"];
    }else if(indexPath.row == 0){
        cell = [_tableView dequeueReusableCellWithIdentifier:@"CreateVoteTableViewCellFirst"];
    }else if (indexPath.row >1&&(indexPath.row<(_rowNumber-1))){
        cell = [_tableView dequeueReusableCellWithIdentifier:@"CreateVoteTableViewCellThird"];
    } else if (indexPath.row==_rowNumber-1){
        cell = [_tableView dequeueReusableCellWithIdentifier:@"CreateVoteTableViewCellFourth"];
    }
    
    if (!cell) {
        if (indexPath.row == 1) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CreateVoteTableViewCell" owner:nil options:nil] objectAtIndex:1];
        }else if(indexPath.row == 0){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CreateVoteTableViewCell" owner:nil options:nil] objectAtIndex:0];
        }else if (indexPath.row>1&&(indexPath.row<(_rowNumber-1))){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CreateVoteTableViewCell" owner:nil options:nil] objectAtIndex:2];
        }
        else if (indexPath.row==_rowNumber-1){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CreateVoteTableViewCell" owner:nil options:nil] objectAtIndex:3];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        [cell addTableTextWithTextFile:_labeAry[indexPath.row] with:_voteModel.title withTag:(int)indexPath.row];
    }else if (indexPath.row == 1){
        [cell addSelectNumeberWithNumer:_voteModel.largestNumbe withTag:(int)indexPath.row];
    }else if (indexPath.row>1&&(indexPath.row<(_rowNumber-1))){
        [cell addSelectInfo:[NSString stringWithFormat:@"选项%ld：",indexPath.row-1] withSelectText:_voteModel.selectAry[indexPath.row-2] withTag:(int)indexPath.row];
    }else if (indexPath.row==_rowNumber-1){
        
    }
    cell.delegate = self;
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (![UIUtils isBlankString:_voteModel.title]) {
            float  h = [self heightForString:_voteModel.title andWidth:APPLICATION_WIDTH-20];
            if (h>150) {
                return h;
            }
        }
        return 150;
    }else if (indexPath.row>1&&(indexPath.row<(_rowNumber-1))) {
        if (![UIUtils isBlankString:_voteModel.selectAry[indexPath.row-2]]) {
            float  h = [self heightForString:_voteModel.selectAry[indexPath.row-2] andWidth:APPLICATION_WIDTH-103];
            if (h>50) {
                return h;
            }
        }
    }
    
    return 50;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (float)heightForString:(NSString *)value andWidth:(float)width{
    
    UITextView * textView = [[UITextView alloc] init];
    
    //获取当前文本的属性
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value];
    
    textView.attributedText = attrStr;
    
    NSRange range = NSMakeRange(0, attrStr.length);
    
    // 获取该段attributedString的属性字典
    
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width - 16.0, 900)
                        // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} // 文字的属性
                                           context:nil].size;
    // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    
    return sizeToFit.height + 49.0;
    
}


#pragma mark textFileTextChangeDelegate
-(void)addSelectNumberDelegate:(UIButton *)sender{
    _rowNumber = _rowNumber + 1;
    [_voteModel.selectAry addObject:@""];
    [_tableView reloadData];
}
-(void)delectSelectNumberDelegate:(UIButton *)sender{
    if ((sender.tag-3)<_voteModel.selectAry.count) {
        [_voteModel.selectAry removeObjectAtIndex:sender.tag-3];
        _rowNumber = _rowNumber - 1;
        [_tableView reloadData];
    }
}
-(void)textViewBeginChangeDelegate:(UITextView *)textView{
    
    EditerTextViewController * vc = [[EditerTextViewController alloc] initWithText:^(NSString *text) {
        if (textView.tag == 111) {
            _voteModel.title = text;
        }else if (textView.tag>1){
            if (![UIUtils isBlankString:text]) {
                if ((textView.tag-3)<_voteModel.selectAry.count) {
                    [_voteModel.selectAry setObject:text atIndexedSubscript:textView.tag-3];
                }
            }
        }
        
        [_tableView reloadData];
    }];
    if (textView.tag == 111) {
        vc.textStr = _voteModel.title;
    }else{
        if ((textView.tag-3)<_voteModel.selectAry.count) {
            vc.textStr = _voteModel.selectAry[textView.tag-3];
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.view endEditing:YES];
}
//投票数目
-(void)textFieldDidChangeDelegate:(UITextField *)textFile{
    _voteModel.largestNumbe = textFile.text;
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
