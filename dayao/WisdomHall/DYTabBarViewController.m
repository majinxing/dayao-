//
//  DYTabBarViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/24.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "DYTabBarViewController.h"
#import "SignInViewController.h"
#import "MeetingViewController.h"
#import "PersonalCenterViewController.h"
#import "AllTheMeetingViewController.h"
#import "DYHeader.h"
@interface DYTabBarViewController ()

@end

@implementation DYTabBarViewController
/**
 *  单例初始化
 */
+(DYTabBarViewController *)sharedInstance{
    static DYTabBarViewController * sharedDYTabBarViewControllerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedDYTabBarViewControllerInstance = [[self alloc] init];
    });
    return sharedDYTabBarViewControllerInstance;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewControllerWithClassname:[SignInViewController description] imagename:@"qiandaoIcon" title:@"签到" withSelectImageName:@"qiandaoIcon"];
    
    [self addChildViewControllerWithClassname:[AllTheMeetingViewController description] imagename:@"hudongIcon" title:@"会场" withSelectImageName:@"hudongIcon"];
    
    [self addChildViewControllerWithClassname:[PersonalCenterViewController description] imagename:@"yonghuIcon" title:@"我" withSelectImageName:@"yonghuIcon"];
    [self selectApp];
    // Do any additional setup after loading the view from its nib.
}
-(void)selectApp{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"2",@"type", nil];
    [[NetworkRequest sharedInstance] GET:QueryApp dict:dict succeed:^(id data) {
        NSLog(@"%@",data);
//        UIAlertView * later = [[UIAlertView alloc] initWithTitle:nil message:@"请更新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [later show];
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  添加子控制器
 *
 *  @param classname 类名字
 *  @param imagename tabbar图片名字
 *  @param title     tabbar文字
 */
- (void)addChildViewControllerWithClassname:(NSString *)classname
                                  imagename:(NSString *)imagename
                                      title:(NSString *)title withSelectImageName:(NSString *)selectName{
    //通过名字获取到类方法
    UIViewController *vc = [[NSClassFromString(classname) alloc] init];
    //设置导航
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    //tabbar 显示文字
    nav.tabBarItem.title = title;
    //tabbar 普通状态下图片(图片保持原尺寸)
    nav.tabBarItem.image = [[UIImage imageNamed:imagename]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //tabbar 选择状态下图片
    nav.tabBarItem.selectedImage =[UIImage imageNamed:selectName];// [[UIImage imageNamed:[selectName stringByAppendingString:@"_press"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置字体颜色（选中类型）
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#01aeff"]} forState:UIControlStateSelected];
    //设置字体颜色（普通类型）
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [self addChildViewController:nav];
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
