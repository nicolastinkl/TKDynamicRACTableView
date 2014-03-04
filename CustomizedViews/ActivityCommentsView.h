//
//  ActivityCommentsView.h
//  RefreshTable
//
//  Created by Molon on 13-11-11.
//  Copyright (c) 2013年 Molon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTTAttributedLabel;

@protocol ActivityCommentsViewDelegate <NSObject>

- (void)clickCommentsView:(UIView *)commentsView atIndex:(NSInteger)index atBottomY:(CGFloat)point;

@optional //向上传递label的链接点击
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithCMD:(NSString *)cmd;

@end

@interface ActivityCommentsView : UIView

@property (nonatomic,strong) NSArray *comments;

//delegate
@property (nonatomic, weak) id<ActivityCommentsViewDelegate> delegate;

@end
