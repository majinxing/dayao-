//
//  DefineThePasswordViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/26.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "DefineThePasswordViewController.h"
#import "DYTabBarViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "DYHeader.h"
@interface DefineThePasswordViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *uploadImageButton;

@end

@implementation DefineThePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (IBAction)completeButtonPressed:(id)sender {
    DYTabBarViewController *rootVC = [[DYTabBarViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
}
- (IBAction)fingerprintEntryButtonPressed:(id)sender {
    //1. 判断系统版本
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        
        //2. LAContext : 本地验证对象上下文
        LAContext *context = [LAContext new];
        
        //3. 判断是否可用
        //Evaluate: 评估  Policy: 策略,方针
        //LAPolicyDeviceOwnerAuthenticationWithBiometrics: 允许设备拥有者使用生物识别技术
        if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
            NSLog(@"对不起, 指纹识别技术暂时不可用");
        }else{
            
            //4. 开始使用指纹识别
            //localizedReason: 指纹识别出现时的提示文字, 一般填写为什么使用指纹识别
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"开启了指纹识别, 将打开隐藏功能" reply:^(BOOL success, NSError * _Nullable error) {
                
                if (success) {
                    NSLog(@"指纹识别成功");
                    // 指纹识别成功，回主线程更新UI,弹出提示框
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"指纹识别成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alertView show];
                    });
                    
                }
                
                if (error) {
                    
                    // 错误的判断chuli
                    
                    if (error.code == -2) {
                        NSLog(@"用户取消了操作");
                        
                        // 取消操作，回主线程更新UI,弹出提示框
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户取消了操作" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                            [alertView show];
                            
                        });
                        
                    } else {
                        NSLog(@"错误: %@",error);
                        // 指纹识别出现错误，回主线程更新UI,弹出提示框
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alertView show];
                    }
                    
                }
                
            }];
        }
        
    } else {
        
        NSLog(@"对不起, 该手机不支持指纹识别");
        
    }
    
}
- (IBAction)uploadThePictureButtonPressed:(id)sender {
    
    
    //  NSLog(@"%s",__func__);
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        AVAuthorizationStatus author = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied)
        {
            //[self showLibraryOrCameraAuthorAlert:@"相机"];
        }
        else
        {
            //[self showLibraryOrCamera:UIImagePickerControllerSourceTypeCamera];
        }        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        //imagePicker.allowsEditing = YES;
        imagePicker.showsCameraControls = YES;
        imagePicker.delegate = self;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            //正面  这里是正面
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            //后面 这里是反面
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }
        
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"您的设备没有相机功能"
                                  message:nil
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"我知道了", nil];
        [alertView show];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    if ([self.sign isEqualToString:@"1"]) {
    //        UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    //        //_headImage.image = image;
    //    }//相机拍照 de
    //    else if([self.sign isEqualToString:@"0"]){
    UIImage *image=info[@"UIImagePickerControllerOriginalImage"];
    [_uploadImageButton setBackgroundImage:image forState:UIControlStateNormal];
    [_uploadImageButton setTitle:@"" forState:UIControlStateNormal];
    // _headImage.image = image;
    //    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    
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
