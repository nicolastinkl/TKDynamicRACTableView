//
//  TKComment.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 10/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "JSONModel.h"

/*
 "userid":22924,
 "usernickname":"Ë¢´Áã¨ÂÆ†DeÂõ¢ÈÖ±",
 "commentid":20895,
 "commentcontent":"‰∏áÂ≠êÁúü‰πñ"
 */

@protocol TKComment
@end


@interface TKComment : JSONModel

@property (nonatomic, assign) NSInteger userid;
@property (nonatomic, strong) NSString  *usernickname;
@property (nonatomic, strong) NSString  *commentid;
@property (nonatomic, strong) NSString  *commentcontent;

@end
