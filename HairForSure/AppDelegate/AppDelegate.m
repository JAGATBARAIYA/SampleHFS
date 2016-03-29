
//
//  AppDelegate.m
//  HairForSure
//
//  Created by Manish on 25/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "AppDelegate.h"
#import "Day.h"
#import "ViewController.h"
#import "Helper.h"
#import "AlertViewController.h"
#import "DEMORootViewController.h"
#import "DEMONavigationController.h"
#import "REFrostedViewController.h"
#import "SSKeychain.h"
#import "SettingViewController.h"
#import "ReminderViewController.h"
#import "WebClient.h"
#import "SIAlertView.h"
#import "Harpy.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#define kAppID          @"1031857883"
#define kAppName        @"Hair For Sure"

@interface AppDelegate ()<HarpyDelegate>

@end

@implementation AppDelegate
@synthesize strTag;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }

    [Fabric with:@[[Crashlytics class]]];

    _arrOfWeeks = nil;
    _arrOfWeeks = [[NSMutableArray alloc]init];
    _strDeviceToken = @"";
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:kLocalNotification])
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLocalNotification];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:kPushNotification])
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kPushNotification];
    
    
    NSString *appName = @"Hair For Sure";
    _strApplicationUUID = [SSKeychain passwordForService:appName account:@"incoding"];
    if (_strApplicationUUID == nil)
    {
        _strApplicationUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SSKeychain setPassword:_strApplicationUUID forService:appName account:@"incoding"];
    }
    
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:kDeviceTokenKey]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kDeviceTokenKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isNextTime"])
        [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"isNextTime"];

    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"AppVersion"])
        [[NSUserDefaults standardUserDefaults] setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"] forKey:@"AppVersion"];
    else
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isNextTime"] isEqualToString:@"false"])
            [[NSUserDefaults standardUserDefaults] setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"] forKey:@"AppVersion"];
    }
    
    [self getAppVersion];

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
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isNextTime"])
        [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"isNextTime"];

    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"AppVersion"])
        [[NSUserDefaults standardUserDefaults] setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"] forKey:@"AppVersion"];
    else
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isNextTime"] isEqualToString:@"false"])
            [[NSUserDefaults standardUserDefaults] setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"] forKey:@"AppVersion"];
    }

    [self getAppVersion];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)registerForRemoteNotifications:(UIApplication*)application{
    if([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound|UIUserNotificationTypeAlert|UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    } else {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound)];
    }
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *strDevicetoken = [[NSString alloc]initWithFormat:@"%@",[[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSLog(@"devicetoken = %@",strDevicetoken);
    
    [[NSUserDefaults standardUserDefaults] setObject:strDevicetoken forKey:kDeviceTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _strDeviceToken = strDevicetoken;
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
    _strDeviceToken = @"428c17bacc54799d60a104f840b64289e2b95f26771437b756353611386756f9";
    NSLog(@"Error %@",error.localizedDescription);
}

#ifdef isAtLeastiOS8
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler{
    if ([identifier isEqualToString:@"declineAction"]){
    } else if ([identifier isEqualToString:@"answerAction"]){
    }
}

#endif

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif{
    if (application.applicationState == UIApplicationStateInactive )
    {
        NSLog(@"app not running");
        [self localNotificationPushViewController];
    }
    else if(application.applicationState == UIApplicationStateActive )
    {
        NSLog(@"app running");
    }else if(application.applicationState == UIApplicationStateBackground){
        NSLog(@"back running");
        [self localNotificationPushViewController];
    }
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:nil];

    UIViewController *parentController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (parentController.presentedViewController !=nil)
        parentController = parentController.presentedViewController;
    
    UIViewController *currentController = parentController;
    DEMONavigationController *demoNavigationControl = [currentController.childViewControllers firstObject];
    
    AlertViewController *alertViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AlertViewController"];
    demoNavigationControl.viewControllers = @[alertViewController];
    parentController.frostedViewController.contentViewController = demoNavigationControl;
    [parentController.frostedViewController hideMenuViewController];
}

- (void)localNotificationPushViewController{
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    
    UIViewController *parentController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (parentController.presentedViewController !=nil)
        parentController = parentController.presentedViewController;
    
    UIViewController *currentController = parentController;
    DEMONavigationController *demoNavigationControl = [currentController.childViewControllers firstObject];
    
    SettingViewController *alertViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingViewController"];
    demoNavigationControl.viewControllers = @[alertViewController];
    
    parentController.frostedViewController.contentViewController = demoNavigationControl;
    [parentController.frostedViewController hideMenuViewController];
    
    ReminderViewController *trackedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReminderViewController"];
    
    [demoNavigationControl pushViewController:trackedViewController animated:YES];
}

- (void)getAppVersion{
    [[WebClient sharedClient]getAppVersion:@{@"device_type":@2} success:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        if (dictionary!=nil)
        {
            if (![dictionary[@"version"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"AppVersion"]])
            {
                if([dictionary[@"forcefullyUpdate"] isEqualToString:@"1"])
                {
                    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:msgUpdateTitle andMessage:[NSString stringWithFormat:msgUpdateDesc,dictionary[@"version"]]];
                    alertView.buttonsListStyle = SIAlertViewButtonTypeDestructive;
                    [alertView addButtonWithTitle:msgUpdateTitle
                                             type:SIAlertViewButtonTypeDestructive
                                          handler:^(SIAlertView *alert)
                     {
                         [self launchAppStore];
                     }];
                    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
                    [alertView show];
                }
                else if([dictionary[@"forcefullyUpdate"] isEqualToString:@"0"])
                {
                    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:msgUpdateTitle andMessage:[NSString stringWithFormat:msgUpdateDesc,dictionary[@"version"]]];
                    alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
                    [alertView addButtonWithTitle:@"Update"
                                             type:SIAlertViewButtonTypeDestructive
                                          handler:^(SIAlertView *alert)
                     {
                         [self launchAppStore];
                     }];
                    [alertView addButtonWithTitle:@"Next Time"
                                             type:SIAlertViewButtonTypeCancel
                                          handler:^(SIAlertView *alert)
                     {
                         [[NSUserDefaults standardUserDefaults] setObject:dictionary[@"version"] forKey:@"AppVersion"];
                         [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"isNextTime"];
                     }];
                    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
                    [alertView show];
                }
                else
                {

                }
            }
        }
    } failure:^(NSError *error) {
        //[[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
    }];
}

- (void)launchAppStore
{
    NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kAppID];
    NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
    [[UIApplication sharedApplication] openURL:iTunesURL];
}



@end
