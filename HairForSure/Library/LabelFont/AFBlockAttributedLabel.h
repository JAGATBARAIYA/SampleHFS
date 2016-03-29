//
//  AFBlockAttributedLabel.h
//  AFBlockAttributedLabel
//
//  Created by Daniel Kuhnke on 27.02.15.
//  Copyright (c) 2015 appfarms GmbH & Co. KG. All rights reserved.
//

#import "TTTAttributedLabel.h"

@interface AFBlockAttributedLabel : TTTAttributedLabel

- (void) setHTML:(NSString *)html;
- (void) setHTML:(NSString *)html andDidSelectLinkWithURLBlock:(void(^)(NSURL * url))block;
- (void) setHTML:(NSString *)html linkAttributes:(NSDictionary *)linkAttributes activeLinkAttributes:(NSDictionary *)activeLinkAttributes andDidSelectLinkWithURLBlock:(void(^)(NSURL * url))block;

+ (NSMutableAttributedString *) attributedStringByHTML:(NSString *)html withFont:(UIFont *)font andTextColor:(UIColor *)textColor;
- (NSMutableAttributedString *) attributedStringByHTML:(NSString *)html;

- (void) setDidSelectLinkWithURLBlock:(void(^)(NSURL * url))block;

@end
