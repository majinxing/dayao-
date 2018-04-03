//
//  EditerTextViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/4/3.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "EditerTextViewController.h"
#import "DYHeader.h"

@interface EditerTextViewController ()
@property (nonatomic,copy) void(^textBlock)(NSString *);
@end

@implementation EditerTextViewController

-(instancetype)initWithText:(void (^)(NSString *))textBlock{
    self = [super init];
    if (self) {
        self.textBlock = textBlock;
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationTitle];
    
    [self addContentView];
    // Do any additional setup after loading the view from its nib.
}
-(void)addContentView{
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, APPLICATION_WIDTH-20, APPLICATION_HEIGHT/2-80)];
    
    [_textView becomeFirstResponder];
    
    _textView.font = [UIFont systemFontOfSize:14];
    
    _textView.text = _textStr;
    
    [self.view addSubview:_textView];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"编辑";
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveText)];
    [myButton setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = myButton;
   
}
-(void)saveText{
    if (![UIUtils isBlankString:_textView.text]) {
        self.textBlock(_textView.text);
    }
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
