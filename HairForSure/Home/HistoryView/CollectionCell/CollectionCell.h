//
//  CollectionCell.h
//  MewseumQuest
//
//  Created by Manish Dudharejia on 29/04/15.
//  Copyright (c) 2015 Manish Dudharejia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CollectionCell : UICollectionViewCell
{
    NSMutableArray *arrDays;
    AppDelegate *app;
}

@property (nonatomic, retain) IBOutlet UICollectionView *collectionViewDays;

@property (nonatomic, retain) IBOutlet UIView *viewHelpContainer;
@property (nonatomic, retain) IBOutlet UIView *viewHelp;
@property (strong, nonatomic) IBOutlet UIView *viewHelpSelected;
@property (nonatomic, retain) IBOutlet UIView *viewHelp_iPhone4;
@property (strong, nonatomic) IBOutlet UIView *viewHelpSelected_iPhone4;

@property (strong, nonatomic) IBOutlet UILabel *lblHelpDate;
@property (strong, nonatomic) IBOutlet UILabel *lblHelpDay;
@property (strong, nonatomic) IBOutlet UIButton *btnHelpAM;
@property (strong, nonatomic) IBOutlet UIButton *btnHelpPM;

@property (strong, nonatomic) IBOutlet UILabel *lblHelpDate_iPhone4;
@property (strong, nonatomic) IBOutlet UILabel *lblHelpDay_iPhone4;
@property (strong, nonatomic) IBOutlet UIButton *btnHelpAM_iPhone4;
@property (strong, nonatomic) IBOutlet UIButton *btnHelpPM_iPhone4;

@property (strong, nonatomic) IBOutlet UILabel *lblHelpDateSelected;
@property (strong, nonatomic) IBOutlet UILabel *lblHelpDaySelected;
@property (strong, nonatomic) IBOutlet UIButton *btnHelpAMSelected;
@property (strong, nonatomic) IBOutlet UIButton *btnHelpPMSelected;

@property (strong, nonatomic) IBOutlet UILabel *lblHelpDateSelected_iPhone4;
@property (strong, nonatomic) IBOutlet UILabel *lblHelpDaySelected_iPhone4;
@property (strong, nonatomic) IBOutlet UIButton *btnHelpAMSelected_iPhone4;
@property (strong, nonatomic) IBOutlet UIButton *btnHelpPMSelected_iPhone4;

- (void)setData:(NSMutableArray *)days;

@end
