//
//  CustomFont.h
//  HairForSure
//
//  Created by Manish on 15/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomFont : NSObject

@end

@interface UIButton (CustomFont)
@property (nonatomic, copy) NSString* fontName;
@end

@interface UILabel (CustomFont)
@property (nonatomic, copy) NSString* fontName;
@end


@interface UITextField (CustomFont)
@property (nonatomic, copy) NSString* fontName;
@end


@interface UITextView (CustomFont)
@property (nonatomic, copy) NSString* fontName;
@end
