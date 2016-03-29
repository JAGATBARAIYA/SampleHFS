//
//  Alerts.m
//  HairForSure
//
//  Created by Manish on 10/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "Alerts.h"

@implementation Alerts

+ (Alerts *)dataWithInfo:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

- (Alerts *)initWithDictionary:(NSDictionary *)dict{
    if (dict[@"ID"] != [NSNull null])
        self.intAlertID = [dict[@"ID"]integerValue];
    
    if (dict[@"description"] != [NSNull null])
        self.strDesc = dict[@"description"];
    
    if (dict[@"title"] != [NSNull null])
        self.strTitle = dict[@"title"];
        
    return self;
}

@end
