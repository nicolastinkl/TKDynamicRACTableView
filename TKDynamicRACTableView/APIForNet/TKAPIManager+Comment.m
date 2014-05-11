//
//  TKAPIManager+Comment.m
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "TKAPIManager+Comment.h"

@implementation TKAPIManager (Comment)

- (RACSignal *)requestWithMethod:(NSString *)method relativePath:(NSString *)relativePath parameters:(NSDictionary *)parameters
{
    return [self fetchPostsWithTimestamp:@"" offset:0 limit:10];
}

@end
