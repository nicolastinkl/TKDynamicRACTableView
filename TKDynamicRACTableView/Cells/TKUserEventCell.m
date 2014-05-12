//
//  TKUserEventCell.m
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "TKUserEventCell.h"
#import "UIButton+Bootstrap.h"
#import "TKUtilsMacro.h"
#import "UIView+Layout.h"
#import "TKUtilsMacro.h"
#import "TKPost.h"
#import "TKUserEventCellViewModel.h"
@implementation TKUserEventCell

- (id)initConfigureWithViewModel:(TKUserEventCellViewModel *)viewModel reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _viewModel = viewModel;
        UIButton * likebutton = [UIButton buttonWithType:UIButtonTypeCustom];        
        likebutton.frame = RectSetOriginWH(10 ,70.0f, 30.0f);
        UIImage * image = [UIImage imageNamed:@"detail_tab_ic_like_nor"];
        [likebutton setImage:image  forState:UIControlStateNormal];
//        likebutton.imageEdgeInsets = UIEdgeInsetsMake(3.0, - (image.size.width ) + 10, 0., 0.);
        
        UIButton * commentbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        commentbutton.frame = RectSetOriginWH(90+likebutton.left,70.0f, 30.0f);
        [commentbutton setImage:[UIImage imageNamed:@"detail_tab_ic_comment_nor"] forState:UIControlStateNormal];
        UIButton * sharebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        sharebutton.frame = RectSetOriginWH(160 +commentbutton.left,44.0f, 30.0f);
        [sharebutton setImage:[UIImage imageNamed:@"detail_tab_ic_retweet_nor"] forState:UIControlStateNormal];
        [likebutton sendMessageStyle];
        [commentbutton sendMessageStyle];
        [sharebutton sendMessageStyle];
        
        [self.contentView addSubview:likebutton];
        [self.contentView addSubview:commentbutton];
        [self.contentView addSubview:sharebutton];
        
        _likeImageButton = likebutton;
        _commentImageButton = commentbutton;
        _shareImageButton = sharebutton;
        
        [_likeImageButton setTitle:F(@"%ld", _viewModel.posts.likecount) forState:UIControlStateNormal];
        [_commentImageButton setTitle:F(@"%ld", _viewModel.posts.commentcount) forState:UIControlStateNormal];
     
        UILabel * labelLine = [[UILabel alloc] initWithFrame:RectSetOriginXYWH(0, 43, 320, .5)];
        labelLine.text = @"";
        labelLine.backgroundColor = [UIColor colorWithWhite:0.699 alpha:1.000];
        [self.contentView addSubview:labelLine];
    }
    return self;
}

-(void)setViewModel:(TKUserEventCellViewModel *)viewModel
{
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
        
        [_likeImageButton setTitle:F(@"%ld", _viewModel.posts.likecount) forState:UIControlStateNormal];
        [_commentImageButton setTitle:F(@"%ld", _viewModel.posts.commentcount) forState:UIControlStateNormal];
       
        
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
}



- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
