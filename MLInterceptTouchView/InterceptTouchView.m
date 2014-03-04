//
//  InterceptTouchView.m
//  RefreshTable
//
//  Created by Molon on 13-11-14.
//  Copyright (c) 2013年 Molon. All rights reserved.
//

#import "InterceptTouchView.h"

@implementation InterceptTouchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return self;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
   
    //如果被检测截获了，就返回自身，否则返回默认处理结果的view
    if (_interceptTouchViewDelegate&&[_interceptTouchViewDelegate respondsToSelector:@selector(interceptTouchWithView:)]&&[_interceptTouchViewDelegate interceptTouchWithView:view]) {
            return view; //实际测试 此处达不到截获效果，只能做监视。 return self也不行。暂时不影响，不处理
    }
    
    return view;
}


@end
