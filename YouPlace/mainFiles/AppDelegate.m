//
//  AppDelegate.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 25/07/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

#import <Parse/Parse.h>
#import "Utils.h"
#import "DataManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    UINavigationController* navRoot = [[UINavigationController alloc]initWithRootViewController:self.viewController];
    navRoot.navigationBar.translucent = NO;
    self.window.rootViewController = navRoot;
    [self.window makeKeyAndVisible];
    if ([self.viewController isKindOfClass:[MainViewController class]]) {
        MainViewController *ptController = (MainViewController *)self.viewController;
        [DataManager initializeDataManagementWithOptions:launchOptions inMainController:ptController];
    }

    [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
  
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    __block UIBackgroundTaskIdentifier timerUpdater = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:timerUpdater];
        timerUpdater = UIBackgroundTaskInvalid;
    } ];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    UIAlertView *notificationAlert = [[UIAlertView alloc] initWithTitle:@"Notification"    message:@"This local notification"
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [notificationAlert show];
    // NSLog(@"didReceiveLocalNotification");
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}
@end
