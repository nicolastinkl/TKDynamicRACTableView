//
//  TKDetailsViewControllerModule.m
//  TKDynamicRACTableView
//
//  Created by tinkl on 12/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "TKDetailsViewControllerModule.h"
#import <Objection.h>
#import "TKDetailsViewController.h"
#include "TKProtocol.h"

@implementation TKDetailsViewControllerModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TKDetailsViewController class] toProtocol:@protocol(TKDetailsViewControllerProtocol)];
}


@end
