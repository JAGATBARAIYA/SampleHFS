//
//  History.h
//  HairForSure
//
//  Created by Manish on 15/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface History : NSObject

@property (assign, nonatomic) NSInteger intWeekNo;
@property (assign, nonatomic) NSInteger intIsAM;
@property (assign, nonatomic) NSInteger intIsPM;

+ (History *)dataWithInfo:(NSDictionary *)dict;
- (History *)initWithDictionary:(NSDictionary *)dict;

@end
