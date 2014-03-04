//
//  MLScrollRefreshHeader.h
//
//  Created by Molon on 13-11-7.
//  Copyright (c) 2013年 Molon. All rights reserved.
//
/**
 *  使用方法:
 _refreshView = [[MLScrollRefreshHeader alloc]initWithScrollView:self.tableView andDelegate:self isPlaySound:NO];
 
 [_refreshView beginRefreshing];
 
 设置好delegate 方法
 - (void)refreshHeaderBeginRefreshing:(MLScrollRefreshHeader *)refreshHeader{
 }
 
 数据加载完毕，需要主动调用 endRefreshing
 
 注意:!!!!!
 如若父View要释放，则必须在其释放之前将此View removeFromSuperView
 
 附加:
 如若需要主动刷新 beginRefreshing
 
 修改不了此view的frame，其初始化时候已根据scrollView自适应到头部以上
 */
#import <UIKit/UIKit.h>

@class MLScrollRefreshHeader;

@protocol MLScrollRefreshHeaderDelegate <NSObject>

@required

//开始刷新，在此delegate里需要执行数据重载或其他操作
- (void)refreshHeaderBeginRefreshing:(MLScrollRefreshHeader *)refreshHeader;

@end

@interface MLScrollRefreshHeader : UIView

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) id<MLScrollRefreshHeaderDelegate> delegate;

//使用scrollView初始化
- (id)initWithScrollView:(UIScrollView *)scrollView andDelegate:(id<MLScrollRefreshHeaderDelegate>)delegate isPlaySound:(BOOL)isPlaySound;
// 结束刷新
- (void)endRefreshing;

//主动刷新操作
- (void)beginRefreshing;

@end
