//
//  TKTableViewDelegate.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TKLikesCellDelegate;
@protocol TKCaptionCellDelegate;
@protocol TKCommentCellDelegate;

@interface TKTableViewDelegate : NSObject<UITableViewDelegate>

@property (nonatomic) BOOL insertingRow;

- (instancetype)initWithController:(id<TKLikesCellDelegate, TKCaptionCellDelegate, TKCommentCellDelegate>)controller;

- (void)reloadAtIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView;


@end
