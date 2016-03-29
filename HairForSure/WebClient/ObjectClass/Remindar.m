//
//  Remindar.m
//  HairForSure
//
//  Created by Manish on 02/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "Remindar.h"

@implementation Remindar

+ (Remindar *)dataWithInfo:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}
 
- (Remindar *)initWithDictionary:(NSDictionary *)dict{
    if (dict[@"remID"] != [NSNull null])
        self.intRemID = [dict[@"remID"]integerValue];
     
    if (dict[@"am"] != [NSNull null])
        self.strAM = dict[@"am"];
     
    if (dict[@"pm"] != [NSNull null])
        self.strPM = dict[@"pm"];
     
    if (dict[@"dayName"] != [NSNull null])
        self.strDayName = dict[@"dayName"];
    
    if (dict[@"isOn"] != [NSNull null])
        self.isSwitchOn = [dict[@"isOn"] boolValue];
     
    return self;
}

@end
