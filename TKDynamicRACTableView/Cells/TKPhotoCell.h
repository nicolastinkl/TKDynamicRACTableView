//
//  TKPhotoCell.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKPhotoCellViewModel;
@interface TKPhotoCell : UITableViewCell

- (void)configureWithViewModel:(TKPhotoCellViewModel *)viewModel reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic) UIButton *postImageButton;
@property (nonatomic) TKPhotoCellViewModel *viewModel;

@end
