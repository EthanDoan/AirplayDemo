//
//  AppDelegate.m
//  AirPlayDemo
//
//  Created by Doan Phuong on 2/6/17.
//  Copyright © 2017 Phuong Doan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"111");
    NSLog(@"222");
    NSLog(@"222 - 2");
    
    
    NSLog(@"333 - 1");
    NSLog(@"333 - 2");
    NSLog(@"333 - 3");

    NSLog(@"444");

    NSLog(@"555");
    
    NSLog(@"666");
    
    NSLog(@"999");

    NSLog(@"10");
    
    NSLog(@"p1 - edited");

    NSLog(@"p2");
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"master cm");
    NSLog(@"4444 interrupt");
    
    NSLog(@"5555 interrupt");

    NSLog(@"6666 interrupt");
    
    NSLog(@"888 interrupt");

    NSLog(@"999 interrupt");
    
    NSLog(@"10 in");

    NSLog(@"p1_in");
    
    NSLog(@"p2_in");
    
    NSLog(@"p2_in_in");


    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
