//
//  Alerts.h
//  HairForSure
//
//  Created by Manish on 10/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alerts : NSObject

@property (assign, nonatomic) NSInteger intAlertID;

@property (strong, nonatomic) NSString *strTitle;
@property (strong, nonatomic) NSString *strDesc;

+ (Alerts *)dataWithInfo:(NSDictionary *)dict;
- (Alerts *)initWithDictionary:(NSDictionary *)dict;

@end
