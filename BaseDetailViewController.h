//
//  BaseDetailViewController.h
//  RefreshTable
//
//  Created by Molon on 13-11-7.
//  Copyright (c) 2013年 Molon. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kEveryGetDataCount 10

enum ENUMLoadMoreData {
    Enum_initData  = 0,
    Enum_UpdateTopData = 1,
    Enum_MoreData = 2
    
};

@class MLScrollRefreshHeader;
@interface BaseDetailViewController : UIViewController< NSCoding>

@property (nonatomic,strong) MLScrollRefreshHeader *refreshView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *activities;
@property (nonatomic,strong) NSMutableArray *cellHeights;

@property (nonatomic,strong) UILabel *noDataHintLabel;
@property (nonatomic,strong) NSString * titleString;
//@property (nonatomic,assign) SEL UPloadClick;
- (void)failedGetActivitiesWithLastID:(NSInteger)lastID;
- (void)successGetActivities:(NSArray*)activities withLastID:(NSInteger)lastID;
- (void)reloadSingleActivityRowOfTableView:(NSInteger)row withAnimation:(BOOL)animation;
@end
