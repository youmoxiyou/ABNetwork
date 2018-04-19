//
//  ABNetworkAgent.h
//  Pods
//
//  Created by Abe on 15/12/29.
//
//

#import <Foundation/Foundation.h>
#import "ABBaseRequest.h"
#import "AFNetworking.h"

@interface ABNetworkAgent : NSObject

+ (ABNetworkAgent *)sharedInstance;

- (void)addRequest:(ABBaseRequest<ABRequestImplement>  *)request;

- (void)cancelRequest:(ABBaseRequest *)request;

- (void)cancelAllRequest;

/// 根据request和networkConfig构建url
- (NSString *)buildRequestUrl:(ABBaseRequest<ABRequestImplement>  *)request;
@end
