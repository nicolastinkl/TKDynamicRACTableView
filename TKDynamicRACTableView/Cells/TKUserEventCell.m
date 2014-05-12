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

@implementation TKUserEventCell

- (id)initConfigureWithViewModel:(TKUserEventCellViewModel *)viewModel reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIButton * likebutton = [UIButton buttonWithType:UIButtonTypeCustom];        
        likebutton.frame = RectSetOriginWH(20 ,60.0f, 24.0f);
        UIButton * commentbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        commentbutton.frame = RectSetOriginWH(80+likebutton.left,60.0f, 24.0f);
        UIButton * sharebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        sharebutton.frame = RectSetOriginWH(80 +commentbutton.left,60.0f, 24.0f);
        [likebutton sendMessageStyle];
        [commentbutton sendMessageStyle];
        [sharebutton sendMessageStyle];
        
        [self.contentView addSubview:likebutton];
        [self.contentView addSubview:commentbutton];
        [self.contentView addSubview:sharebutton];
        
        _likeImageButton = likebutton;
        _commentImageButton = commentbutton;
        _shareImageButton = sharebutton;
        
        [_likeImageButton setTitle:@"like" forState:UIControlStateNormal];
        [_commentImageButton setTitle:@"Com" forState:UIControlStateNormal];
        [_shareImageButton setTitle:@"share" forState:UIControlStateNormal];
        
        self.viewModel = viewModel;
    }
    return self;
}

-(void)setViewModel:(TKUserEventCellViewModel *)viewModel
{
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
        
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
