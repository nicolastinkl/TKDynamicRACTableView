//
//  TKLikeCell.m
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "TKLikeCell.h"
#import <TTTAttributedLabel.h>
#import "UIView+Layout.h"
#import <UIView+AutoLayout.h>
#import "TKLike.h"
#import "TKPost.h"
#import "TKLikeCellViewModel.h"
#import <UALogger.h>

static CGFloat STXLikesViewLeadingEdgeInset = 10.f;
static CGFloat STXLikesViewTrailingEdgeInset = 10.f;

@interface TKLikeCell () <TTTAttributedLabelDelegate>

@property (nonatomic) BOOL didSetupConstraints;

@property (nonatomic) STXLikesCellStyle cellStyle;
@property (strong, nonatomic) TTTAttributedLabel *likesLabel;

@end

@implementation TKLikeCell

- (instancetype)initWithStyle:(STXLikesCellStyle)style likes:(TKLikeCellViewModel *)viewModel reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _viewModel = viewModel;
        _cellStyle = style;
        
        if (style == STXLikesCellStyleLikesCount) {
            NSInteger count = viewModel.posts.likecount;
            _likesLabel = [self likesLabelForCount:count];
        } else {
            NSArray *likers = viewModel.posts.likes;
            _likesLabel = [self likersLabelForLikers:likers];
        }
        
        [self.contentView addSubview:_likesLabel];
        _likesLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.likesLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - (STXLikesViewLeadingEdgeInset + STXLikesViewTrailingEdgeInset);
    
    [super layoutSubviews];
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        // Note: if the constraints you add below require a larger cell size
        // than the current size (which is likely to be the default size {320,
        // 44}), you'll get an exception.  As a fix, you can temporarily
        // increase the size of the cell's contentView so that this does not
        // occur using code similar to the line below.  See here for further
        // discussion:
        // https://github.com/Alex311/TableCellWithAutoLayout/commit/bde387b27e33605eeac3465475d2f2ff9775f163#commitcomment-4633188
        
        self.contentView.bounds = CGRectMake(0, 0, 99999, 99999);
        
        [self.likesLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, STXLikesViewLeadingEdgeInset, 0, STXLikesViewTrailingEdgeInset)];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}


-(void)setViewModel:(TKLikeCellViewModel *)viewModel
{
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
        
        NSInteger count = viewModel.posts.likecount;
        if (count > 2) {
            [self setLikesLabel:self.likesLabel count:count];
        } else {
            NSArray *likers = viewModel.posts.likes;
            [self setLikersLabel:self.likesLabel likers:likers];
        }
        
    }
}

#pragma mark - Attributed Label

- (void)setLikesLabel:(TTTAttributedLabel *)likesLabel count:(NSInteger)count
{
    NSString *countString = [@(count) stringValue];
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"%@ likes", nil), countString];
    likesLabel.text = title;
}

- (void)setLikersLabel:(TTTAttributedLabel *)likersLabel likers:(NSArray *)likers
{
    NSMutableString *likersString = [NSMutableString stringWithCapacity:0];
    NSUInteger likerIndex = 0;
    for (TKLike *likerName in likers) {
        if ([likerName.usernickname length] > 0) {
            if (likerIndex == 0)
                [likersString setString:likerName.usernickname];
            else
                [likersString appendFormat:NSLocalizedString(@",%@", nil), likerName.usernickname];
        }
        
        ++likerIndex;
    }
    
    if ([likersString length] > 0) {
        if ([likers count] == 1) {
            [likersString appendString:NSLocalizedString(@" likes", nil)];
        } else {
            [likersString appendString:NSLocalizedString(@" likes", nil)];
        }
    }
    
    NSMutableArray *textCheckingResults = [NSMutableArray array];
    
    NSString *likersText = [likersString copy];
    
    [likersLabel setText:likersText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        NSRange searchRange = NSMakeRange(0, [mutableAttributedString length]);
        for (TKLike *likerName in likers) {
            NSRange currentRange = [[mutableAttributedString string] rangeOfString:likerName.usernickname options:NSLiteralSearch range:searchRange];
            
            NSTextCheckingResult *result = [NSTextCheckingResult linkCheckingResultWithRange:currentRange URL:nil];
            [textCheckingResults addObject:result];
            
            searchRange = NSMakeRange(currentRange.length, [mutableAttributedString length] - currentRange.length);
        }
        
        return mutableAttributedString;
    }];
    
    
    for (NSTextCheckingResult *result in textCheckingResults)
        [likersLabel addLinkWithTextCheckingResult:result];
}

- (TTTAttributedLabel *)likesLabelForCount:(NSInteger)count
{
    TTTAttributedLabel *likesLabel = [TTTAttributedLabel newAutoLayoutView];
    likesLabel.textColor =  [UIColor colorWithRed:0.288 green:0.664 blue:1.000 alpha:1.000];
    
    likesLabel.delegate = self;
    
    [self setLikesLabel:likesLabel count:count];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLikers:)];
    [likesLabel addGestureRecognizer:recognizer];
    
    return likesLabel;
}

- (TTTAttributedLabel *)likersLabelForLikers:(NSArray *)likers
{
    TTTAttributedLabel *likersLabel = [TTTAttributedLabel newAutoLayoutView];
    likersLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    likersLabel.numberOfLines = 0;
    likersLabel.lineBreakMode = NSLineBreakByWordWrapping;
    likersLabel.delegate = self;
    
    likersLabel.linkAttributes = @{ (NSString *)kCTForegroundColorAttributeName: [UIColor colorWithRed:0.288 green:0.664 blue:1.000 alpha:1.000], (NSString *)kCTFontAttributeName: [UIFont boldSystemFontOfSize:16],
                                     (NSString *)kCTUnderlineStyleAttributeName : @(kCTUnderlineStyleNone) };
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor colorWithRed:0.644 green:0.681 blue:0.702 alpha:1.000] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:1.0f] forKey:(NSString *)kTTTBackgroundLineWidthAttributeName];
    likersLabel.activeLinkAttributes = mutableActiveLinkAttributes;
    likersLabel.highlightedTextColor = [UIColor lightGrayColor];
    [self setLikersLabel:likersLabel likers:likers];
    
    return likersLabel;
}

#pragma mark - Actions

- (void)showLikers:(id)sender
{
    UALog(@"showLikers");
    if ([self.delegate respondsToSelector:@selector(likesCellWillShowLikes:)])
        [self.delegate likesCellWillShowLikes:self];
}

#pragma mark - Attributed Label

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result
{
    NSString *string = [[label.attributedText string] substringWithRange:result.range];
    UALog(@"%@", string);
    
    if ([self.delegate respondsToSelector:@selector(likesCellDidSelectLiker:)])
        [self.delegate likesCellDidSelectLiker:string];
}


@end
