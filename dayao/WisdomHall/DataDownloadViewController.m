//
//  DataDownloadViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/21.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "DataDownloadViewController.h"
#import "DataDownloadTableViewCell.h"
#import "DYHeader.h"

@interface DataDownloadViewController ()<UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate>
@property (nonatomic,strong)UITableView * tableView;

@end

@implementation DataDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self a];
    [self addTableView];
    // Do any additional setup after loading the view from its nib.
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
-(void)a{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths lastObject];
    
    NSLog(@"app_home_doc: %@",documentsDirectory);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"1"]; //docPath为文件名
    if ([fileManager fileExistsAtPath:filePath]) {
    
    }else{
    
    }
}
/** 打开文件 @param filePath 文件路径 */
-(void)openDocxWithPath:(NSString *)filePath {
    
    UIDocumentInteractionController *doc= [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    
    doc.delegate = self;
    
    [doc presentPreviewAnimated:YES];

}
/** 下载文件 @param docPath 文件路径 @param fileName 文件名 */
-(void)downloadDocxWithDocPath:(NSString *)docPath fileName:(NSString *)fileName {
    //[MBProgressHUD showMessage:@"正在下载文件" toView:self.view];
    
    NSString *urlString = @"http://66.6.66.111:8888/UploadFile/";
    
    urlString = [urlString stringByAppendingString:fileName];
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"%lld %lld",downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *path = [docPath stringByAppendingPathComponent:fileName];
        
        NSLog(@"文件路径＝＝＝%@",path);
        
        return [NSURL fileURLWithPath:path];
        //这里返回的是文件下载到哪里的路径 要注意的是必须是携带协议file://
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        [MBProgressHUD hideHUDForView:self.view];
//        [MBProgressHUD showSuccess:@"下载完成,正在打开" toView:self.view];
        // if (error) { // // }else {
        NSString *name = [filePath path];
        
        NSLog(@"下载完成文件路径＝＝＝%@",name);
        
        [self openDocxWithPath:name];
        
        // }
    }];
    [task resume];
    
    //开始下载 要不然不会进行下载的
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIDocumentInteractionControllerDelegate
//必须实现的代理方法 预览窗口以模式窗口的形式显示，因此需要在该方法中返回一个view controller ，作为预览窗口的父窗口。如果你不实现该方法，或者在该方法中返回 nil，或者你返回的 view controller 无法呈现模式窗口，则该预览窗口不会显示。

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    
    return self;
    
}
- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
    
    return self.view;
    
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    
    return CGRectMake(0, 30, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    
}


#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DataDownloadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DataDownloadTableViewCellFirst"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DataDownloadTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
