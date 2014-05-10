//
//  TKViewControllerModule.m
//  TKDynamicRACTableView
//
//  Created by tinkl on 10/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "TKViewControllerModule.h"
#import <Objection.h>
#import "TKViewController.h"
#import "TKProtocol.h"

@implementation TKViewControllerModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TKViewController class] toProtocol:@protocol(TKViewControllerProtocol)];
}

@end
