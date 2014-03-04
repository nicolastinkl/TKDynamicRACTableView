//
//  InterceptTouchView.h
//  RefreshTable
//
//  Created by Molon on 13-11-14.
//  Copyright (c) 2013年 Molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InterceptTouchViewDelegate <NSObject>

- (BOOL)interceptTouchWithView:(UIView *)view;

@end

@interface InterceptTouchView : UIView

@property (nonatomic,weak) id<InterceptTouchViewDelegate> interceptTouchViewDelegate;

@end
