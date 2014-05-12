//
//  TKFeedTitleInfoCell.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 10/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKFeedTitleInfoCellViewModel,RACCommand,TKFeedTitleInfoCell;

@protocol TKFeedTitleInfoCellDelegate <NSObject>

@optional

- (void)titleCellWillShows:(TKFeedTitleInfoCell *) titleCell;

@end;

@interface TKFeedTitleInfoCell : UITableViewCell

- (void)configureWithViewModel:(TKFeedTitleInfoCellViewModel *)viewModel;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property(nonatomic,strong) RACCommand * avaterCommant;

@property (nonatomic) TKFeedTitleInfoCellViewModel *viewModel;

@property (weak, nonatomic) id <TKFeedTitleInfoCellDelegate> delegate;

@end
