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
#import <ReactiveCocoa.h>
#import <AFNetworking-RACExtensions/AFHTTPRequestOperationManager+RACSupport.h>

@implementation TKAPIManager

+ (instancetype)sharedManager
{
    static TKAPIManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self manager];
    });
    return instance;
}

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
    paramsChild[@"keyword"] = @"爱狗狗，爱拍它";
    paramsChild[@"isonlycount"] = @false;
    paramsChild[@"timeline"] = @(offsetTimestamp);
    params[@"action"] = @"getkeywordmoments";
    params[@"value"] = paramsChild;
    params[@"version"] = @"2";
    return [self fetchPostsWithPost:params];
}

- (RACSignal *)fetchPinsWithURL:(NSString *)urlString
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
    return [[self rac_POST:@"http://api.petta.mobi/api.do" parameters:params] map:^id(id posts) {
        /*!
         *  reponse code 200
         */
        if (posts && [posts[@"response"][@"response_code"] intValue] == 0) {
            NSArray * moments = posts[@"moments"];
           return  [[moments.rac_sequence map:^id(id value) {
                    return [[TKPost alloc] initWithDictionary:value error:nil];
            }] array];
        }else{
            /*!
             *  error  maybe network error
             */
            return [RACSignal empty];
        }
    }
    ];
}


@end
