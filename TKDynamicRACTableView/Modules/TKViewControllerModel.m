//
//  TKViewControllerModel.m
//  TKDynamicRACTableView
//
//  Created by tinkl on 10/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "TKViewControllerModel.h"
#import "TKProtocol.h"
#import "TKAPIManager.h"
#import "TKPost.h"

#define limitCount      10
#define tag             @"爱狗狗，爱拍它"

@implementation TKViewControllerModel

//@property (nonatomic) NSArray *post; //diffent with NSMutableArray
- (RACSignal *)fetchPostsWithTimestamp:(unsigned long long) timestamp offset:(NSUInteger)offset
{
    return [[TKAPIManager sharedManager] fetchPostsWithTimestamp:tag offset:self.timestamp limit:limitCount];
}

- (RACSignal *)fetchMorePosts
{
    unsigned long long  seq = self.post.count ? ((TKPost *)[self.post lastObject]).timestamp : self.timestamp;
    return [[TKAPIManager sharedManager] fetchPostsWithTimestamp:tag offset:seq limit:limitCount];
}
@end
