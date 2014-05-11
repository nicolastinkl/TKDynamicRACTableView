//
//  TKAPIManager.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 10/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import <AFNetworking.h>

@class RACSignal;

@interface TKAPIManager : AFHTTPRequestOperationManager

+ (instancetype)sharedManager;

- (RACSignal *)fetchPostsWithTimestamp:(NSString *)tag offset:(unsigned long long )offsetTimestamp limit:(NSInteger)limit;

@end