//
//  AlertCell.m
//  HairForSure
//
//  Created by Manish on 10/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "AlertCell.h"

@implementation AlertCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIEdgeInsets)layoutMargins{
    return UIEdgeInsetsZero;
}

- (void)setAlerts:(Alerts *)alerts{
    _alerts = alerts;
    _lblAlertTitle.text = _alerts.strDesc;
}

@end
