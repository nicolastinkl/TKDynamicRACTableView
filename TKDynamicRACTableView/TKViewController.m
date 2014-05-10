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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
        if (posts.count > 0) {
                     
        }
        @strongify(self);
        [self reload];
    }];
    
    unsigned long long time  = [[NSDate date] timeIntervalSince1970];
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
     UALog(@"array count :  %lu",self.viewModel.post.count);
}

- (void)configureWithTimestamp:(unsigned long long) timestamp
{
    self.viewModel.timestamp = timestamp;
}

- (void)configureWithLatest
{
        self.viewModel.timestamp = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
