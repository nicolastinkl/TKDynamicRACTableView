//
//  TKFeedTitleInfoCell.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 10/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKFeedTitleInfoCellViewModel;

@interface TKFeedTitleInfoCell : UITableViewCell

- (void)configureWithViewModel:(TKFeedTitleInfoCellViewModel *)viewModel  reuseIdentifier:(NSString *)reuseIdentifier;;

@property (nonatomic) UIButton *UserAvaterImageButton;
@property (nonatomic) TKFeedTitleInfoCellViewModel *viewModel;

@end
