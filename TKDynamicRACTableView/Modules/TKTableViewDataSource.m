//
//  TKTableViewDataSource.m
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "TKTableViewDataSource.h"
#import "TKPost.h"

#import "TKFeedTitleInfoCell.h"
#import "TKPhotoCell.h"
#import "TKCaptionCell.h"
#import "TKComentCell.h"
#import "TKLikeCell.h"
#import "TKUserEventCell.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "TKFeedTitleInfoCellViewModel.h"
#import "TKPhotoCellViewModel.h"
#import "TKCaptionCellViewModel.h"
#import "TKLikeCellViewModel.h"
#import "TKComentCellViewModel.h"
#import "TKUserEventCellViewModel.h"


#define TK_FEEDTITLE_CELL_ROW 0
#define TK_PHOTO_CELL_ROW 1
#define TK_CAPTION_CELL_ROW 2
#define TK_LIKES_CELL_ROW 3

#define NUMBER_OF_STATIC_ROWS 4
#define MAX_NUMBER_OF_COMMENTS 4


@interface TKTableViewDataSource ()

@property (weak, nonatomic) id<TKLikesCellDelegate, TKCaptionCellDelegate, TKCommentCellDelegate>controller;

@end


@implementation TKTableViewDataSource


- (instancetype)initWithController:(id<TKLikesCellDelegate, TKCaptionCellDelegate, TKCommentCellDelegate>)controller tableView:(UITableView *)tableView
{
    
    self = [super init];
    if (self) {
        _controller = controller;
        
        NSString *feedTitleInfoCell = NSStringFromClass([TKFeedTitleInfoCell class]);
        UINib *userActionCellNib = [UINib nibWithNibName:feedTitleInfoCell bundle:nil];
        [tableView registerNib:userActionCellNib forCellReuseIdentifier:feedTitleInfoCell];
    }
    
    return self;
    
}
- (TKFeedTitleInfoCell *)feedTitleCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = NSStringFromClass([TKFeedTitleInfoCell class]);
    TKFeedTitleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (cell.indexPath != nil && cell.indexPath.section != indexPath.section) {
//        [cell cancelImageLoading];
    }

    cell.indexPath = indexPath;
    
    if (indexPath.section < [self.posts count]) {
        TKPost * post = self.posts[indexPath.section];
        TKFeedTitleInfoCellViewModel *viewModel = [[TKFeedTitleInfoCellViewModel alloc] init];
        viewModel.posts = post;
        viewModel.indexPath = indexPath;
        [cell configureWithViewModel:viewModel];
    }
    
    return cell;
}
- (TKPhotoCell *)photoCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    TKPost * post = self.posts[indexPath.section];
    NSString *CellIdentifier = NSStringFromClass([TKPhotoCell class]);
    TKPhotoCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        TKPhotoCellViewModel * viewmodel = [[TKPhotoCellViewModel alloc] init];
        viewmodel.posts = post;
        viewmodel.indexPath = indexPath;
        cell = [[TKPhotoCell alloc] initConfigureWithViewModel:viewmodel reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}
- (TKCaptionCell *)captionCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    TKPost * post = self.posts[indexPath.section];
    NSString *CellIdentifier = NSStringFromClass([TKCaptionCell class]);
    TKCaptionCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        TKCaptionCellViewModel * viewmodel = [[TKCaptionCellViewModel alloc] init];
        viewmodel.posts = post;
        viewmodel.indexPath = indexPath;
        cell = [[TKCaptionCell alloc] initWithCaption:viewmodel reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}
- (TKLikeCell *)likesCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    TKPost * post = self.posts[indexPath.section];
    TKLikeCell *cell;
    
    if (cell == nil) {
        TKLikeCellViewModel *viewmodel = [[TKLikeCellViewModel alloc] init];
        viewmodel.posts = post;
        viewmodel.indexPath = indexPath;
        
        NSInteger count = post.likecount;
        if (count > 2) {
            static NSString *CellIdentifier = @"TKLikesCountCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell = [[TKLikeCell alloc] initWithStyle:STXLikesCellStyleLikesCount likes:viewmodel reuseIdentifier:CellIdentifier];
        } else {
            static NSString *CellIdentifier = @"TKLikersCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell = [[TKLikeCell alloc] initWithStyle:STXLikesCellStyleLikers likes:viewmodel reuseIdentifier:CellIdentifier];
        }
        
        cell.delegate = self.controller;
        cell.viewModel = viewmodel;
    }
    return cell;
}
- (TKComentCell *)commentCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    TKPost * post = self.posts[indexPath.section];
    TKComentCell *cell;

    
    if (indexPath.row == 0 && [post commentcount] > MAX_NUMBER_OF_COMMENTS) {
        
        static NSString *AllCommentsCellIdentifier = @"TKAllCommentsCell";
        cell = [tableView dequeueReusableCellWithIdentifier:AllCommentsCellIdentifier];
        
        if (cell == nil) {
            cell = [[TKComentCell alloc] initWithStyle:STXCommentCellStyleShowAllComments
                                           totalComments:[post commentcount]
                                         reuseIdentifier:AllCommentsCellIdentifier];
        } else {
            cell.totalComments = [post commentcount];
        }
        
    } else {
        static NSString *CellIdentifier = @"TKSingleCommentCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        NSArray *comments = [post comments];
        TKComment * comment = comments[indexPath.row];
        
        
        TKComentCellViewModel * viewModel = [[TKComentCellViewModel alloc] init];
        viewModel.indexPath = indexPath;
        viewModel.comments = comment;
        
        if (indexPath.row < [comments count]) {
            if (cell == nil) {
                cell = [[TKComentCell alloc] initWithStyle:STXCommentCellStyleSingleComment
                                                     comment:viewModel
                                             reuseIdentifier:CellIdentifier];
            } else {
                cell.viewModel = viewModel;
            }
            cell.totalComments = [post commentcount];
        }
    }
    
    cell.delegate = self.controller;
    
    return cell;
}
- (TKUserEventCell *)userEventCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    
    TKPost * post = self.posts[indexPath.section];
    
    NSString *CellIdentifier = NSStringFromClass([TKUserEventCell class]);
    TKUserEventCell *cell;
    if (cell == nil) {
        TKUserEventCellViewModel * viewModel = [[TKUserEventCellViewModel alloc] init];
        viewModel.posts = post;
        cell.viewModel = viewModel;
        cell = [[TKUserEventCell alloc] initConfigureWithViewModel:viewModel reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark  TableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.posts count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TKPost* postItem = self.posts[section];
    NSInteger commentsCount = MIN(MAX_NUMBER_OF_COMMENTS, [postItem commentcount]);
    return NUMBER_OF_STATIC_ROWS + commentsCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;    
    NSInteger captionRowOffset = 4;
    NSInteger commentsRowLimit = captionRowOffset + MAX_NUMBER_OF_COMMENTS;
    if (indexPath.row == TK_FEEDTITLE_CELL_ROW) {
        cell = [self feedTitleCellForTableView:tableView atIndexPath:indexPath];
    } else if (indexPath.row == TK_PHOTO_CELL_ROW) {
        cell = [self photoCellForTableView:tableView atIndexPath:indexPath];
    } else if (indexPath.row == TK_CAPTION_CELL_ROW) {
        cell = [self captionCellForTableView:tableView atIndexPath:indexPath];
    } else if (indexPath.row == TK_LIKES_CELL_ROW) {
        cell = [self likesCellForTableView:tableView atIndexPath:indexPath];
    } else if (indexPath.row > TK_LIKES_CELL_ROW && indexPath.row < commentsRowLimit) {
        NSIndexPath *commentIndexPath = [NSIndexPath indexPathForRow:indexPath.row-captionRowOffset inSection:indexPath.section];
        cell = [self commentCellForTableView:tableView atIndexPath:commentIndexPath];
    } else {
        cell = [self userEventCellForTableView:tableView atIndexPath:indexPath];
    }
    if ([tableView respondsToSelector:@selector(separatorInset)]) {
        tableView.separatorInset = UIEdgeInsetsZero;
    }
    
    return cell;
}



@end
