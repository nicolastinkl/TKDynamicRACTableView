//
//  TKAPIManager.m
//  TKDynamicRACTableView
//
//  Created by tinkl on 10/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "TKAPIManager.h"
#import "TKUtilsMacro.h"
#import "TKPost.h"
#import <JSONKit.h>
#import <ReactiveCocoa.h>
#import <AFNetworking-RACExtensions/AFHTTPRequestOperationManager+RACSupport.h>
#import <UALogger.h>

#define baseURL @"http://api.petta.mobi"

@implementation TKAPIManager

+ (instancetype)sharedManager
{
    static TKAPIManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self manager];
//        instance.baseURL = url;
    });
    return instance;
}

/*!
 *  main fetch selector
 *
 *  @param tag             <#tag description#>
 *  @param offsetTimestamp <#offsetTimestamp description#>
 *  @param limit           <#limit description#>
 *
 *  @return RACSignal
 */
- (RACSignal *)fetchPostsWithTimestamp:(NSString *)tag offset:(unsigned long long )offsetTimestamp limit:(NSInteger)limit
{
    /*
     test:
     action	getkeywordmoments
     value	{"userid":"21293","type":1,"count":"10","keyword":"爱狗狗，爱拍它","isonlycount":false,"timeline":"1399633460047"}
     version	2
     */
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * paramsChild = [[NSMutableDictionary alloc] init];
    paramsChild[@"userid"] = @21293;
    paramsChild[@"type"] = @1;
    paramsChild[@"count"] = @(limit);
    paramsChild[@"keyword"] = tag;
    paramsChild[@"isonlycount"] = @false;
    paramsChild[@"timeline"] =@1399720005939;// @(offsetTimestamp);
    params[@"action"] = @"getkeywordmoments";
    params[@"value"] = [paramsChild JSONString];
    params[@"version"] = @"2";
    return [self fetchPostsWithPost:params];
}

/*!
 *  fetch with url
 *
 *  @param urlString <#urlString description#>
 *
 *  @return RACSignal
 */
- (RACSignal *)fetchPostsWithURL:(NSString *)urlString
{
    return [[self rac_GET:urlString parameters:nil] map:^id(NSDictionary *data) {
        return [[((NSArray *)data[@"moments"]).rac_sequence map:^id(id value) {
            return [[TKPost alloc] initWithDictionary:value error:nil];
        }] array];
    }];
}

/*!
 *  GET
 *
 *  @return RECSingnal
 */
- (RACSignal *)fetchPostWithGet
{
    return [[self rac_GET:@"http://api.petta.mobi/api.do" parameters:nil] map:^id(NSArray *tags) {
        return [[tags.rac_sequence map:^id(id value) {
            return [[TKPost alloc] initWithDictionary:value error:nil];
        }] array];
    }];
}

/*!
 *  POST
 *
 *  @return RECSingnal
 */
- (RACSignal *)fetchPostsWithPost:(NSMutableDictionary * ) params
{
     /*     return [[self rac_GET:@"http://api.huaban.com/fm/wallpaper/tags" parameters:nil] map:^id(NSArray *tags) {
     return [[tags.rac_sequence map:^id(id value) {
     return value;
     }] array];
     }]; // test ok
      */
    return [[[[self rac_POST:@"http://api.petta.mobi/api.do" parameters:params] map:^id(id posts) {
        /*!
         *  reponse code 200
         */
        UALogFull(@" reponse code 200 ");
        if (posts) {
            UALog(@"response message : %@",posts[@"response"][@"response_msg"]);
        }
        if (posts && [posts[@"response"][@"response_code"] intValue] == 0) {
            NSArray * moments = posts[@"moments"];
            UALog(@"moments %lu",(unsigned long)moments.count);
            return  [[moments.rac_sequence map:^id(id value) {
                TKPost * post = [[TKPost alloc] initWithDictionary:value error:nil];
                return post;
            }] array];
        }else{
            /*!
             *  error  maybe network error
             */
            return @[[RACSignal empty]];
        }
    }]  catch:^RACSignal *(NSError *error) {
        return [RACSignal error:error];
    }] replayLazily];
}

- (RACSignal *)fetchTokenWithParameters:(NSMutableDictionary *)parameters
{
    return [[[[[[self rac_POST:@"http://api.petta.mobi/api.do" parameters:parameters]
                 // reduceEach的作用是传入多个参数，返回单个参数，是基于`map`的一种实现
                 reduceEach:^id(AFHTTPRequestOperation *operation, NSDictionary *response){
                     UALog(@"response :%@",response);
                     // 拿到token后，就设置token property
                     // setToken:方法会被触发，在那里会设置请求的头信息，如Authorization。
//                     HBPAccessToken *token = [[HBPAccessToken alloc] initWithDictionary:response];
//                     self.token = token;
                     return self;
                 }]
                catch:^RACSignal *(NSError *error) {
                    // 对Error进行处理，方便外部识别
//                    NSInteger code = error.code == -1001 ? HBPAPIManagerErrorConnectionFailed : HBPAPIManagerErrorAuthenticatedFailed;
//                    NSError *apiError = [[NSError alloc] initWithDomain:HBPAPIManagerErrorDomain code:code userInfo:nil];
                    return [RACSignal error:error];
                }]
               then:^RACSignal *{
                   // 一切正常的话，顺便获取用户信息
                   UALogFull(@"then");
                   return [self fetchPostsWithPost:parameters];
               }]
//              doNext:^(id *someobj) {
//                  // doNext相当于一个钩子，是在sendNext时会被执行的一段代码
////                  self.user = user;
//                  UALogFull(someobj);
//                  return self;
//              }]
             // 把发送内容换成self
             mapReplace:self]
            // 避免side effect
            replayLazily];
}


@end
