//
//  TKLikeCellViewModel.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "RVMViewModel.h"

@class TKLike;
@interface TKLikeCellViewModel : RVMViewModel

@property (nonatomic) TKLike * like;
@property (nonatomic) NSIndexPath *indexPath;


@end
