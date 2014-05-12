//
//  TKTableViewDelegate.m
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "TKTableViewDelegate.h"
#import "TKTableViewDataSource.h"

#import "TKFeedTitleInfoCell.h"
#import "TKPhotoCell.h"
#import "TKCaptionCell.h"
#import "TKComentCell.h"
#import "TKLikeCell.h"
#import "TKUserEventCell.h"

#import "UIView+Layout.h"
#import "TKUtilsMacro.h"
#import "TKPost.h"
#import "TKComment.h"
#import "TKLike.h"
#import <UALogger.h>
#define TK_FEEDTITLE_CELL_ROW 0
#define TK_PHOTO_CELL_ROW 1
#define TK_CAPTION_CELL_ROW 2
#define TK_LIKES_CELL_ROW 3


#define NUMBER_OF_STATIC_ROWS 5
#define MAX_NUMBER_OF_COMMENTS 3

static CGFloat const PhotoCellRowHeight = 305;
static CGFloat const UserActionCellHeight = 44;
static CGFloat const ContenCellHeight = 30;

@interface TKTableViewDelegate () <UIScrollViewDelegate>

@property (weak, nonatomic) id<TKLikesCellDelegate, TKCaptionCellDelegate, TKCommentCellDelegate> controller;

@end


@implementation TKTableViewDelegate


- (instancetype)initWithController:(id<TKLikesCellDelegate, TKCaptionCellDelegate, TKCommentCellDelegate>)controller
{
    self = [super init];
    if (self) {
        _controller = controller;
    }
    
    return self;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
//    NSInteger captionRowOffset = 4;
//    NSInteger commentsRowLimit = captionRowOffset + MAX_NUMBER_OF_COMMENTS;
    
//    UITableViewCell *cell;
    TKTableViewDataSource *dataSource = (TKTableViewDataSource*)tableView.dataSource;
    
    NSInteger captionRowOffset = 4;
    TKPost* postItem = dataSource.posts[indexPath.section];
    NSInteger commentsCounts = MIN(MAX_NUMBER_OF_COMMENTS, [postItem commentcount]);
    NSInteger row = NUMBER_OF_STATIC_ROWS + commentsCounts;
    
    
    TKPost * posts = [dataSource postByIndexPath:indexPath];
    if (indexPath.row == TK_FEEDTITLE_CELL_ROW) {
        return UserActionCellHeight;
    } else if (indexPath.row == TK_PHOTO_CELL_ROW) {
        return PhotoCellRowHeight;
    } else if (indexPath.row == TK_CAPTION_CELL_ROW) {
//        cell = [dataSource captionCellForTableView:tableView atIndexPath:indexPath];
        return [self heightForCell:posts.momentcontent];
    } else if (indexPath.row == TK_LIKES_CELL_ROW) {
//        cell = [dataSource likesCellForTableView:tableView atIndexPath:indexPath];
        return ContenCellHeight;
    } else if (indexPath.row > TK_LIKES_CELL_ROW &&   indexPath.row < row-1) {
        NSIndexPath *commentIndexPath = [NSIndexPath indexPathForRow:indexPath.row-captionRowOffset inSection:indexPath.section];
//        cell = [dataSource commentCellForTableView:tableView atIndexPath:commentIndexPath];
        if (posts.comments.count > commentIndexPath.row) {
            
            TKComment * comment = posts.comments[commentIndexPath.row];
            return [self heightForCell:comment.commentcontent];
        }else{
            return 0.0f;
        }
    } else {
        return UserActionCellHeight;
    }
    
//    [cell setNeedsUpdateConstraints];
//    [cell updateConstraintsIfNeeded];
//    height = [self heightForTableView:tableView cell:cell atIndexPath:indexPath];
    
    return height;
}

-(CGFloat) heightForCell:(NSString * ) text
{
    CGFloat maxWidth = 300;//ScreenWidth * 0.70f;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGSize sizeToFit = [text sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    
    return sizeToFit.height + 10.0f ;// fmaxf(20.0f, sizeToFit.height + 5.0f );
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)heightForTableView:(UITableView *)tableView cell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.bounds = CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGSize cellSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    // Add extra padding
    CGFloat height = cellSize.height + 5;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Row Updates

- (void)reloadAtIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView
{
    self.insertingRow = YES;
    
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Scroll View

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    id<UIScrollViewDelegate> scrollViewDelegate = (id<UIScrollViewDelegate>)self.controller;
    if ([scrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [scrollViewDelegate scrollViewDidScroll:scrollView];
    }
}


@end
