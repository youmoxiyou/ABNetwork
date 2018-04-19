//
//  ABViewController.m
//  ABNetwork
//
//  Created by AbeHui on 12/29/2015.
//  Copyright (c) 2015 AbeHui. All rights reserved.
//

#import "ABViewController.h"
#import "AFNetworking.h"

#import "LoginApiManager.h"
@interface ABViewController ()

@end

@implementation ABViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self testAFDataTask];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testAFDataTask {
    LoginApiManager *api = [[LoginApiManager alloc] init];
    [api start];
    
    NSString *username = @"e37cb4d15aa0881a7befed558c096cdde344bcf650e139fd";
    NSString *password = @"0f490ae3b18d3a10";
    NSString *baseUrl = @"http://114.215.182.172:8080";
    NSString *requestUrl = @"/youqu/login.htm";
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?loginId=%@&password=%@",baseUrl,requestUrl,username,password];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.HTTPMethod = @"POST";
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager POST:urlStr parameters:@{@"loginId":username,@"password":password} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];

    NSURLSessionTask *task = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
    }];
    [task resume];
    

    

}

@end
