//
//  AppDelegate.m
//  VChat
//
//  Created by George Chen on 1/22/14.
//  Copyright (c) 2014 George Chen. All rights reserved.
//

#import "AppDelegate.h"
#import "VChatViewController.h"
#import "NearbyTableViewController.h"
#import "MyProfileViewController.h"
#import "ContactsTableViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Override point for customization after application launch
    
    //Parse setup
    [Parse setApplicationId:@"uuoLCIDzvZ9Fe0XQh22gdDP8rViouZ0n4VtZatnT"
                  clientKey:@"vrg6u72H3S6dGV4ty1t18ywQdSiuMGqxL9294ZU9"];
    
    [PFFacebookUtils initializeFacebook];
    
    //test Parse 
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"foo"] = @"bar";
//    [testObject saveInBackground];
    
    VChatViewController *vc = [[VChatViewController alloc] init];
    UINavigationController *nvc1 = [[UINavigationController alloc] initWithRootViewController:vc];
    
    ContactsTableViewController *cc = [[ContactsTableViewController alloc] init];
    UINavigationController *nvc2 = [[UINavigationController alloc] initWithRootViewController:cc];
    
    NearbyTableViewController *nb = [[NearbyTableViewController alloc] init];
    UINavigationController *nvc3 = [[UINavigationController alloc] initWithRootViewController:nb];
    
    MyProfileViewController *pv = [[MyProfileViewController alloc] init];
    UINavigationController *nvc4 = [[UINavigationController alloc] initWithRootViewController:pv];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[nvc1, nvc2, nvc3, nvc4];
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];

    tabBarItem1.title = @"Recent";
    tabBarItem2.title = @"Contacts";
    tabBarItem3.title = @"Nearby";
    tabBarItem4.title = @"My Profile";
    
    tabBarItem1.image = [UIImage imageNamed:@"ChatIcon"];
    tabBarItem2.image = [UIImage imageNamed:@"ContactsIcon"];
    tabBarItem3.image = [UIImage imageNamed:@"NearbyIcon"];
    tabBarItem4.image = [UIImage imageNamed:@"ProfileIcon"];
    
    // Change color of tabBar and navigationBar
    tabBarController.tabBar.backgroundColor = RGB2UIColor(158, 135, 193);
    [[UINavigationBar appearance] setBarTintColor:RGB2UIColor(175, 158, 227)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
    self.window.rootViewController = tabBarController;

    
    //self.window.rootViewController = nvc;
    
    //self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
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

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
