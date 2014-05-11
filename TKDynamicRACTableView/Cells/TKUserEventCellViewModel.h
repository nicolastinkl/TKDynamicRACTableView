//
//  TKUserEventCellViewModel.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "RVMViewModel.h"

@class TKPost;
@interface TKUserEventCellViewModel : RVMViewModel

@property (nonatomic) TKPost * posts;
@property (nonatomic) NSIndexPath *indexPath;

@end
