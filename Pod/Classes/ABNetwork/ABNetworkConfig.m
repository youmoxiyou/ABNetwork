//
//  ABNetworkConfig.m
//  Pods
//
//  Created by Abe on 15/12/29.
//
//

#import "ABNetworkConfig.h"

@implementation ABNetworkConfig {
    NSMutableArray *_urlFilters;
    NSMutableArray *_cacheDirPathFilters;
}

+ (ABNetworkConfig *)sharedInstance {
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
        _urlFilters = [NSMutableArray array];
        _cacheDirPathFilters = [NSMutableArray array];
    }
    return self;
}

- (void)addUrlFilter:(id<ABUrlFilterProtocol>)filter {
    [_urlFilters addObject:filter];
}

- (void)addCacheDirPathFilter:(id<ABCacheDirPathFilterProtocol>)filter {
    [_cacheDirPathFilters addObject:filter];
}

- (NSArray *)urlFilters {
    return [_urlFilters copy];
}

- (NSArray *)cacheDirPathFilters {
    return [_cacheDirPathFilters copy];
}
@end
