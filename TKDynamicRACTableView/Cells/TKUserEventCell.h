//
//  TKUserEventCell.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKUserEventCellViewModel;
@interface TKUserEventCell : UITableViewCell

- (id)initConfigureWithViewModel:(TKUserEventCellViewModel *)viewModel reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic) UIButton *likeImageButton;
@property (nonatomic) UIButton *commentImageButton;
@property (nonatomic) UIButton *shareImageButton;

@property (nonatomic) TKUserEventCellViewModel *viewModel;

@end
