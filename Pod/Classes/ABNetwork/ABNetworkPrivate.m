//
//  ABNetworkPrivate.m
//  Pods
//
//  Created by Abe on 15/12/29.
//
//

#import <CommonCrypto/CommonDigest.h>
#import "ABNetworkPrivate.h"

void ABLog(NSString *format, ...) {
#ifdef DEBUG
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}

@interface ABNetworkPrivate ()

+ (NSString *)urlParametersStringFromParameters:(NSDictionary *)parameters;
+ (NSString *)urlEncode:(NSString *)str;
@end

@implementation ABNetworkPrivate

+ (BOOL)checkJson:(id)json withValidator:(id)validatorJson {
    if ([json isKindOfClass:[NSDictionary class]] &&
        [validatorJson isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = json;
        NSDictionary *validator = validatorJson;
        BOOL result = YES;
        NSEnumerator *enumerator = [validator keyEnumerator];
        NSString *key;
        while ((key = [enumerator nextObject]) != nil) {
            id value = dict[key];
            id format = validator[key];
            if ([value isKindOfClass:[NSDictionary class]]
                || [value isKindOfClass:[NSArray class]]) {
                result = [self checkJson:value withValidator:format];
                if (!result) {
                    break;
                }
            }
            else {
                if ([value isKindOfClass:format] == NO &&
                    [value isKindOfClass:[NSNull class]] == NO) {
                    result = NO;
                    break;
                }
            }
        }
        return result;
    }
    else if ([json isKindOfClass:[NSArray class]] &&
             [validatorJson isKindOfClass:[NSArray class]]) {
        NSArray *validatorArray = (NSArray *)validatorJson;
        if (validatorArray.count > 0) {
            NSArray *array = json;
            NSDictionary *validator = validatorJson[0];
            for (id item in array) {
                BOOL result = [self checkJson:item withValidator:validator];
                if (!result) {
                    return NO;
                }
            }
        }
        return YES;
    }
    else if ([json isKindOfClass:validatorJson]) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (NSString *)urlEncode:(NSString *)str {
    //different library use slightly different escaped and unescaped set.
    //below is copied from AFNetworking but still escaped [] as AF leave them for Rails array parameter which we don't use.
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)str, CFSTR("."), CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
    return result;
}

+ (NSString *)urlParametersStringFromParameters:(NSDictionary *)parameters {
    NSMutableString *urlParameterString = [[NSMutableString alloc] initWithString:@""];
    if (parameters && parameters.count > 0) {
        for (NSString *key in parameters) {
            NSString *value = parameters[key];
            value = [NSString stringWithFormat:@"%@",value];
            value = [self urlEncode:value];
            [urlParameterString appendFormat:@"&%@=%@", key, value];
        }
    }
    return urlParameterString;
}

+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString appendParameters:(NSDictionary *)parameters {
    NSString *filteredUrl = originUrlString;
    NSString *paraUrlString = [self urlParametersStringFromParameters:parameters];
    if (paraUrlString && paraUrlString.length > 0) {
        if ([originUrlString rangeOfString:@"?"].location != NSNotFound) {
            filteredUrl = [filteredUrl stringByAppendingString:paraUrlString];
        }
        else {
            filteredUrl = [filteredUrl stringByAppendingFormat:@"?%@", [paraUrlString substringFromIndex:1]];
        }
        return filteredUrl;
    }
    else {
        return originUrlString;
    }
}

+ (void)addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        ABLog(@"error to set do not backup attribute, error = %@", error);
    }
}

+ (NSString *)md5StringFromString:(NSString *)string {
    if (string == nil || [string length] == 0) {
        return nil;
    }
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

+ (NSString *)appVersionString {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
@end

@implementation ABBaseRequest (RequestAccessory)

- (void)toggleAccessoriesWillStartCallBack {
    for (id<ABRequestAccessory> accessory in self.requestAccessories) {
        if ([accessory respondsToSelector:@selector(requestWillStart:)]) {
            [accessory requestWillStart:self];
        }
    }
}

- (void)toggleAccessoriesWillStopCallBack {
    for (id<ABRequestAccessory> accessory in self.requestAccessories) {
        if ([accessory respondsToSelector:@selector(requestWillStop:)]) {
            [accessory requestWillStop:self];
        }
    }
}

- (void)toggleAccessoriesDidStopCallBack {
    for (id<ABRequestAccessory> accessory in self.requestAccessories) {
        if ([accessory respondsToSelector:@selector(requestDidStop:)]) {
            [accessory requestDidStop:self];
        }
    }
}

@end

@implementation ABBatchRequest (RequestAccessory)

//- (void)toggleAccessoriesWillStartCallBack {
//    for (id<ABRequestAccessory> accessory in self.requestAccessories) {
//        if ([accessory respondsToSelector:@selector(requestWillStart:)]) {
//            [accessory requestWillStart:self];
//        }
//    }
//}
//
//- (void)toggleAccessoriesWillStopCallBack {
//    for (id<ABRequestAccessory> accessory in self.requestAccessories) {
//        if ([accessory respondsToSelector:@selector(requestWillStop:)]) {
//            [accessory requestWillStop:self];
//        }
//    }
//}
//
//- (void)toggleAccessoriesDidStopCallBack {
//    for (id<ABRequestAccessory> accessory in self.requestAccessories) {
//        if ([accessory respondsToSelector:@selector(requestDidStop:)]) {
//            [accessory requestDidStop:self];
//        }
//    }
//}

@end

@implementation ABChainRequest (RequestAccessory)

//- (void)toggleAccessoriesWillStartCallBack {
//    for (id<ABRequestAccessory> accessory in self.requestAccessories) {
//        if ([accessory respondsToSelector:@selector(requestWillStart:)]) {
//            [accessory requestWillStart:self];
//        }
//    }
//}
//
//- (void)toggleAccessoriesWillStopCallBack {
//    for (id<ABRequestAccessory> accessory in self.requestAccessories) {
//        if ([accessory respondsToSelector:@selector(requestWillStop:)]) {
//            [accessory requestWillStop:self];
//        }
//    }
//}
//
//- (void)toggleAccessoriesDidStopCallBack {
//    for (id<ABRequestAccessory> accessory in self.requestAccessories) {
//        if ([accessory respondsToSelector:@selector(requestDidStop:)]) {
//            [accessory requestDidStop:self];
//        }
//    }
//}

@end

