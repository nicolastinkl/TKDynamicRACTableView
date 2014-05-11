//
//  TKComentCellViewModel.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "RVMViewModel.h"
#import "TKComment.h"

@interface TKComentCellViewModel : RVMViewModel

@property (nonatomic) TKComment * comments;
@property (nonatomic) NSIndexPath *indexPath;

@end
