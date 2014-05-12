//
//  TKCaptionCell.m
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "TKCaptionCell.h"
#import "TKAttributedLabel.h"
#import "TKPost.h"
#import <UALogger.h>
#import "TKCaptionCellViewModel.h"
#import "UIView+Layout.h"
#import "TKUtilsMacro.h"
#import <UIView+AutoLayout.h>
static CGFloat STXCaptionViewLeadingEdgeInset = 10.f;
static CGFloat STXCaptionViewTrailingEdgeInset = 10.f;

static NSString *HashTagAndMentionRegex = @"(#|@|##)(\\w+)";

@interface TKCaptionCell () <TTTAttributedLabelDelegate>

@property (strong, nonatomic) TKAttributedLabel *captionLabel;
@property (nonatomic) BOOL didSetupConstraints;
@end

@implementation TKCaptionCell

- (id)initWithCaption:(TKCaptionCellViewModel *)viewmodel reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _viewModel = viewmodel;
        
        _captionLabel = [self captionLabelWithText:_viewModel.posts.momentcontent];
        
        [self.contentView addSubview:_captionLabel];
        _captionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

-(void)setViewModel:(TKCaptionCellViewModel *)viewModel
{
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
        
        NSString *text = _viewModel.posts.momentcontent;
        [self setCaptionLabel:self.captionLabel text:text];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//    CGSize sizeToFit = [self.viewModel.posts.momentcontent sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
//#pragma clang diagnostic pop
//    self.captionLabel.frame = RectSetOriginXYWH(STXCaptionViewLeadingEdgeInset, 5,sizeToFit.width, sizeToFit.height);
    
//    [self.captionLabel sizeToFit];
//    self.captionLabel.backgroundColor = [UIColor colorWithWhite:0.756 alpha:1.000];
    
    self.captionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - (STXCaptionViewLeadingEdgeInset + STXCaptionViewTrailingEdgeInset);
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
        
        [self.captionLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, STXCaptionViewLeadingEdgeInset, 0, STXCaptionViewTrailingEdgeInset)];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}




#pragma mark - Attributed Label

- (void)setCaptionLabel:(TKAttributedLabel *)captionLabel text:(NSString *)text
{
    NSString *trimmedText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableArray *textCheckingResults = [NSMutableArray array];
    [captionLabel setText:trimmedText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSError *error;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:HashTagAndMentionRegex
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        if (error) {
            UALog(@"%@", error);
        }
        
        [regex enumerateMatchesInString:[mutableAttributedString string] options:0 range:NSMakeRange(0, [mutableAttributedString length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            [textCheckingResults addObject:result];
        }];
        
        return mutableAttributedString;
    }];
    
    for (NSTextCheckingResult *result in textCheckingResults) {
        [captionLabel addLinkWithTextCheckingResult:result];
    }
}

- (TKAttributedLabel *)captionLabelWithText:(NSString *)text
{
    TKAttributedLabel *captionLabel = [[TKAttributedLabel alloc] initForParagraphStyleWithText:text];
    captionLabel.font = [UIFont systemFontOfSize:16.0f];
    captionLabel.tag = 1;
    captionLabel.textColor = [UIColor blackColor];
    captionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    captionLabel.numberOfLines = 0;
    captionLabel.delegate = self;
    captionLabel.userInteractionEnabled = YES;
    
    captionLabel.linkAttributes = @{ (NSString *)kCTForegroundColorAttributeName: [UIColor colorWithRed:0.288 green:0.664 blue:1.000 alpha:1.000], (NSString *)kCTFontAttributeName: [UIFont boldSystemFontOfSize:16],
                                     (NSString *)kCTUnderlineStyleAttributeName : @(kCTUnderlineStyleNone) };
    //    captionLabel.activeLinkAttributes = captionLabel.linkAttributes;
    
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor colorWithRed:0.644 green:0.681 blue:0.702 alpha:1.000] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:1.0f] forKey:(NSString *)kTTTBackgroundLineWidthAttributeName];
    captionLabel.activeLinkAttributes = mutableActiveLinkAttributes;
    captionLabel.highlightedTextColor = [UIColor lightGrayColor];
    [self setCaptionLabel:captionLabel text:text];
    
    return captionLabel;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result
{
    NSString *hashtagOrMention = [[label.attributedText string] substringWithRange:result.range];
    UALog(@"%@", hashtagOrMention);
    
    if ([hashtagOrMention hasPrefix:@"#"]) {
        NSString *hashtag = [hashtagOrMention substringFromIndex:1];
        
        if ([self.delegate respondsToSelector:@selector(captionCell:didSelectHashtag:)]) {
            [self.delegate captionCell:self didSelectHashtag:hashtag];
        }
    } else if ([hashtagOrMention hasPrefix:@"@"]) {
        NSString *mention = [hashtagOrMention substringFromIndex:1];
        
        if ([self.delegate respondsToSelector:@selector(captionCell:didSelectMention:)]) {
            [self.delegate captionCell:self didSelectMention:mention];
        }
    }
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
