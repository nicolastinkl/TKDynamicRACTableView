//
//  TKComentCell.m
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "TKComentCell.h"
#import "TKAttributedLabel.h"
#import "TKComment.h"
#import "TKComentCellViewModel.h"
#import <UIView+AutoLayout.h>
#import <UALogger.h>
#import "TKUtilsMacro.h"

static CGFloat STXCommentViewLeadingEdgeInset = 10.f;
static CGFloat STXCommentViewTrailingEdgeInset = 10.f;

static NSString *HashTagAndMentionRegex = @"(#|@)(\\w+)";

@interface TKComentCell ()<TTTAttributedLabelDelegate>

@property (nonatomic) STXCommentCellStyle cellStyle;
@property (strong, nonatomic) TKAttributedLabel *commentLabel;

@property (nonatomic) BOOL didSetupConstraints;

@end

@implementation TKComentCell

- (id)initWithStyle:(STXCommentCellStyle)style comment:(TKComentCellViewModel *)viewmodel totalComments:(NSInteger)totalComments reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellStyle = style;
        
        if (style == STXCommentCellStyleShowAllComments) {
            NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Show %d comments", nil), totalComments];
            _commentLabel = [self allCommentsLabelWithTitle:title];
        } else {
            _viewModel = viewmodel;
            NSString * comment = F(@"@%@: %@",_viewModel.comments.usernickname,_viewModel.comments.commentcontent);
            _commentLabel = [self commentLabelWithText:comment commenter:@""];
        }
        
        [self.contentView addSubview:_commentLabel];
        _commentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (instancetype)initWithStyle:(STXCommentCellStyle)style comment:(TKComentCellViewModel *)viewmodel reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:style comment:viewmodel totalComments:0 reuseIdentifier:reuseIdentifier];
}

- (instancetype)initWithStyle:(STXCommentCellStyle)style totalComments:(NSInteger)totalComments reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:style comment:nil totalComments:totalComments reuseIdentifier:reuseIdentifier];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.commentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - (STXCommentViewLeadingEdgeInset + STXCommentViewTrailingEdgeInset);
    
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
        
        [self.commentLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, STXCommentViewLeadingEdgeInset, 0, STXCommentViewTrailingEdgeInset)];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}



-(void)setViewModel:(TKComentCellViewModel *)viewModel
{
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
        
         NSString * comment = F(@"@%@: %@",_viewModel.comments.usernickname,_viewModel.comments.commentcontent);
        
        [self setCommentLabel:self.commentLabel text:comment commenter:@""];
    }
}

- (void)setTotalComments:(NSInteger)totalComments
{
    if (_totalComments != totalComments) {
        NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Show %d comments", nil), totalComments];
        [self setAllCommentsLabel:self.commentLabel title:title];
    }
}

#pragma mark - Attributed Label

- (void)setAllCommentsLabel:(TKAttributedLabel *)commentLabel title:(NSString *)title
{
    [commentLabel setText:title];
}

- (void)setCommentLabel:(TKAttributedLabel *)commentLabel text:(NSString *)text commenter:(NSString *)commenter
{
    NSMutableArray *textCheckingResults = [NSMutableArray array];
    [commentLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange searchRange = NSMakeRange(0, [mutableAttributedString length]);
        
        NSRange currentRange = [[mutableAttributedString string] rangeOfString:commenter options:NSLiteralSearch range:searchRange];
        NSTextCheckingResult *textCheckingResult = [NSTextCheckingResult linkCheckingResultWithRange:currentRange URL:nil];
        [textCheckingResults addObject:textCheckingResult];
        
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
        [commentLabel addLinkWithTextCheckingResult:result];
    }
}

- (TKAttributedLabel *)allCommentsLabelWithTitle:(NSString *)title
{
    TKAttributedLabel *allCommentsLabel = [TKAttributedLabel newAutoLayoutView];
    allCommentsLabel.delegate = self;
    allCommentsLabel.textColor = [UIColor lightGrayColor];
    allCommentsLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    
    allCommentsLabel.linkAttributes = @{ (NSString *)kCTFontAttributeName: allCommentsLabel.font,
                                         (NSString *)kCTForegroundColorAttributeName: allCommentsLabel.textColor};
    allCommentsLabel.activeLinkAttributes = allCommentsLabel.linkAttributes;
    allCommentsLabel.inactiveLinkAttributes = allCommentsLabel.linkAttributes;
    [allCommentsLabel setText:title];
    
    NSTextCheckingResult *textCheckingResult = [NSTextCheckingResult linkCheckingResultWithRange:NSMakeRange(0, [title length]) URL:nil];
    [allCommentsLabel addLinkWithTextCheckingResult:textCheckingResult];
    
    return allCommentsLabel;
}

- (TKAttributedLabel *)commentLabelWithText:(NSString *)nick commenter:(NSString *)commenter
{
    NSString *trimmedText = [nick stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString *commentText = [[trimmedText stringByAppendingString:@": "] stringByAppendingString:commenter];
    TKAttributedLabel *commentLabel = [[TKAttributedLabel alloc] initForParagraphStyleWithText:commentText];
    commentLabel.delegate = self;
    commentLabel.numberOfLines = 0;
    commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    commentLabel.linkAttributes = @{ (NSString *)kCTForegroundColorAttributeName: [UIColor colorWithRed:0.288 green:0.664 blue:1.000 alpha:1.000] };
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor colorWithRed:0.644 green:0.681 blue:0.702 alpha:1.000] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:1.0f] forKey:(NSString *)kTTTBackgroundLineWidthAttributeName];
    commentLabel.activeLinkAttributes = mutableActiveLinkAttributes;
    commentLabel.highlightedTextColor = [UIColor lightGrayColor];
    
    
    
    [self setCommentLabel:commentLabel text:nick commenter:commenter];
    
    return commentLabel;
}

- (void)showAllComments:(id)sender
{
    UALogFull(@"");
    if ([self.delegate respondsToSelector:@selector(commentCellWillShowAllComments:)])
        [self.delegate commentCellWillShowAllComments:self];
}

#pragma mark - Attributed Label

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result
{
    NSString *selectedText = [[label.attributedText string] substringWithRange:result.range];
    UALog(@"%@", selectedText);
    
    if ([selectedText hasPrefix:@"http://"] || [selectedText hasPrefix:@"https://"]) {
        NSURL *selectedURL = [NSURL URLWithString:selectedText];
        
        if (selectedURL) {
            if ([self.delegate respondsToSelector:@selector(commentCell:didSelectURL:)]) {
                [self.delegate commentCell:self didSelectURL:selectedURL];
            }
            return;
        }
    } else if ([selectedText hasPrefix:@"#"]) {
        NSString *hashtag = [selectedText substringFromIndex:1];
        
        if ([self.delegate respondsToSelector:@selector(commentCell:didSelectHashtag:)]) {
            [self.delegate commentCell:self didSelectHashtag:hashtag];
        }
    } else if ([selectedText hasPrefix:@"@"]) {
        NSString *mention = [selectedText substringFromIndex:1];
        
        if ([self.delegate respondsToSelector:@selector(commentCell:didSelectMention:)]) {
            [self.delegate commentCell:self didSelectMention:mention];
        }
    }
    
    if (self.cellStyle == STXCommentCellStyleShowAllComments) {
        [self showAllComments:label];
    } else {
        if ([self.delegate respondsToSelector:@selector(commentCell:willShowCommenter:)]) {
            [self.delegate commentCell:self willShowCommenter:self.viewModel];
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
