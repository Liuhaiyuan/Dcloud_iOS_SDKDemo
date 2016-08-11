//
//  PGPluginTest.h
//  Dcloud_iOS_SDKDemo
//
//  Created by liuhaiyuan on 16/8/10.
//  Copyright © 2016年 liuhaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGPlugin.h"

@class PGMethod;

@interface PGPluginTest : PGPlugin

- (NSData*)PluginTestFunctionSync:(PGMethod*)command;
- (void)PluginTestFunctionArrayArgu:(PGMethod*)commands;

- (void)PluginTestFunction:(PGMethod*)command;

- (NSData*)PluginTestFunctionSyncArrayArgu:(PGMethod*)command;

@end
