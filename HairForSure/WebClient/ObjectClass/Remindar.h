//
//  Remindar.h
//  HairForSure
//
//  Created by Manish on 02/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Remindar : NSObject

@property (assign, nonatomic) NSInteger intRemID;

@property (strong, nonatomic) NSString *strDayName;
@property (strong, nonatomic) NSString *strDate;
@property (strong, nonatomic) NSString *strAM;
@property (strong, nonatomic) NSString *strPM;
@property (assign, nonatomic) BOOL isSwitchOn;

@property (assign, nonatomic, getter=isPushNotification) BOOL pushNotification;

+ (Remindar *)dataWithInfo:(NSDictionary *)dict;
- (Remindar *)initWithDictionary:(NSDictionary *)dict;

@end
