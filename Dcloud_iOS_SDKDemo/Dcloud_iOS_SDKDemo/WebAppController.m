//
//  WebAppController.m
//  Dcloud_iOS_SDKDemo
//
//  Created by liuhaiyuan on 16/8/9.
//  Copyright © 2016年 liuhaiyuan. All rights reserved.
//

#import "WebAppController.h"
#import "PDRToolSystem.h"
#import "PDRToolSystemEx.h"
#import "PDRCoreAppFrame.h"
#import "PDRCoreAppManager.h"
#import "PDRCoreAppWindow.h"
#import "PDRCoreAppInfo.h"
#import "WebViewController.h"
#import "NSFileManager+CompressExtract.h"

#define kStatusBarHeight 20.f

@interface WebAppController ()
{
    PDRCoreApp* pAppHandle;
}
@end

@implementation WebAppController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotiFunction:) name:@"SendDataToNative" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PDRCore *h5Engine = [PDRCore Instance];
    [self setStatusBarStyle:h5Engine.settings.statusBarStyle];
    // 获取当前是否是全屏
    _isFullScreen = [UIApplication sharedApplication].statusBarHidden;
    if ( _isFullScreen != h5Engine.settings.fullScreen ) {
        _isFullScreen = h5Engine.settings.fullScreen;
        if ( [self  respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)] ) {
            [self setNeedsStatusBarAppearanceUpdate];
        } else {
            [[UIApplication sharedApplication] setStatusBarHidden:_isFullScreen];
        }
    }
    
    //
    CGRect newRect = self.view.bounds;
    if ( [self reserveStatusbarOffset] && [PTDeviceOSInfo systemVersion] > PTSystemVersion6Series) {
        if ( !_isFullScreen ) {
            newRect.origin.y += kStatusBarHeight;
            newRect.size.height -= kStatusBarHeight;
        }
        _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, newRect.size.width, kStatusBarHeight+1)];
        _statusBarView.backgroundColor = h5Engine.settings.statusBarColor;
        _statusBarView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:_statusBarView];
    }
    _containerView = [[UIView alloc] initWithFrame:newRect];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    // 设置5+内核的Delegate，5+API在修改状态风格和应用是否全屏时会调用
    h5Engine.coreDeleagete = self;
    h5Engine.persentViewController = self;
    
    [self.view addSubview:_containerView];
    
    // 从沙盒目录中获取目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *savePath = [NSString stringWithFormat:@"%@/Pandora", docDirPath];
    NSString *filePath = [NSString stringWithFormat:@"%@/Pandora.zip", docDirPath];
    
    if([[NSFileManager defaultManager] extractFileAtPath:filePath toSavePath:savePath]) {
        
        NSString *indexPath = [NSString stringWithFormat:@"%@/Pandora/apps/HelloH5/www", docDirPath];
        
        if ([[PDRCore Instance] respondsToSelector:@selector(startAsAppClient)]) {
            [[PDRCore Instance] performSelector:@selector(startAsAppClient)];
        }
        
        // 设置5+SDK运行的View
        [[PDRCore Instance] setContainerView:_containerView];
        
        // 传入参数可以在页面中通过plus.runtime.arguments参数获取
        NSString* pArgus = @"id=plus.runtime.arguments";
        // 启动该应用
        NSString* pWWWPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Pandora/apps/HelloH5/www"];
        pAppHandle = [[[PDRCore Instance] appManager] openAppAtLocation:pWWWPath withIndexPath:@"index.html" withArgs:pArgus withDelegate:nil];
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SendDataToNative" object:nil];
}

#pragma mark 处理屏幕旋转
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventInterfaceOrientation
                            withObject:[NSNumber numberWithInt:toInterfaceOrientation]];
    if ([PTDeviceOSInfo systemVersion] >= PTSystemVersion8Series) {
        [[UIApplication sharedApplication] setStatusBarHidden:_isFullScreen ];
    }
}

- (BOOL)shouldAutorotate
{
    return TRUE;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [[PDRCore Instance].settings supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ( [PDRCore Instance].settings ) {
        return [[PDRCore Instance].settings supportsOrientation:interfaceOrientation];
    }
    return UIInterfaceOrientationPortrait == interfaceOrientation;
}

- (BOOL)prefersStatusBarHidden
{
    return _isFullScreen;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

-(BOOL)getStatusBarHidden {
    if ( [PTDeviceOSInfo systemVersion] > PTSystemVersion6Series ) {
        return _isFullScreen;
    }
    return [UIApplication sharedApplication].statusBarHidden;
}

#pragma mark  StatusBarStyle
// 修改状态栏风格
-(UIStatusBarStyle)getStatusBarStyle {
    return [self preferredStatusBarStyle];
}
-(void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    if ( _statusBarStyle != statusBarStyle ) {
        _statusBarStyle = statusBarStyle;
        if ( [self  respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)] ) {
            [self setNeedsStatusBarAppearanceUpdate];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return _statusBarStyle;
}

#pragma mark -
- (BOOL)reserveStatusbarOffset {
    return [PDRCore Instance].settings.reserveStatusbarOffset;
}

#pragma mark - StatusBarBackground iOS >=7.0
-(UIColor*)getStatusBarBackground {
    return _statusBarView.backgroundColor;
}

-(void)setStatusBarBackground:(UIColor*)newColor
{
    if ( newColor ) {
        _statusBarView.backgroundColor = newColor;
    }
}
#pragma mark DelegateFunction
// 切换当前Web应用是否是全屏显示
-(void)wantsFullScreen:(BOOL)fullScreen
{
    if ( _isFullScreen == fullScreen ) {
        return;
    }
    
    _isFullScreen = fullScreen;
    [[UIApplication sharedApplication] setStatusBarHidden:_isFullScreen withAnimation:_isFullScreen?NO:YES];
    if ( [PTDeviceOSInfo systemVersion] > PTSystemVersion6Series ) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    CGRect newRect = self.view.bounds;
    if ( [PTDeviceOSInfo systemVersion] <= PTSystemVersion6Series ) {
        newRect = [UIApplication sharedApplication].keyWindow.bounds;
        if ( _isFullScreen ) {
            [UIView beginAnimations:nil context:nil];
            self.view.frame = newRect;
            [UIView commitAnimations];
        } else {
            UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
            if ( UIDeviceOrientationLandscapeLeft == interfaceOrientation
                || interfaceOrientation == UIDeviceOrientationLandscapeRight ) {
                newRect.size.width -=kStatusBarHeight;
            } else {
                newRect.origin.y += kStatusBarHeight;
                newRect.size.height -=kStatusBarHeight;
            }
            [UIView beginAnimations:nil context:nil];
            self.view.frame = newRect;
            [UIView commitAnimations];
        }
        
    } else {
        if ( [self reserveStatusbarOffset] ) {
            _statusBarView.hidden = _isFullScreen;
            if ( !_isFullScreen ) {
                newRect.origin.y += kStatusBarHeight;
                newRect.size.height -= kStatusBarHeight;
            }
        }
        _containerView.frame = newRect;
    }
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventInterfaceOrientation
                            withObject:[NSNumber numberWithInt:0]];
}

- (void)didReceiveMemoryWarning{
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventReceiveMemoryWarning withObject:nil];
}

#pragma mark - FUNCTION NOTIFICATION
- (void)NotiFunction:(NSNotification*)pNoti
{
    if (pNoti) {
        NSString* pRecData = pNoti.object;
        if (pRecData) {
            NSLog(@"Native Receive Data:%@", pRecData);
            UIAlertView* pAlertView = [[UIAlertView alloc] initWithTitle:@"原生层收到消息" message:pRecData delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            if (pAlertView) {
                [pAlertView show];
            }
        }
    }
}


@end
