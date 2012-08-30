//
//  AppDelegate.m
//  TCPServer
//
//  Created by Lin Chuankai on 8/30/12.
//  Copyright (c) 2012 KILAB. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TCPServer.h"
#import <Foundation/Foundation.h>

@implementation AppDelegate
{
    TCPServer *server;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    [self startTCPServer];
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
    [self stopTCPServer];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self startTCPServer];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self stopTCPServer];
}

- (void)startTCPServer
{
    server = [[TCPServer alloc] init];
    [server startWithPort:33350 UsingBlock:^(NSInputStream *stream){
        uint8_t buf[1];
        NSInteger len;
        len = [(NSInputStream *)stream read:buf maxLength:1];
        if (len) {
            NSLog(@"Input: %c", buf[0]);
        }
    }];
}

- (void)stopTCPServer
{
    [server stop];
}

@end
