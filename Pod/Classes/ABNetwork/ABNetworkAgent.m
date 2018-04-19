//
//  ABNetworkAgent.m
//  Pods
//
//  Created by Abe on 15/12/29.
//
//

#import "ABNetworkAgent.h"
#import "ABNetworkConfig.h"
#import "ABNetworkPrivate.h"

@implementation ABNetworkAgent {
    AFHTTPSessionManager *_manager;
    ABNetworkConfig *_config;
    NSMutableDictionary *_requestsRecord;
}

+ (ABNetworkAgent *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        _config = [ABNetworkConfig sharedInstance];
        _requestsRecord = [NSMutableDictionary dictionary];
        _manager.operationQueue.maxConcurrentOperationCount = 4;
    }
    return self;
}

- (NSString *)buildRequestUrl:(ABBaseRequest<ABRequestImplement> *)request {
    NSString *detailUrl = [request requestUrl];
    if ([detailUrl hasPrefix:@"http"]) {
        return detailUrl;
    }
    // filter url
    NSArray *filters = [_config urlFilters];
    for (id<ABUrlFilterProtocol> f in filters) {
        detailUrl = [f filterUrl:detailUrl withRequest:request];
    }
    
    NSString *baseUrl;
    if ([request useCDN]) {
        if ([request cdnUrl].length > 0) {
            baseUrl = [request cdnUrl];
        }
        else {
            baseUrl = [_config cdnUrl];
        }
    }
    else {
        if ([request baseUrl].length > 0) {
            baseUrl = [request baseUrl];
        }
        else {
            baseUrl = [_config baseUrl];
        }
    }
    return [NSString stringWithFormat:@"%@%@", baseUrl, detailUrl];
}

- (void)addRequest:(ABBaseRequest<ABRequestImplement> *)request {
    ABRequestMethod method = [request requestMethod];
    NSString *url = [self buildRequestUrl:request];
    id param = request.requestArgument;
    AFConstructingBlock constructingBlock = [request constructingBodyBlock];

    if (request.responseSerializerType == ABResponseSerializerTypeHTTP) {
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    else if (request.responseSerializerType == ABResponseSerializerTypeJSON) {
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    if (request.requestSerializerType == ABRequestSerializerTypeHTTP) {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    else if (request.requestSerializerType == ABRequestSerializerTypeJSON) {
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    _manager.requestSerializer.timeoutInterval = [request requestTimeoutInterval];
    
    // if api need server username and password
    NSArray *authorizationHeaderFieldArray = [request requestAuthorizationHeaderFieldArray];
    if (authorizationHeaderFieldArray != nil) {
        [_manager.requestSerializer setAuthorizationHeaderFieldWithUsername:(NSString *)authorizationHeaderFieldArray.firstObject
                                                                   password:(NSString *)authorizationHeaderFieldArray.lastObject];
    }
    
    // if api need add custom value to HTTPHeaderField
    NSDictionary *headerFieldValueDictionary = [request requestHeaderFieldValueDictionary];
    if (headerFieldValueDictionary != nil) {
        for (id httpHeaderField in headerFieldValueDictionary.allKeys) {
            id value = headerFieldValueDictionary[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                [_manager.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
            }
            else {
                ABLog(@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
            }
        }
    }
    
    // if api build custom url request
    NSURLRequest *customUrlRequest = [request buildCustomUrlRequest];
    if (customUrlRequest) {
        NSURLSessionDataTask *dataTask = [_manager dataTaskWithRequest:customUrlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                
            }
        }];
        [dataTask resume];
    }
    else {
        if (method == ABRequestMethodGet) {
            if (request.resumableDownloadPath) {
                // add parameters to URL
                NSString *filteredUrl = [ABNetworkPrivate urlStringWithOriginUrlString:url appendParameters:param];
                
                NSURLRequest *requestUrl = [NSURLRequest requestWithURL:[NSURL URLWithString:filteredUrl]];
                NSURLSessionDownloadTask *task = [_manager downloadTaskWithResumeData:[NSData dataWithContentsOfFile:request.resumableDownloadPath]
                                                                             progress:request.resumableDownloadProgressBlock
                                                                          destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                                              return nil;
                                                                          }
                                                                    completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                                              
                                                                          }];
                [task resume];
            }
            else {
                request.sessionTask = [_manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
                [request.sessionTask resume];
            }
        }
        else if (method == ABRequestMethodPost) {
            if (constructingBlock != nil) {
                request.sessionTask = [_manager POST:url parameters:param constructingBodyWithBlock:constructingBlock progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
                [request.sessionTask resume];
            }
            else {
                request.sessionTask = [_manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
                [request.sessionTask resume];
            }
        }
        else if (method == ABRequestMethodHead) {
            request.sessionTask = [_manager HEAD:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task) {
               
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            [request.sessionTask resume];
        }
        else if (method == ABRequestMethodPut) {
            request.sessionTask = [_manager PUT:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            [request.sessionTask resume];
        }
        else if (method == ABRequestMethodDelete) {
            request.sessionTask = [_manager DELETE:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            [request.sessionTask resume];
        }
        else if (method == ABRequestMethodPatch) {
            request.sessionTask = [_manager PATCH:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            [request.sessionTask resume];
        }
        else {
            ABLog(@"Error, unsupport method type");
            return;
        }
    }
    ABLog(@"Add request: %@", NSStringFromClass([request class]));
    [self addSessionTask:request];
}


- (void)cancelRequest:(ABBaseRequest *)request {
    [request.sessionTask cancel];
    [self removeSessionTask:request.sessionTask];
    [request clearCompletionBlock];
}

- (void)cancelAllRequests {
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        ABBaseRequest *request = copyRecord[key];
        [request stop];
    }
}


- (BOOL)checkResult:(ABBaseRequest<ABRequestImplement> *)request {
    BOOL result = [request statusCodeValidator];
    if (!result) {
        return result;
    }
    id validator = [request jsonValidator];
    if (validator != nil) {
        id json = [request responseJSONObject];
        result = [ABNetworkPrivate checkJson:json withValidator:validator];
    }
    return result;
}

- (void)handleRequestResult:(NSURLSessionTask *)task {
    NSString *key = [self requestHashKey:task];
    ABBaseRequest<ABRequestImplement> *request = _requestsRecord[key];
    ABLog(@"Finished Request: %@", NSStringFromClass([request class]));
    if (request) {
        BOOL succeed = [self checkResult:request];
        if (succeed) {
            [request toggleAccessoriesWillStopCallBack];
            [request requestCompleteFilter];
            if (request.delegate != nil) {
                [request.delegate requestFinished:request];
            }
            if (request.successCompletionBlock) {
                request.successCompletionBlock(request);
            }
            [request toggleAccessoriesDidStopCallBack];
        }
        else {
            ABLog(@"Request %@ failed, status code = %ld",
                  NSStringFromClass([request class]), (long)request.responseStatusCode);
            [request toggleAccessoriesWillStopCallBack];
            [request requestFailedFilter];
            if (request.delegate != nil) {
                [request.delegate requestFailed:request];
            }
            if (request.failureCompletionBlock) {
                request.failureCompletionBlock(request);
            }
            [request toggleAccessoriesDidStopCallBack];
        }
    }
    [self removeSessionTask:task];
    [request clearCompletionBlock];
}

- (NSString *)requestHashKey:(NSURLSessionTask *)task {
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[task hash]];
    return key;
}

- (void)addSessionTask:(ABBaseRequest *)request {
    if (request.sessionTask != nil) {
        NSString *key = [self requestHashKey:request.sessionTask];
        @synchronized(self) {
            _requestsRecord[key] = request;
        }
    }
}

- (void)removeSessionTask:(NSURLSessionTask *)sessionTask {
    NSString *key = [self requestHashKey:sessionTask];
    @synchronized(sessionTask) {
        [_requestsRecord removeObjectForKey:key];
    }
    ABLog(@"Request queue size = %lu", (unsigned long)[_requestsRecord count]);
}
@end
