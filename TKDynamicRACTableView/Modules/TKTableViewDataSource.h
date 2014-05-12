//
//  TKTableViewDataSource.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

@import Foundation;
@import UIKit;

@protocol TKLikesCellDelegate;
@protocol TKCaptionCellDelegate;
@protocol TKCommentCellDelegate;
@protocol TKFeedTitleInfoCellDelegate;

@class TKPhotoCell;
@class TKCaptionCell;
@class TKLikeCell;
@class TKComentCell;
@class TKUserEventCell;
@class TKFeedTitleInfoCell;

@class TKPost;
@interface TKTableViewDataSource : NSObject<UITableViewDataSource>

@property (copy, nonatomic) NSArray *posts;

-(TKPost *) postByIndexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithController:(id<TKLikesCellDelegate, TKCaptionCellDelegate, TKCommentCellDelegate,TKFeedTitleInfoCellDelegate>)controller tableView:(UITableView *)tableView;

- (TKFeedTitleInfoCell *)feedTitleCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (TKPhotoCell *)photoCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (TKCaptionCell *)captionCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (TKLikeCell *)likesCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (TKComentCell *)commentCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (TKUserEventCell *)userEventCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
