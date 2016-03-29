//
//  AlertCell.h
//  HairForSure
//
//  Created by Manish on 10/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alerts.h"

@interface AlertCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblAlertTitle;
@property (strong, nonatomic) Alerts *alerts;

@end
