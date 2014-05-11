//
//  TKComentCell.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int16_t, STXCommentCellStyle) {
    STXCommentCellStyleSingleComment,
    STXCommentCellStyleShowAllComments
};


@class TKComentCell,TKComentCellViewModel;

@protocol TKCommentCellDelegate <NSObject>

@optional

- (void)commentCellWillShowAllComments:(TKComentCell *)commentCell;
- (void)commentCell:(TKComentCell *)commentCell willShowCommenter:(TKComentCellViewModel *)viewModel;
- (void)commentCell:(TKComentCell *)commentCell didSelectURL:(NSURL *)url;
- (void)commentCell:(TKComentCell *)commentCell didSelectHashtag:(NSString *)hashtag;
- (void)commentCell:(TKComentCell *)commentCell didSelectMention:(NSString *)mention;

@end

@class TKComentCellViewModel;
@interface TKComentCell : UITableViewCell
@property (nonatomic) TKComentCellViewModel *viewModel;
@property (nonatomic) NSInteger totalComments;
@property (weak, nonatomic) id <TKCommentCellDelegate> delegate;

- (instancetype)initWithStyle:(STXCommentCellStyle)style comment:(TKComentCellViewModel *)viewmodel reuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)initWithStyle:(STXCommentCellStyle)style totalComments:(NSInteger)totalComments reuseIdentifier:(NSString *)reuseIdentifier;

@end
