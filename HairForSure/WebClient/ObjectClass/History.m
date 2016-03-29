//
//  History.m
//  HairForSure
//
//  Created by Manish on 15/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "History.h"

@implementation History

+ (History *)dataWithInfo:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

- (History *)initWithDictionary:(NSDictionary *)dict{
    if (dict[@"weekNo"] != [NSNull null])
        self.intWeekNo = [dict[@"weekNo"]integerValue];
    
    if (dict[@"isAM"] != [NSNull null])
        self.intIsAM = [dict[@"isAM"]integerValue];

    if (dict[@"isPM"] != [NSNull null])
        self.intIsPM = [dict[@"isPM"]integerValue];
    
    return self;
}

@end
