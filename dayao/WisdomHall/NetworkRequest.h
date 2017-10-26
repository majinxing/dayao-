//
//  NetworkRequest.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/29.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#import "AFNetworking/AFNetworking.h"

@interface NetworkRequest : AFHTTPSessionManager
+ (instancetype)sharedInstance;
- (void)POST:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;
- (void)GET:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;
@end
