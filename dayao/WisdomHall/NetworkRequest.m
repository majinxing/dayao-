//
//  NetworkRequest.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/29.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "NetworkRequest.h"
#import "DYHeader.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
@implementation NetworkRequest
+(instancetype)sharedInstance{
    static NetworkRequest *tools;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // baseURL 的目的，就是让后续的网络访问直接使用 相对路径即可，baseURL 的路径一定要有 / 结尾
        NSURL *baseURL = [NSURL URLWithString:BaseURL];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        tools = [[self alloc] initWithBaseURL:baseURL sessionConfiguration:config];
        
        // 修改 解析数据格式 能够接受的内容类型 － 官方推荐的做法，民间做法：直接修改 AFN 的源代码
        tools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                           @"text/json",
                                                           @"text/javascript",
                                                           @"text/html",
                                                           @"application/xml",
                                                           nil];
    });
    return tools;
}

-(void)afnetwroingPostWithUrl:(NSString *)url withDict:(NSDictionary *)dict{
    NSString * str = [NSString stringWithFormat:@"%@%@",BaseURL,url];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager POST:str parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"success--%@--%@",[responseObject class],responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"failure--%@",error);
    }];
}

//-(void)post{
//    NSURL * url = [NSURL URLWithString:@"http://192.168.1.114:8080/course/user/login"];
//    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
//    //配置请求超时
//    [request setTimeoutInterval:10.0];
//    //配置请求方法
//    [request setHTTPMethod:@"POST"];
//    //设置头部参数
//    [request addValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
//    // 4、构造请求参数
//    // 4.1、创建字典参数，将参数放入字典中，可防止程序员在主观意识上犯错误，即参数写错。
//    NSDictionary *parametersDict = @{@"phone":@"15243670131",@"password":@"123456"};
//    // 4.2、遍历字典，以“key=value&”的方式创建参数字符串。
//    NSMutableString *parameterString = [[NSMutableString alloc]init];
//    int pos =0;
//    for (NSString *key in parametersDict.allKeys) {
//        // 拼接字符串
//        [parameterString appendFormat:@"%@=%@", key, parametersDict[key]];
//        if(pos<parametersDict.allKeys.count-1){
//            [parameterString appendString:@"&"];
//        }
//        pos++;
//    }
//    // 4.3、NSString转成NSData数据类型。
//    NSData *parametersData = [parameterString dataUsingEncoding:NSUTF8StringEncoding];
//    // 5、设置请求报文
//    [request setHTTPBody:parametersData];
//    // 6、构造NSURLSessionConfiguration
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    // 7、创建网络会话
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
//    // 8、创建会话任务
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        // 10、判断是否请求成功
//        if (error) {
//            NSLog(@"post error :%@",error.localizedDescription);
//        }else {
//            // 如果请求成功，则解析数据。
//            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//            // 11、判断是否解析成功
//            if (error) {
//                NSLog(@"post error :%@",error.localizedDescription);
//            }else {
//                // 解析成功，处理数据，通过GCD获取主队列，在主线程中刷新界面。
//                NSLog(@"post success :%@",object);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // 刷新界面...
//                });
//            }
//        }
//        
//    }];
//    // 9、执行任务
//    [task resume];
//}

@end
