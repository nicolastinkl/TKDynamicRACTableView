//
//  ActivityTableViewCell.h
//  RefreshTable
//
//  Created by Molon on 13-11-11.
//  Copyright (c) 2013年 Molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XCJGroupPost_list;
@protocol ActivityTableViewCellDelegate <NSObject>

//点击某用户
- (void)clickUserID:(NSString *)uid onActivity:(XCJGroupPost_list *)activity;
//点击当前activity的发布者头像
- (void)clickAvatarButton:(UIButton *)avatarButton onActivity:(XCJGroupPost_list *)activity;
//点击评论按钮
- (void)clickCommentButton:(UIButton *)commentButton onActivity:(XCJGroupPost_list *)activity;
//点击赞按钮
- (void)clickLikeButton:(UIButton *)likeButton onActivity:(XCJGroupPost_list *)activity;
//点击评论View中的某行(当前如果点击的是其中的某用户是会忽略的)
- (void)clickCommentsView:(UIView *)commentsView atIndex:(NSInteger)index atBottomY:(CGFloat)bottomY onActivity:(XCJGroupPost_list *)activity;
/**
 *  删除该条动态
 *
 *  @param commentButton <#commentButton description#>
 *  @param activity      <#activity description#>
 */
- (void)clickDeleteButton:(UIButton *)commentButton onActivity:(XCJGroupPost_list *)activity;

@end


@interface ActivityTableViewCell : UITableViewCell

//cell高度
@property (nonatomic, assign,readonly) CGFloat cellHeight;
//当前cell对应的activity
@property (nonatomic, strong) XCJGroupPost_list *activity;

////刷新对应行[self reloadSingleActivityRowOfTableView:[self.activities indexOfObject:activity] withAnimation:NO];
@property (nonatomic, assign) BOOL HasLoad;

@property (nonatomic, assign) BOOL HasLoadlisks;

@property (nonatomic, assign) BOOL isloadingphotos;

//delegate
@property (nonatomic, weak) id<ActivityTableViewCellDelegate> delegate;

-(int) heigthforCell:(XCJGroupPost_list * )activity;
@property (nonatomic,weak) UIViewController *needRefreshViewController;
@end
