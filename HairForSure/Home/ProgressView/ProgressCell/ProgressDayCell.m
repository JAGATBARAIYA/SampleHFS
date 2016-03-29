//
//  ProgressDayCell.m
//  HairForSure
//
//  Created by Manish on 08/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "ProgressDayCell.h"

@implementation ProgressDayCell

- (void)awakeFromNib {
    [_btnAM.layer setCornerRadius:8.0];
    [_btnPM.layer setCornerRadius:8.0];
}

@end
