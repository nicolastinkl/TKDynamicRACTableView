//
//  UItitleView.m
//  Kidswant
//
//  Created by apple on 13-12-3.
//  Copyright (c) 2013年 xianchangjia. All rights reserved.
//

#import "UItitleView.h"

@implementation UItitleView
@synthesize viewcontr=_viewcontr;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)BackToPreViewClick:(id)sender {
    [self.viewcontr.navigationController popViewControllerAnimated:YES];
}

- (IBAction)UPloadViewClick:(id)sender {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
