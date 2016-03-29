//
//  Day.h
//  HairForSure
//
//  Created by Manish on 30/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Day : NSObject

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *dayName;
@property (assign, nonatomic) NSInteger dayNumber;
@property (assign, nonatomic) NSInteger weekNumber;
@property (assign, nonatomic) NSInteger intDayCount;
@property (strong, nonatomic) NSString *strUpdatedDate;
@property (assign, nonatomic) float floatProgress;

@property (assign, nonatomic) BOOL isAM;
@property (assign, nonatomic) BOOL isPM;

//+ (Day *)dataWithInfo:(NSDictionary *)dict;
//- (Day *)initWithDictionary:(NSDictionary *)dict;

@end
