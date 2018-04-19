//
//  LoginApiManager.m
//  ABNetwork
//
//  Created by Abe on 16/1/3.
//  Copyright © 2016年 AbeHui. All rights reserved.
//

#import "LoginApiManager.h"

@implementation LoginApiManager

/// 请求成功的回调
- (void)requestCompleteFilter {
    
}

/// 请求失败的回调
- (void)requestFailedFilter {
    
}

/// 请求的URL√
- (NSString *)requestUrl {
    return @"/youqu/login.htm";
}

/// 请求的CdnURL√
- (NSString *)cdnUrl {
    return @"";
}

/// 请求的BaseURL√
- (NSString *)baseUrl {
    return @"http://114.215.182.172:8080";
}

/// 请求的连接超时时间，默认为60秒√
- (NSTimeInterval)requestTimeoutInterval {
    return 10;
}

/// 请求的参数列表
- (id)requestArgument {
    return @{@"loginId":@"e37cb4d15aa0881a7befed558c096cdde344bcf650e139fd",
             @"password":@"0f490ae3b18d3a10"};
}

/// 用于在cache结果，计算cache文件名时，忽略掉一些指定的参数
- (id)cacheFileNameFilterForRequestArgument:(id)argument {
    return @"";
}

/// Http请求的方法√
- (ABRequestMethod)requestMethod {
    return ABRequestMethodPost;
}

/// 请求的SerializerType√
- (ABRequestSerializerType)requestSerializerType {
    return ABRequestSerializerTypeHTTP;
}

/// 请求的Server用户名和密码x
- (NSArray *)requestAuthorizationHeaderFieldArray {
    return nil;
}

/// 在HTTP报头添加的自定义参数x
- (NSDictionary *)requestHeaderFieldValueDictionary {
    return nil;
}

/// 构建自定义的UrlRequest，x
/// 若这个方法返回非nil对象，会忽略requestUrl, requestArgument, requestMethod, requestSerializerType
- (NSURLRequest *)buildCustomUrlRequest {
    return nil;
}

/// 是否使用CDN的host地址√
- (BOOL)useCDN {
    return NO;
}

/// 用于检查JSON是否合法的对象
- (id)jsonValidator {
    return nil;
}

/// 用于检查Status Code是否正常的方法
- (BOOL)statusCodeValidator {
    return NO;
}

/// 当POST的内容带有文件等富文本时使用√
- (AFConstructingBlock)constructingBodyBlock {
    return nil;
}

/// 当需要断点续传时，指定续传的地址
- (NSString *)resumableDownloadPath {
    return nil;
}


/// 当需要断点续传时，获得下载进度的回调
- (AFDownloadProgressBlock)resumableDownloadProgressBlock {
    return nil;
}
@end
