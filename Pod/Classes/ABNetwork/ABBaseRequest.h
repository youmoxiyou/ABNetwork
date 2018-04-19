//
//  ABBaseRequest.h
//  Pods
//
//  Created by Abe on 15/12/29.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSUInteger, ABRequestMethod) {
    ABRequestMethodGet = 0,
    ABRequestMethodPost,
    ABRequestMethodHead,
    ABRequestMethodPut,
    ABRequestMethodDelete,
    ABRequestMethodPatch,
};

typedef NS_ENUM(NSUInteger, ABResponseSerializerType) {
    ABResponseSerializerTypeHTTP = 0,
    ABResponseSerializerTypeJSON,
};

typedef NS_ENUM(NSUInteger, ABRequestSerializerType) {
    ABRequestSerializerTypeHTTP = 0,
    ABRequestSerializerTypeJSON,
};

typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formDate);
typedef void(^AFDownloadProgressBlock)(NSProgress *downloadProgress);

@class  ABBaseRequest;

@protocol ABRequestDelegate <NSObject>

@optional

- (void)requestFinished:(ABBaseRequest *)request;
- (void)requestFailed:(ABBaseRequest *)request;
- (void)clearRequest;

@end

@protocol ABRequestAccessory <NSObject>

@optional

- (void)requestWillStart:(id)request;
- (void)requestWillStop:(id)request;
- (void)requestDidStop:(id)request;

@end

@protocol ABRequestImplement <NSObject>

@required
/// 请求成功的回调
- (void)requestCompleteFilter;

/// 请求失败的回调
- (void)requestFailedFilter;

/// 请求的URL√
- (NSString *)requestUrl;

/// 请求的CdnURL√
- (NSString *)cdnUrl;

/// 请求的BaseURL√
- (NSString *)baseUrl;

/// 请求的连接超时时间，默认为60秒√
- (NSTimeInterval)requestTimeoutInterval;

/// 请求的参数列表
- (id)requestArgument;

/// 用于在cache结果，计算cache文件名时，忽略掉一些指定的参数
- (id)cacheFileNameFilterForRequestArgument:(id)argument;

/// Http请求的方法√
- (ABRequestMethod)requestMethod;

- (ABResponseSerializerType)responseSerializerType;
/// 请求的SerializerType√
- (ABRequestSerializerType)requestSerializerType;

/// 请求的Server用户名和密码x
- (NSArray *)requestAuthorizationHeaderFieldArray;

/// 在HTTP报头添加的自定义参数x
- (NSDictionary *)requestHeaderFieldValueDictionary;

/// 构建自定义的UrlRequest，x
/// 若这个方法返回非nil对象，会忽略requestUrl, requestArgument, requestMethod, requestSerializerType
- (NSURLRequest *)buildCustomUrlRequest;

/// 是否使用CDN的host地址√
- (BOOL)useCDN;

/// 用于检查JSON是否合法的对象
- (id)jsonValidator;

/// 用于检查Status Code是否正常的方法
- (BOOL)statusCodeValidator;

/// 当POST的内容带有文件等富文本时使用√
- (AFConstructingBlock)constructingBodyBlock;

/// 当需要断点续传时，指定续传的地址
- (NSString *)resumableDownloadPath;


/// 当需要断点续传时，获得下载进度的回调
- (AFDownloadProgressBlock)resumableDownloadProgressBlock;


@optional

@end

@interface ABBaseRequest : NSObject

/// Tag
@property (nonatomic) NSInteger tag;

/// User info
@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, strong) NSURLSessionTask *sessionTask;

/// request child object
@property (nonatomic, weak) id<ABRequestImplement> child;
/// request delegate object
@property (nonatomic, weak) id<ABRequestDelegate> delegate;


@property (nonatomic, strong, readonly) NSString *responseString;

@property (nonatomic, strong, readonly) id responseJSONObject;

@property (nonatomic, copy) void (^successCompletionBlock)(ABBaseRequest *);

@property (nonatomic, copy) void (^failureCompletionBlock)(ABBaseRequest *);

/// 生命周期辅助
@property (nonatomic, strong) NSMutableArray *requestAccessories;

/// append self to request queue
- (void)start;

/// remove self from request queue
- (void)stop;

- (BOOL)isExecuting;

/// block回调
- (void)startWithCompletionBlockWithSuccess:(void (^)(ABBaseRequest *request))success
                                    failure:(void (^)(ABBaseRequest *request))failure;

- (void)setCompletionBlockWithSuccess:(void (^)(ABBaseRequest *request))success
                              failure:(void (^)(ABBaseRequest *request))failure;

/// 把block置nil来打破循环引用
- (void)clearCompletionBlock;

/// Request Accessory，可以hook Ruquest的start和stop
- (void)addAccessory:(id<ABRequestAccessory>)accessory;
@end
