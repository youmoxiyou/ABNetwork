//
//  ABBaseRequest.m
//  Pods
//
//  Created by Abe on 15/12/29.
//
//

#import "ABBaseRequest.h"
#import "ABNetworkAgent.h"
#import "ABNetworkPrivate.h"

@implementation ABBaseRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(ABRequestImplement)]) {
            self.child = (id<ABRequestImplement>)self;
        }
        else {
            // 不遵守这个protocol，需要报错
            NSAssert(NO, @"子类必须实现ABRequestImplement这个protocol。");
        }
    }
    return self;
}


// append self to request queue
- (void)start {
    [self toggleAccessoriesWillStartCallBack];
    [[ABNetworkAgent sharedInstance] addRequest:self];
}

// remove self from request queue
- (void)stop {
    [self toggleAccessoriesWillStopCallBack];
    self.delegate = nil;
    [[ABNetworkAgent sharedInstance] cancelRequest:self];
    [self toggleAccessoriesDidStopCallBack];
}

- (BOOL)isExecuting {
    return self.sessionTask.state == NSURLSessionTaskStateRunning;
}

- (void)startWithCompletionBlockWithSuccess:(void (^)(ABBaseRequest *))success failure:(void (^)(ABBaseRequest *))failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(void (^)(ABBaseRequest *))success failure:(void (^)(ABBaseRequest *))failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    // nil out to break the retain cycle
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

//???
- (id)responseJSONObject {
    return nil;
}

- (NSString *)responseString {
    return @"";
}


#pragma mark - Request Accessories

- (void)addAccessory:(id<ABRequestAccessory>)accessory {
    if (!self.requestAccessories) {
        self.requestAccessories = [NSMutableArray array];
    }
    [self.requestAccessories addObject:accessory];
}

@end
