//
//  TKCaptionCell.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKCaptionCell,TKCaptionCellViewModel;
@protocol TKCaptionCellDelegate <NSObject>

@optional

- (void)captionCell:(TKCaptionCell *)captionCell didSelectHashtag:(NSString *)hashtag;
- (void)captionCell:(TKCaptionCell *)captionCell didSelectMention:(NSString *)mention;
- (void)captionCell:(TKCaptionCell *)captionCell didSelectPoster:(TKCaptionCellViewModel *)viewmodel;

@end


@class TKCaptionCellViewModel;
@interface TKCaptionCell : UITableViewCell

@property (nonatomic) TKCaptionCellViewModel *viewModel;
@property (weak, nonatomic) id <TKCaptionCellDelegate> delegate;

- (id)initWithCaption:(TKCaptionCellViewModel *)viewmodel reuseIdentifier:(NSString *)reuseIdentifier;

@end
