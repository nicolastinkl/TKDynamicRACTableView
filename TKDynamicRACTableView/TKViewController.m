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

@interface TKViewController ()
@property (nonatomic) TKViewControllerModel *viewModel;

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
    
    @weakify(self);
    [RACObserve(self, viewModel.post) subscribeNext:^(NSArray * posts) {
        @strongify(self);
        [self reload];
    }];
    
    unsigned long long time  = [[NSDate date] timeIntervalSince1970]* 1000;
    
    NSLog(@"currentTimeMillis = %llu", time);
    
    [[self.viewModel fetchPostsWithTimestamp:time offset:10] subscribeNext:^(NSArray *pins) {
        UALogFull(@"fetch ok");
        self.viewModel.post = pins;
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewModel.active = YES;
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
