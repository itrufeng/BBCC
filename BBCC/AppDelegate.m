//
//  AppDelegate.m
//  BBCC
//
//  Created by Jian Zhang on 7/15/15.
//  Copyright © 2015 Steve (Zhang Jian). All rights reserved.
//

#import "AppDelegate.h"
#import "Check.h"

@interface AppDelegate ()

@property (strong, nonatomic) Check *check;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initData];
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil]];
    _check = [[Check alloc] init];
    [_check check];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"COME" object:nil userInfo:notification.userInfo];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"COME" object:nil userInfo:notification.userInfo];
    completionHandler();
}

- (void)initData {
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"HOST"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"10.117.100.133:3000" forKey:@"HOST"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)host {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"HOST"];
}

- (void)saveHost:(NSString *)host {
    [[NSUserDefaults standardUserDefaults] setObject:host forKey:@"HOST"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
