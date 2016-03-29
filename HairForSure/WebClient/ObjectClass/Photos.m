//
//  Photos.m
//  HairForSure
//
//  Created by Manish on 29/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "Photos.h"
#import "Common.h"
#import "Helper.h"

@implementation Photos

+ (Photos *)dataWithInfo:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

- (Photos *)initWithDictionary:(NSDictionary *)dict{
    if (dict[@"photoID"] != [NSNull null])
        self.intPhotoID = [dict[@"photoID"]integerValue];
    
    if (dict[@"section"] != [NSNull null])
        self.intSection = [dict[@"section"]integerValue];

    if (dict[@"photoURL"] != [NSNull null])
        self.strPhotoURL = [Helper getDocumentDirectoryPath:dict[@"photoURL"]];
        
    if (dict[@"am"] != [NSNull null])
        self.strAM = dict[@"am"];
    
    if (dict[@"pm"] != [NSNull null])
        self.strPM = dict[@"pm"];

    if (dict[@"date"] != [NSNull null])
        self.strDate = [self getDate:dict[@"date"]];

    return self;
}

- (NSString *)getDate:(NSString *)strTimestamp
{
    NSDate *aDate = [NSDate dateWithTimeIntervalSince1970:[strTimestamp doubleValue]];
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    dtFormat.dateFormat = kDateFormat;
    return [dtFormat stringFromDate:aDate];
}

@end
