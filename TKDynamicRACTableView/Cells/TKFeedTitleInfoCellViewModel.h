//
//  TKFeedTitleInfoCellViewModel.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 10/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "RVMViewModel.h"

@class TKPost;
@interface TKFeedTitleInfoCellViewModel : RVMViewModel

@property (nonatomic) TKPost *pin;
@property (nonatomic) NSIndexPath *indexPath;

@end
