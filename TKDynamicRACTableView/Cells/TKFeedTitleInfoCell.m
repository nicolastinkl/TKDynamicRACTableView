//
//  TKFeedTitleInfoCell.m
//  TKDynamicRACTableView
//
//  Created by tinkl on 10/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "TKFeedTitleInfoCell.h"
#import "UIImageView+Masking.h"
#import <ReactiveCocoa.h>
#import <UIButton+AFNetworking.h>
#import "UIImageView+Masking.h"
#import "TKUtilsMacro.h"
#import "TKFeedTitleInfoCellViewModel.h"
#import "TKPost.h"
#import "TKCategroiesTool.h"
#import <MHPrettyDate.h>

@interface TKFeedTitleInfoCell ()

@property (weak, nonatomic) IBOutlet UIButton *avaterImageButton;
@property (weak, nonatomic) IBOutlet UILabel *profileNickLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation TKFeedTitleInfoCell

- (void)awakeFromNib
{
    // Initialization code
    
    self.avaterImageButton.clipsToBounds = YES;
    [TKCategroiesTool addCircleMask:self.avaterImageButton];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithViewModel:(TKFeedTitleInfoCellViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    //CMD
    self.avaterCommant = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty]; // target
        
    }];
    /* // -executionSignals returns a signal that includes the signals returned from
     // the above block, one for each time the command is executed.
     [_oKComment.executionSignals subscribeNext:^(RACSignal *loginSignal) {
     // Log a message whenever we log in successfully.
     [loginSignal subscribeCompleted:^{
     NSLog(@"Logged in successfully!");
     }];
     }];
     
     
     [_oKComment.executing subscribeNext:^(RACSignal *loginSignal) {
     // Log a message whenever we log in successfully.
     //        loginSignal subscribe:(id<RACSubscriber>)
     NSLog(@"Logged in executing!");
     }];*/
    [self.avaterImageButton setRac_command:self.avaterCommant];
    
//    [self.avaterImageButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:F(@"%@",[self.viewModel.posts imageURLWithmoment:@"avater"])] placeholderImage:[UIImage imageNamed:@"avater"]];
    self.profileNickLabel.text = F(@"%@",self.viewModel.posts.usernickname);
    
    self.dateLabel.textColor = [UIColor colorWithWhite:0.595 alpha:0.860];
    self.dateLabel.text = [MHPrettyDate prettyDateFromDate:[NSDate dateWithTimeIntervalSince1970:self.viewModel.posts.timestamp] withFormat:MHPrettyDateShortRelativeTime];
    
}


@end
