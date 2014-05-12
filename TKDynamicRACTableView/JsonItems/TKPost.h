//
//  TKPost.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 10/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "JSONModel.h"
#import "TKLike.h"
#import "TKComment.h"

#warning debug
#define testIMAGEURLToken @"moment.petta"
 
@interface TKPost : JSONModel

@property (nonatomic, assign) NSInteger userid;
@property (nonatomic, strong) NSString *usernickname; //nick name

@property (nonatomic, assign) NSInteger momentid;
@property (nonatomic, assign) NSInteger islike;
@property (nonatomic, strong) NSString *posttype; //diy type
@property (nonatomic, strong) NSString *momenturl;
@property (nonatomic, strong) NSString<Optional> *momentcontent;
@property (nonatomic, assign) NSInteger likecount;
@property (nonatomic, assign) NSInteger commentcount;
@property (nonatomic, assign) unsigned long long timestamp;
@property (strong, nonatomic) NSArray* tags;
@property (strong, nonatomic) NSArray<TKLike,Optional>* likes;
@property (strong, nonatomic) NSArray<TKComment,Optional>* comments;


- (NSString *)imageURLWithmoment:(NSString *) momenttoken;
- (NSString *)imageURLWithUser;
@end
