//
//  MLTapGrayView.m
//  RefreshTable
//
//  Created by Molon on 13-11-13.
//  Copyright (c) 2013年 Molon. All rights reserved.
//

#import "MLTapGrayView.h"

@interface MLTapGrayView()

@property (nonatomic,strong) UIColor *origBackColor;

@end

@implementation MLTapGrayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.exclusiveTouch = YES;
        self.multipleTouchEnabled = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.origBackColor = self.backgroundColor;
    self.backgroundColor = [UIColor colorWithRed:214.0f/255.0f green:218.0f/255.0f blue:227.0f/255.0f alpha:1];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = _origBackColor;
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = _origBackColor;
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

@end
