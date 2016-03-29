//
//  WebClient.m
//  iPhoneStructure
//
//  Created by Marvin on 29/04/14.
//  Copyright (c) 2014 Marvin. All rights reserved.
//

#import "WebClient.h"
#import "NSString+extras.h"
#import "Common.h"
#import "TKAlertCenter.h"
#import "AppDelegate.h"

@interface WebClient()

@end

@implementation WebClient

#pragma mark - Shared Client

+ (id)sharedClient {
    static WebClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });
    return sharedClient;
}

#pragma mark - Get generic Path

- (void)getAtPath:(NSString *)path withParams:(NSDictionary *)params :(void(^)(id jsonData))onComplete failure:(void (^)(NSError *error))failure {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error= nil;
        if(responseObject){
            NSString *json = [[[NSString alloc] initWithData:(NSData*)responseObject encoding:NSASCIIStringEncoding] trimWhiteSpace];
            NSArray *dictArray = [json componentsSeparatedByString:@"<!-- Hosting24"];
            NSData *data = [dictArray[0] dataUsingEncoding:NSUTF8StringEncoding];
            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (error){
                NSLog(@"%@",error.localizedDescription);
                NSLog(@"JSON parsing error in %@", NSStringFromSelector(_cmd));
                failure(error);
            } else {
                onComplete(jsonData);
            }
        }else{
            onComplete(nil);
            return;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request failed %@ (%li)", operation.request.URL, (long)operation.response.statusCode);
        failure(error);
    }];
}

#pragma mark - Add Contact

- (void)addContact:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kAddContact fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Get Alerts

- (void)getAlerts:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kGetAlerts fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Add User

- (void)addUser:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kAddUser fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Show User

- (void)showUser:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kShowUser fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Reset Data

- (void)resetData:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kResetData fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Add User Info

- (void)addUserInfo:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kAddUserInfo fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Set Notification On/Off

- (void)setNotification:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kSetNotification fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Set Notification On/Off

- (void)getAppVersion:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kAppVersion fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
