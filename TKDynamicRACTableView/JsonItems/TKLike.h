//
//  TKLike.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 10/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "JSONModel.h"
/*
 {
 "userid":22148,
 "usernickname":"Yanni_ÈõÖÂ∞º",
 "likeid":62836,
 "timeline":1399696444944
 }*/

@protocol TKLike  

@end
@interface TKLike : JSONModel
@property (nonatomic, assign) NSInteger userid;
@property (nonatomic, strong) NSString *usernickname;
@property (nonatomic, assign) NSInteger *likeid;

@end
