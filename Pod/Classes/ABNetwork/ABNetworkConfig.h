//
//  ABNetworkConfig.h
//  Pods
//
//  Created by Abe on 15/12/29.
//
//

#import <Foundation/Foundation.h>
#import "ABBaseRequest.h"

@protocol ABUrlFilterProtocol <NSObject>
- (NSString *)filterUrl:(NSString *)originUrl withRequest:(ABBaseRequest *)request;
@end

@protocol ABCacheDirPathFilterProtocol <NSObject>
- (NSString *)filterCacheDirPath:(NSString *)originPath withRequest:(ABBaseRequest *)request;
@end

@interface ABNetworkConfig : NSObject

@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, strong) NSString *cdnUrl;
@property (nonatomic, strong, readonly) NSArray *urlFilters;
@property (nonatomic, strong, readonly) NSArray *cacheDirPathFilters;

+ (ABNetworkConfig *)sharedInstance;

- (void)addUrlFilter:(id<ABUrlFilterProtocol>)filter;
- (void)addCacheDirPathFilter:(id<ABCacheDirPathFilterProtocol>)filter;

@end
