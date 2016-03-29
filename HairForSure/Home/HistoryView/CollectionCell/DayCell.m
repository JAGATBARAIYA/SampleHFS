//
//  DayCell.m
//  HairForSure
//
//  Created by Manish Dudharejia on 02/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "DayCell.h"

@implementation DayCell

- (void)awakeFromNib {
    [_btnAM.layer setCornerRadius:8.0];
    [_btnPM.layer setCornerRadius:8.0];
}

@end
