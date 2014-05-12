//
//  TKViewController.m
//  TKDynamicRACTableView
//
//  Created by tinkl on 10/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "TKViewController.h"


#import "TKPost.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import <JSObjection.h>
#import "TKViewControllerModel.h"
#import <SVProgressHUD.h>
#import <SVPullToRefresh.h>
#import <UALogger.h>
#import <MHPrettyDate.h>
#import "TKTableViewDataSource.h"
#import "TKTableViewDelegate.h"

#import "TKFeedTitleInfoCell.h"
#import "TKPhotoCell.h"
#import "TKCaptionCell.h"
#import "TKComentCell.h"
#import "TKLikeCell.h"
#import "TKUserEventCell.h"
#import "TKFeedTitleInfoCellViewModel.h"

@interface TKViewController ()<TKLikesCellDelegate, TKCaptionCellDelegate, TKCommentCellDelegate,TKFeedTitleInfoCellDelegate>
@property (nonatomic) TKViewControllerModel *viewModel;

@property (strong, nonatomic) TKTableViewDataSource *tableViewDataSource;
@property (strong, nonatomic) TKTableViewDelegate *tableViewDelegate;
@property (nonatomic) RACCommand *rightButtonCommand;

@end

@implementation TKViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.viewModel = [[TKViewControllerModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"龙猫";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:refreshControl];
    
    TKTableViewDataSource *dataSource = [[TKTableViewDataSource alloc] initWithController:self tableView:self.tableView];
    self.tableView.dataSource = dataSource;
    self.tableViewDataSource = dataSource;
    
    TKTableViewDelegate *delegate = [[TKTableViewDelegate alloc] initWithController:self];
    self.tableView.delegate = delegate;
    self.tableViewDelegate = delegate;
    
    @weakify(self);
    [RACObserve(self, viewModel.post) subscribeNext:^(NSArray * posts) {
        @strongify(self);
        if (posts.count > 0) {
            
            self.tableViewDataSource.posts = [posts copy];
            
            [self.tableView reloadData];
        }else{
            UALog(@"NO data");
        }
    }];

    unsigned long long time  = [[NSDate date] timeIntervalSince1970]* 1000;
    self.viewModel.timestamp = time;
    [[refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self);
        [[self.viewModel fetchPostsWithTimestamp:time offset:10] subscribeNext:^(NSArray *pins) {
            UALogFull(@"fetch ok");
            @strongify(self);
            self.viewModel.post = pins;
        }];
        
        [refreshControl endRefreshing];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        [[self.viewModel fetchMorePosts] subscribeNext:^(NSArray * posts) {
            UALog(@"fetch more");
            if (!posts.count) {
                [SVProgressHUD showErrorWithStatus:@"No more"];
            } else {
                NSMutableArray *mutablePins = [NSMutableArray arrayWithArray:self.viewModel.post];
                [mutablePins addObjectsFromArray:posts];
                self.viewModel.post = [mutablePins copy];
            }
            [self.tableView.infiniteScrollingView stopAnimating];
        } ];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView triggerInfiniteScrolling];
    });
    
    UIBarButtonItem * rightitem  = [[UIBarButtonItem alloc] init];
    [rightitem setTitle:@"info"];
    rightitem.style = UIBarButtonItemStyleDone;
    rightitem.rac_command = [self rightButtonCommand];
    self.navigationItem.rightBarButtonItem = rightitem;
}


#pragma mark - Accessors
- (RACCommand *) rightButtonCommand
{
    if (!_rightButtonCommand) {
        @weakify(self);
        _rightButtonCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                
                UIViewController <TKDetailsViewControllerProtocol>* viewController = [[JSObjection defaultInjector] getObject:@protocol(TKDetailsViewControllerProtocol)];
                [viewController configureWithModel:self.viewModel];
                viewController.title = @"target navi";
                [self.navigationController pushViewController:viewController animated:YES];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _rightButtonCommand;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewModel.active = YES;
}

- (void)titleCellWillShows:(TKFeedTitleInfoCell *) titleCell
{
    UIViewController <TKDetailsViewControllerProtocol>* viewController = [[JSObjection defaultInjector] getObject:@protocol(TKDetailsViewControllerProtocol)];
    viewController.title = titleCell.viewModel.posts.usernickname;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) reload
{
     UALog(@"array count :  %lu",(unsigned long)self.viewModel.post.count);
}

- (void)configureWithTimestamp:(unsigned long long) timestamp
{
    self.viewModel.timestamp = timestamp;
}

- (void)configureWithLatest
{
    self.viewModel.timestamp = 1399720005939;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
