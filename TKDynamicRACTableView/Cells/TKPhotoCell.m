//
//  TKPhotoCell.m
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "TKPhotoCell.h"
#import <UIColor+Expanded.h>
#import "UIView+Layout.h"
#import "UIImageView+Masking.h"
#import "TKPhotoCellViewModel.h"
#import <RACEXTScope.h>
#import <UIImageView+WebCache.h>
#import "TKPost.h"
#import <UALogger.h>


@implementation TKPhotoCell

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

- (id)initConfigureWithViewModel:(TKPhotoCellViewModel *)viewModel reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView * imageview = [[UIImageView alloc] init];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
//        imageview.backgroundColor = [UIColor randomHSBColor];
        imageview.frame = CGRectMake(10, 5, 300, 300);
        imageview.tag = 1;
        imageview.clipsToBounds = YES;
        [self.contentView addSubview:imageview];
//        imageview.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.viewModel = viewModel;
        
        self.postImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.postImageButton.frame = imageview.frame;
        [self.contentView addSubview:self.postImageButton];
        
    }
    
    return self;
}


-(void)setViewModel:(TKPhotoCellViewModel *)viewModel
{
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
        UIImageView * imageview = [self.contentView subviewWithTag:1];

        NSURL *imageURL = [NSURL URLWithString:[viewModel.posts imageURLWithmoment:@""]]; 
        @weakify(imageview)
         @weakify(self);
        [imageview setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"photo_browser"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            @strongify(self);
            [self log];
            @strongify(imageview)
            if (cacheType != SDImageCacheTypeMemory) {
                imageview.alpha = 0;
                [UIView animateWithDuration:0.25 animations:^{
                    imageview.alpha = 1;
                }];
            }
        }];

    }
}

-(void) log
{
    UALogFull(@"");
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
