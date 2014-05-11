//
//  TKComentCellViewModel.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "RVMViewModel.h"

@class TKComment;
@interface TKComentCellViewModel : RVMViewModel

@property (nonatomic) TKComment * comments;
@property (nonatomic) NSIndexPath *indexPath;

@end
