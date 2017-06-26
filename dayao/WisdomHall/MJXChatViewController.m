//
//  MJXChatViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/17.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "MJXChatViewController.h"
#import "MJXChatCellTableViewCell.h"
#import "DYHeader.h"

#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define  MaxTextViewHeight 80 //限制文字输入的高度

@interface MJXChatViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIScrollViewDelegate>
{
    BOOL statusTextView;//当文字大于限定高度之后的状态
    NSString *placeholderText;//设置占位符的文字
}
@property (strong, nonatomic)UIView *btoView;

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,assign)CGFloat keyH;

@property (nonatomic,strong) UITextView * textView;

@property (nonatomic,strong) UIButton * sendVoice;

@property (nonatomic,assign)CGRect rect;

@end

@implementation MJXChatViewController

-(void)dealloc{
//        NSLog(@"%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBA_COLOR(241, 241, 241, 1);
    
    [self setNavigationTitle];
    
    [self keyboardNotification];
    
    [self addTableView];
    
    // Do any additional setup after loading the view from its nib.
}
/**
 * 键盘监听
 **/
-(void)keyboardNotification{
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //[self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"聊天室";
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(createAcourse)];
    self.navigationItem.rightBarButtonItem = myButton;
}
-(void)addTableView{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGBA_COLOR(241, 241, 241, 1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    _btoView = [[UIView alloc] initWithFrame:CGRectMake(0, APPLICATION_HEIGHT-40, APPLICATION_WIDTH, 40)];
    _btoView.backgroundColor =
    _tableView.backgroundColor = RGBA_COLOR(241, 241, 241, 1);
    _btoView.layer.masksToBounds = YES;
    _btoView.layer.borderWidth = 1.f;
    _btoView.layer.borderColor = RGBA_COLOR(214, 214, 214, 1).CGColor;
    [self.view addSubview:_btoView];
    
    UIButton * voice = [UIButton buttonWithType:UIButtonTypeCustom];
    voice.frame = CGRectMake(2.5, 0, 40, 40);
    [voice setImage:[UIImage imageNamed:@"chat_bar_voice_normal"] forState:UIControlStateNormal];
    [voice addTarget:self action:@selector(sendVoice:) forControlEvents:UIControlEventTouchUpInside];
    [_btoView addSubview:voice];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(45, 2, APPLICATION_WIDTH-45-80, 34)];
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.delegate = self;
    [_btoView addSubview:_textView];
    
    UIButton * expression = [UIButton buttonWithType:UIButtonTypeCustom];
    expression.frame = CGRectMake(CGRectGetMaxX(_textView .frame), 0, 40, 40);
    [expression setImage:[UIImage imageNamed:@"chat_bar_face_normal"] forState:UIControlStateNormal];
    
    [_btoView addSubview:expression];
    
    UIButton * more = [UIButton buttonWithType:UIButtonTypeCustom];
    more.frame = CGRectMake(CGRectGetMaxX(expression.frame), 0, 40, 40);
    [more setImage:[UIImage imageNamed:@"chat_bar_more_normal"] forState:UIControlStateNormal];
    [_btoView addSubview:more];
    
    _sendVoice = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendVoice.frame = CGRectMake(0, 0, 0, 0);
    _sendVoice.backgroundColor = RGBA_COLOR(241, 241, 241, 1);;
    [_sendVoice setTitle:@"按住说话" forState:UIControlStateNormal];
    
    _sendVoice.layer.masksToBounds = YES;
    _sendVoice.layer.borderWidth = 1;
    _sendVoice.layer.borderColor = RGBA_COLOR(214, 214, 214, 1).CGColor;
    [_sendVoice setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btoView addSubview:_sendVoice];
}
-(void)sendVoice:(UIButton *)btn{
    if (_sendVoice.frame.size.height == 0) {
        _rect = _btoView.frame;
        _btoView.frame = CGRectMake(0, APPLICATION_HEIGHT-40, APPLICATION_WIDTH, 40);
        _sendVoice.frame = CGRectMake(45, 2, APPLICATION_WIDTH-45-80, 34);
        [btn setImage:[UIImage imageNamed:@"chat_bar_input_normal"] forState:UIControlStateNormal];

        [self.view endEditing:YES];
    }else{
        _sendVoice.frame = CGRectMake(0, 0, 0, 0);
        _btoView.frame = _rect;
        [btn setImage:[UIImage imageNamed:@"chat_bar_voice_normal"] forState:UIControlStateNormal];
        [_textView becomeFirstResponder];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20.;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXChatCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MJXChatCellTableViewCellFirst"];
    if (!cell) {
//        MJXChatCellTableViewCellFirst
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MJXChatCellTableViewCell" owner:nil options:nil] objectAtIndex:1];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing: YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
    CGRect rect = _btoView.frame;
    _btoView.frame = CGRectMake(0, APPLICATION_HEIGHT-rect.size.height-keyBoardRect.size.height, APPLICATION_WIDTH, rect.size.height);
    _keyH = keyBoardRect.size.height;
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.tableView.contentInset = UIEdgeInsetsZero;
    //    _btoView.frame = CGRectMake(0, APPLICATION_HEIGHT-40, APPLICATION_WIDTH, 40);
    CGRect rect = _btoView.frame;
    _btoView.frame = CGRectMake(0, APPLICATION_HEIGHT-rect.size.height, APPLICATION_WIDTH, rect.size.height);
    _keyH = 0;
}
- (void)textViewDidChange:(UITextView *)textView{
    //---- 计算高度 ---- //
    CGSize size = CGSizeMake( APPLICATION_WIDTH-45-80, CGFLOAT_MAX);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil];
    CGFloat curheight = [textView.text boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:dic
                                                    context:nil].size.height;
    //    CGFloat y = CGRectGetMaxY(self.btoView.frame);
    if (curheight<19.093) {
        statusTextView = NO;
        _btoView.frame = CGRectMake(0, APPLICATION_HEIGHT-_keyH-40, APPLICATION_WIDTH, 40);
        _textView.frame = CGRectMake(45, 2, APPLICATION_WIDTH-45-80, 34);
    }else if (curheight<MaxTextViewHeight){
        statusTextView = NO;
        self.btoView.frame = CGRectMake(0, APPLICATION_HEIGHT-textView.contentSize.height-4-_keyH, APPLICATION_WIDTH, textView.contentSize.height+4);
        _textView.frame = CGRectMake(45, 2, APPLICATION_WIDTH-45-80, textView.contentSize.height);
        
    }else{
        statusTextView = YES;
    }
}
#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }else{
        if (statusTextView == NO) {
            scrollView.contentOffset = CGPointMake(0, 0);
        }else{
            
        }
    }
}
/*
 #pragma mark - Navigation3
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
