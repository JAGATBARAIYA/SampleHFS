//
//  Day.m
//  HairForSure
//
//  Created by Manish on 30/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "Day.h"

static NSString *const kDate = @"Date";
static NSString *const kDayName = @"DayNumber";
static NSString *const kDayNumber = @"DayName";
static NSString *const kisAM = @"isAM";
static NSString *const kisPM = @"isPM";

@implementation Day

/*
+ (Day *)dataWithInfo:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

- (Day *)initWithDictionary:(NSDictionary *)dict{

    if (dict[@"date"] != [NSNull null])
        self.strDate = dict[@"date"];
    
    if (dict[@"dayname"] != [NSNull null])
        self.strDayName = dict[@"dayname"];
    
    if (dict[@"am"] != [NSNull null])
        self.isAM = dict[@"am"];
    
    if (dict[@"pm"] != [NSNull null])
        self.isPM = dict[@"pm"];
    
    return self;
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.date = [coder decodeObjectForKey:kDate];
        self.dayName = [coder decodeObjectForKey:kDayName];
        self.dayNumber = [coder decodeIntegerForKey:kDayNumber];
        self.isAM = [coder decodeBoolForKey:kisAM];
        self.isPM = [coder decodeBoolForKey:kisPM];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.date forKey:kDate];
    [coder encodeObject:self.dayName forKey:kDayName];
    [coder encodeInteger:self.dayNumber forKey:kDayNumber];
    [coder encodeBool:self.isAM forKey:kisAM];
    [coder encodeBool:self.isPM forKey:kisPM];

}
@end
