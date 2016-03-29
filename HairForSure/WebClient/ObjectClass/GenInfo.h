//
//  GenInfo.h
//  HairForSure
//
//  Created by Manish on 25/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GenInfo : NSObject

@property (assign, nonatomic) NSInteger intInfoID;

@property (strong, nonatomic) NSString *strName;
@property (strong, nonatomic) NSString *strDesc;
@property (strong, nonatomic) NSString *strURL;
@property (strong, nonatomic) NSString *strPageURL;

//@property (strong, nonatomic) NSAttributedString *attributedTitleString;
//@property (strong, nonatomic) NSAttributedString *attributedDescString;

+ (GenInfo *)dataWithInfo:(NSDictionary *)dict;
- (GenInfo *)initWithDictionary:(NSDictionary *)dict;

@end
