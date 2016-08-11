//
//  WebAppController.h
//  Dcloud_iOS_SDKDemo
//
//  Created by liuhaiyuan on 16/8/9.
//  Copyright © 2016年 liuhaiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDRCore.h"
#import "PDRCoreAppWindow.h"

@interface WebAppController : UIViewController<PDRCoreDelegate,PDRCoreAppWindowDelegate>
{
    UIStatusBarStyle _statusBarStyle;
    BOOL _isFullScreen;
    UIView *_containerView;
    UIView *_statusBarView;
}

@property(nonatomic, retain)UIColor *defalutStausBarColor;
-(UIColor*)getStatusBarBackground;
@end
