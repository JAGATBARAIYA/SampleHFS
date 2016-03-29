//
//  GenInfoCell.h
//  HairForSure
//
//  Created by Manish on 25/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenInfo.h"

@interface GenInfoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) GenInfo *genInfo;

@end
