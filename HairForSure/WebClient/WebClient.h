//
//  WebClient.h
//  iPhoneStructure
//
//  Created by Marvin on 29/04/14.
//  Copyright (c) 2014 Marvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebKit.h"

typedef void(^WebClientCallbackSuccess)(NSDictionary *dictionary);
typedef void(^WebClientCallbackFailure)(NSError *error);

@interface WebClient : NSObject

//Shared Client method
+ (id)sharedClient;

- (void)getAtPath:(NSString *)path withParams:(NSDictionary *)params :(void(^)(id jsonData))onComplete failure:(void (^)(NSError *error))failure;

//Contect Us
- (void)addContact:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Alert
- (void)getAlerts:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//User Detail
- (void)addUser:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

- (void)showUser:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Reset Data
- (void)resetData:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Add User Info
- (void)addUserInfo:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Set Notification On/Off
- (void)setNotification:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Get App Version
- (void)getAppVersion:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

@end
