//
//  LFAppDelegate.m
//  LaFosca
//
//  Created by Marc Llucià on 08/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import "LFAppDelegate.h"
#import "LFLoginViewController.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation LFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self warmUpRootController];
    [self customizeAppearance];
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) warmUpRootController
{
    LFLoginViewController* loginViewController = [[LFLoginViewController alloc] initWithNibName:nil bundle:nil];
    [loginViewController.view setBackgroundColor:BASE_COLOR];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void) customizeAppearance
{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:18],
                                NSFontAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
