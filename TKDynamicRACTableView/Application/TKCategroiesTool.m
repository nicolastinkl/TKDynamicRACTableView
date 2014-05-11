//
//  TKCategroiesTool.m
//  TKDynamicRACTableView
//
//  Created by tinkl on 11/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "TKCategroiesTool.h"

@implementation TKCategroiesTool

+ (void)addCircleMask:(UIView * ) view
{
    view.clipsToBounds = YES;
    
    view.backgroundColor = [UIColor colorWithWhite:0.871 alpha:1.000];
    view.contentMode = UIViewContentModeScaleAspectFill;
    view.layer.cornerRadius = CGRectGetWidth(view.bounds)/2;
    view.layer.masksToBounds = YES;
}
@end
