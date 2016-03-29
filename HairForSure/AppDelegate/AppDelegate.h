//
//  AppDelegate.h
//  HairForSure
//
//  Created by Manish on 25/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *arrOfWeeks;
@property (strong, nonatomic) NSString *strDeviceToken;
@property (strong, nonatomic) NSString *strTag;
@property (assign, nonatomic) BOOL showHelpView;
@property (nonatomic, retain) NSString *strApplicationUUID;

@end

