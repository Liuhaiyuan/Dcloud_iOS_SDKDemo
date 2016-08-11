//
//  AppDelegate.m
//  Dcloud_iOS_SDKDemo
//
//  Created by liuhaiyuan on 16/8/8.
//  Copyright © 2016年 liuhaiyuan. All rights reserved.
//

#import "AppDelegate.h"
#import "PDRCore.h"
#import "PDRCommonString.h"
#import "NSFileManager+CompressExtract.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UINavigationController* pNavCon = [[UINavigationController alloc]
                                       initWithRootViewController:_window.rootViewController];
    _window.rootViewController = pNavCon;
    
    // 程序刚启动时，进行文件的压缩和移动
    NSString* pWWWPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Pandora"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *filePath = [NSString stringWithFormat:@"%@/Pandora.zip", docDirPath];
    [[NSFileManager defaultManager] commpressFileAtPath:pWWWPath to:filePath];
     
    // 设置当前SDK运行模式
    return [PDRCore initEngineWihtOptions:launchOptions withRunMode:PDRCoreRunModeWebviewClient];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventEnterBackground withObject:nil];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventEnterForeGround withObject:nil];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark URL

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    [self application:application handleOpenURL:url];
    return YES;
}

/*
 * @Summary:程序被第三方调用，传入参数启动
 *
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventOpenURL withObject:url];
    return YES;
}

@end
