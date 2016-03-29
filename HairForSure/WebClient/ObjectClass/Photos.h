//
//  Photos.h
//  HairForSure
//
//  Created by Manish on 29/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photos : NSObject

@property (assign, nonatomic) NSInteger intPhotoID;

@property (strong, nonatomic) NSString *strPhotoURL;
@property (strong, nonatomic) NSString *strAM;
@property (strong, nonatomic) NSString *strPM;
@property (strong, nonatomic) NSString *strDate;

@property (assign, nonatomic) NSInteger indexPath;
@property (assign, nonatomic) NSInteger intSection;

+ (Photos *)dataWithInfo:(NSDictionary *)dict;
- (Photos *)initWithDictionary:(NSDictionary *)dict;

@end
