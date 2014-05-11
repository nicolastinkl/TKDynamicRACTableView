//
//  TKAPIManager+Comment.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "TKAPIManager.h"

/*!
 *  get Comment list
 */
@interface TKAPIManager (Comment)

- (RACSignal *)requestWithMethod:(NSString *)method relativePath:(NSString *)relativePath parameters:(NSDictionary *)parameters;

@end
