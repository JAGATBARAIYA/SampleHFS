//
//  GenInfo.m
//  HairForSure
//
//  Created by Manish on 25/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "GenInfo.h"
#import "NSString+HTML.h"

@implementation GenInfo

+ (GenInfo *)dataWithInfo:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

- (GenInfo *)initWithDictionary:(NSDictionary *)dict{
    if (dict[@"information_id"] != [NSNull null])
        self.intInfoID = [dict[@"information_id"]integerValue];
    
    if (dict[@"information_detail"] != [NSNull null])
        self.strDesc = dict[@"information_detail"];
    
    if (dict[@"information_name"] != [NSNull null])
        self.strName = dict[@"information_name"];
    
    if (dict[@"image"] != [NSNull null])
        self.strURL = dict[@"image"];

    if (dict[@"pageurl"] != [NSNull null])
        self.strPageURL = dict[@"pageurl"];

//    self.attributedDescString = [self getString:self.strDesc fontSize:14.0];

    return self;
}

- (NSMutableAttributedString*)getString:(NSString*)data fontSize:(CGFloat)size{
    NSDictionary *dictAttrib = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,  NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc]initWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:dictAttrib documentAttributes:nil error:nil];
    [attrib beginEditing];
    [attrib enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attrib.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value) {
            UIFont *oldFont = (UIFont *)value;
            [attrib removeAttribute:NSFontAttributeName range:range];
            if ([oldFont.fontName isEqualToString:@"TimesNewRomanPSMT"])
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:size] range:range];
            else if([oldFont.fontName isEqualToString:@"TimesNewRomanPS-BoldMT"])
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:size] range:range];
            else if([oldFont.fontName isEqualToString:@"TimesNewRomanPS-ItalicMT"])
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Italic" size:size] range:range];
            else if([oldFont.fontName isEqualToString:@"TimesNewRomanPS-BoldItalicMT"])
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Italic" size:size] range:range];
            else
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:size] range:range];
        }
    }];
    [attrib endEditing];
    return attrib;
}

@end
