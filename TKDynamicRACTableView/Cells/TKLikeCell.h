//
//  TKLikeCell.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSUInteger, STXLikesCellStyle) {
    STXLikesCellStyleLikesCount,
    STXLikesCellStyleLikers
};

@class TKLikeCell;
@protocol TKLikesCellDelegate <NSObject>

@optional

- (void)likesCellWillShowLikes:(TKLikeCell *)likesCell;
- (void)likesCellDidSelectLiker:(NSString *)liker;

@end

@class TKLikeCellViewModel;
@interface TKLikeCell : UITableViewCell

@property (nonatomic) TKLikeCellViewModel *viewModel;
@property (weak, nonatomic) id <TKLikesCellDelegate> delegate;

- (instancetype)initWithStyle:(STXLikesCellStyle)style likes:(TKLikeCellViewModel *)viewModel reuseIdentifier:(NSString *)reuseIdentifier;

@end
