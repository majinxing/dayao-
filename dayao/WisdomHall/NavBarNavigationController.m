//
//  NavBarNavigationController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/14.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "NavBarNavigationController.h"
#import "DYHeader.h"



@interface NavBarNavigationController ()
//@property (nonatomic,strong)NSTimer *showTimer;
@property (nonatomic,strong)NSDictionary * dict;
@end

@implementation NavBarNavigationController
+(NavBarNavigationController *)sharedInstance{
    static dispatch_once_t predicate;
    
    static NavBarNavigationController * sharedDYTabBarViewControllerInstance = nil;
    dispatch_once(&predicate, ^{
        sharedDYTabBarViewControllerInstance = [[self alloc] init];
    });
    return sharedDYTabBarViewControllerInstance;
}
-(void)setColor{
    self.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.tintColor = [UIColor blackColor];
    
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(setColor)
     name:ThemeColorChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(inApp)
     name:InApp object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(outApp)
     name:OutApp object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(stopTime)
     name:@"stopTime" object:nil];
//    NSDictionary * dict = [NSDictionary alloc] initWithObjectsAndKeys:<#(nonnull id), ...#>, nil;
}
-(void)stopTime{
    
    [[NavBarNavigationController sharedInstance].showTimer invalidate];
    [NavBarNavigationController sharedInstance].showTimer = nil;

}
-(void)inApp{
    //时间间隔
    NSTimeInterval timeInterval = 3*60 ;
    
    //定时器
    [NavBarNavigationController sharedInstance].showTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                  target:self
                                                selector:@selector(handleMaxShowTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    [[NavBarNavigationController sharedInstance].showTimer fire];
}
-(void)handleMaxShowTimer:(NSTimer *)theTimer{
   
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    if (![UIUtils isBlankString:user.peopleId]) {
        NSDictionary * dict = @{@"appState":@"1",@"id":[NSString stringWithFormat:@"%@",user.peopleId]};
        [[NetworkRequest sharedInstance] POST:ChangeAppState dict:dict succeed:^(id data) {
//            NSLog(@"%@",data);
        } failure:^(NSError *error) {
            
        }];
    }
}
-(void)outApp{
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    [[NavBarNavigationController sharedInstance].showTimer invalidate];
    
    [NavBarNavigationController sharedInstance].showTimer = nil;

    if (![UIUtils isBlankString:user.peopleId]) {
        NSDictionary * dict = @{@"appState":@"3",@"id":[NSString stringWithFormat:@"%@",user.peopleId]};
        [[NetworkRequest sharedInstance] POST:ChangeAppState dict:dict succeed:^(id data) {
//            NSLog(@"%@",data);
        } failure:^(NSError *error) {
            
        }];
    }
}
@end
