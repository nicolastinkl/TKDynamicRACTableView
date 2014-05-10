//
//  TKViewControllerModel.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 10/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "RVMViewModel.h"
#import "TKProtocol.h"
/*!
 * MARK:  RAC View Model
 TODO: don't confuson with '*module'
 */
@interface TKViewControllerModel : RVMViewModel<TKViewControllerModelProtocol>

@property (nonatomic) NSArray * post;

@property (nonatomic,assign) unsigned long long timestamp;


@end
