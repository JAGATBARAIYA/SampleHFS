//
//  GenInfoCell.m
//  HairForSure
//
//  Created by Manish on 25/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "GenInfoCell.h"
#import "UIKit+AFNetworking.h"

@implementation GenInfoCell

- (void)awakeFromNib {
    [_imgView.layer setCornerRadius:20.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIEdgeInsets)layoutMargins{
    return UIEdgeInsetsZero;
}

- (void)setGenInfo:(GenInfo *)genInfo{
    _genInfo = genInfo;
    _lblTitle.text = _genInfo.strName;
    NSURL *imgURL = [NSURL URLWithString:_genInfo.strURL];
    [_imgView setImageWithURL:imgURL placeholderImage:nil];
}

@end
