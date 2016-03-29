//
//  ProgressDayCell.h
//  HairForSure
//
//  Created by Manish on 08/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressDayCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblDay;
@property (strong, nonatomic) IBOutlet UIButton *btnAM;
@property (strong, nonatomic) IBOutlet UIButton *btnPM;

@end