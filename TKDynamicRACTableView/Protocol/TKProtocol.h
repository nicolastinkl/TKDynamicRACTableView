//
//  TKProtocol.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 10/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;

@protocol TKProtocol <NSObject>
@end

/*!
 *  module
 */
@protocol TKViewControllerProtocol <NSObject>
- (void)configureWithTimestamp:(unsigned long long) timestamp;
- (void)configureWithLatest;
@end


/*!
 *  module
 */
@class TKViewControllerModel;
@protocol TKDetailsViewControllerProtocol <NSObject>
- (void)configureWithModel:(TKViewControllerModel *) viewModel;
@end



/*!
 *  model
 */
@protocol TKViewControllerModelProtocol <NSObject>
@property (nonatomic) NSArray *post; //diffent with NSMutableArray
- (RACSignal *)fetchPostsWithTimestamp:(unsigned long long) timestamp offset:(NSUInteger)offset;
- (RACSignal *)fetchMorePosts;
@end
