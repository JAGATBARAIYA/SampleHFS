//
//  ReminderCell.h
//  HairForSure
//
//  Created by Manish on 26/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblDay;
@property (strong, nonatomic) IBOutlet UILabel *lblTimeAM;
@property (strong, nonatomic) IBOutlet UILabel *lblTimePM;
@property (strong, nonatomic) IBOutlet UIButton *btnAM;
@property (strong, nonatomic) IBOutlet UIButton *btnPM;
@property (strong, nonatomic) IBOutlet UISwitch *isOn;

@end
