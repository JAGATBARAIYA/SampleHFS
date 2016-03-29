//
//  CollectionCell.m
//  MewseumQuest
//
//  Created by Manish Dudharejia on 29/04/15.
//  Copyright (c) 2015 Manish Dudharejia. All rights reserved.
//

#import "CollectionCell.h"
#import "NSDate+Calendar.h"
#import "DayCell.h"
#import "Day.h"
#import "Helper.h"
#import <objc/runtime.h>
#import "NSString+extras.h"

@implementation CollectionCell

- (void)awakeFromNib {
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.collectionViewDays registerNib:[UINib nibWithNibName:@"DayCell" bundle:nil] forCellWithReuseIdentifier:@"DayCell"];
    [self.collectionViewDays registerNib:[UINib nibWithNibName:@"DayCell_iPhone4" bundle:nil] forCellWithReuseIdentifier:@"DayCell_iPhone4"];
}

- (void)setData:(NSMutableArray *)days {
    arrDays = days;
    [_collectionViewDays reloadData];
}

#pragma mark - CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    DayCell *cell;

    if (IPHONE4) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayCell_iPhone4" forIndexPath:indexPath];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayCell" forIndexPath:indexPath];
    }
    Day *day = [arrDays objectAtIndex:indexPath.item];
    
    [cell.lblDay setText:day.dayName];
    [cell.lblDate setText:[NSString stringWithFormat:@"%ld",(long)day.dayNumber]];
    
    [cell.btnAM setSelected:day.isAM];
    [cell.btnPM setSelected:day.isPM];
    
    [self setImageInset:cell.btnAM];
    [self setImageInset:cell.btnPM];
    
    [cell.btnAM addTarget:self action:@selector(btnAMTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnPM addTarget:self action:@selector(btnPMTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    objc_setAssociatedObject(cell.btnAM, @"Day", day, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(cell.btnPM, @"Day", day, OBJC_ASSOCIATION_RETAIN);
    
    if (indexPath.row == 0) {
        [_viewHelpContainer setHidden:YES];
    }
    if(indexPath.row == 0 && ![Helper getBoolFromUserDefaults:kHistoryGuide]) {
        [_viewHelpContainer setHidden:NO];

        if (IPHONE4) {
            _viewHelp.hidden = _viewHelpSelected.hidden = YES;

            if (cell.btnAM.selected || cell.btnPM.selected) {
                [_viewHelpSelected_iPhone4 setHidden:NO];
                [_viewHelp_iPhone4 setHidden:YES];

                if (cell.btnAM.selected) {
                    [_btnHelpAMSelected_iPhone4 setImage:[UIImage imageNamed:@"check_for_history"] forState:UIControlStateSelected];
                    _btnHelpAMSelected_iPhone4.imageEdgeInsets = UIEdgeInsetsMake(-17, 12, 0, 0);
                    _btnHelpAMSelected_iPhone4.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -17, 0);
                }else{
                    [_btnHelpAMSelected_iPhone4 setImage:nil forState:UIControlStateNormal];
                    _btnHelpAMSelected_iPhone4.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                    _btnHelpAMSelected_iPhone4.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                }

                if (cell.btnPM.selected) {
                    [_btnHelpPMSelected_iPhone4 setImage:[UIImage imageNamed:@"check_for_history"] forState:UIControlStateSelected];
                    _btnHelpPMSelected_iPhone4.imageEdgeInsets = UIEdgeInsetsMake(-17, 12, 0, 0);
                    _btnHelpPMSelected_iPhone4.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -17, 0);
                }else{
                    [_btnHelpPMSelected_iPhone4 setImage:nil forState:UIControlStateNormal];
                    _btnHelpPMSelected_iPhone4.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                    _btnHelpPMSelected_iPhone4.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                }

                [_viewHelpSelected_iPhone4 setFrame:cell.frame];
                [_lblHelpDaySelected_iPhone4 setText:day.dayName];
                [_lblHelpDateSelected_iPhone4 setText:[NSString stringWithFormat:@"%ld",(long)day.dayNumber]];

                [_btnHelpAMSelected_iPhone4 addTarget:self action:@selector(btnHelpAMTapped:) forControlEvents:UIControlEventTouchUpInside];
                [_btnHelpPMSelected_iPhone4 addTarget:self action:@selector(btnHelpPMTapped:) forControlEvents:UIControlEventTouchUpInside];

                objc_setAssociatedObject(_btnHelpAMSelected_iPhone4, @"Button", cell.btnAM, OBJC_ASSOCIATION_RETAIN);
                objc_setAssociatedObject(_btnHelpPMSelected_iPhone4, @"Button", cell.btnPM, OBJC_ASSOCIATION_RETAIN);

            }else{
                [_viewHelpSelected_iPhone4 setHidden:YES];
                [_viewHelp_iPhone4 setHidden:NO];

                [_viewHelp_iPhone4 setFrame:cell.frame];
                [_lblHelpDay_iPhone4 setText:day.dayName];
                [_lblHelpDate_iPhone4 setText:[NSString stringWithFormat:@"%ld",(long)day.dayNumber]];

                [_btnHelpAM_iPhone4 addTarget:self action:@selector(btnAMTapped:) forControlEvents:UIControlEventTouchUpInside];
                [_btnHelpPM_iPhone4 addTarget:self action:@selector(btnPMTapped:) forControlEvents:UIControlEventTouchUpInside];

                objc_setAssociatedObject(_btnHelpAM_iPhone4, @"Button", cell.btnAM, OBJC_ASSOCIATION_RETAIN);
                objc_setAssociatedObject(_btnHelpPM_iPhone4, @"Button", cell.btnPM, OBJC_ASSOCIATION_RETAIN);
            }
        }else{
            _viewHelp_iPhone4.hidden = _viewHelpSelected_iPhone4.hidden = YES;

            if (cell.btnAM.selected || cell.btnPM.selected) {
                [_viewHelpSelected setHidden:NO];
                [_viewHelp setHidden:YES];

                if (cell.btnAM.selected) {
                    [_btnHelpAMSelected setImage:[UIImage imageNamed:@"check_for_history"] forState:UIControlStateSelected];
                    _btnHelpAMSelected.imageEdgeInsets = UIEdgeInsetsMake(-17, 12, 0, 0);
                    _btnHelpAMSelected.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -17, 0);
                }else{
                    [_btnHelpAMSelected setImage:nil forState:UIControlStateNormal];
                    _btnHelpAMSelected.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                    _btnHelpAMSelected.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                }

                if (cell.btnPM.selected) {
                    [_btnHelpPMSelected setImage:[UIImage imageNamed:@"check_for_history"] forState:UIControlStateSelected];
                    _btnHelpPMSelected.imageEdgeInsets = UIEdgeInsetsMake(-17, 12, 0, 0);
                    _btnHelpPMSelected.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -17, 0);
                }else{
                    [_btnHelpPMSelected setImage:nil forState:UIControlStateNormal];
                    _btnHelpPMSelected.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                    _btnHelpPMSelected.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                }

                [_viewHelpSelected setFrame:cell.frame];
                [_lblHelpDaySelected setText:day.dayName];
                [_lblHelpDateSelected setText:[NSString stringWithFormat:@"%ld",(long)day.dayNumber]];

                [_btnHelpAMSelected addTarget:self action:@selector(btnHelpAMTapped:) forControlEvents:UIControlEventTouchUpInside];
                [_btnHelpPMSelected addTarget:self action:@selector(btnHelpPMTapped:) forControlEvents:UIControlEventTouchUpInside];

                objc_setAssociatedObject(_btnHelpAMSelected, @"Button", cell.btnAM, OBJC_ASSOCIATION_RETAIN);
                objc_setAssociatedObject(_btnHelpPMSelected, @"Button", cell.btnPM, OBJC_ASSOCIATION_RETAIN);

            }else{
                [_viewHelpSelected setHidden:YES];
                [_viewHelp setHidden:NO];

                [_viewHelp setFrame:cell.frame];
                [_lblHelpDay setText:day.dayName];
                [_lblHelpDate setText:[NSString stringWithFormat:@"%ld",(long)day.dayNumber]];

                [_btnHelpAM addTarget:self action:@selector(btnAMTapped:) forControlEvents:UIControlEventTouchUpInside];
                [_btnHelpPM addTarget:self action:@selector(btnPMTapped:) forControlEvents:UIControlEventTouchUpInside];

                objc_setAssociatedObject(_btnHelpAM, @"Button", cell.btnAM, OBJC_ASSOCIATION_RETAIN);
                objc_setAssociatedObject(_btnHelpPM, @"Button", cell.btnPM, OBJC_ASSOCIATION_RETAIN);
            }

        }
    }
    return cell;
}

#pragma mark - Button

- (void)setImageInset:(UIButton *)sender {
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"check_for_history"] forState:UIControlStateSelected];
        if (IPHONE4 || IPHONE5) {
            sender.imageEdgeInsets = UIEdgeInsetsMake(-17, 12, 0, 0);
            sender.titleEdgeInsets = UIEdgeInsetsMake(0, -13, -18, 0);
        }else if (IPHONE6){
            sender.imageEdgeInsets = UIEdgeInsetsMake(-17, 12, 0, 0);
            sender.titleEdgeInsets = UIEdgeInsetsMake(0, -12, -18, 0);
        }else if (IPHONE6PLUS) {
            sender.imageEdgeInsets = UIEdgeInsetsMake(-17, 12, 0, 0);
            sender.titleEdgeInsets = UIEdgeInsetsMake(0, -17, -18, 0);
        }
    }else{
        [sender setImage:nil forState:UIControlStateNormal];
        sender.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        sender.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (IBAction)btnAMTapped:(UIButton *)sender {
    [_viewHelpContainer setHidden:YES];
    app.showHelpView = NO;
    [Helper addBoolToUserDefaults:YES forKey:kHistoryGuide];
    UIButton *btn = sender;
    if (IPHONE4) {
        if(btn == _btnHelpAM_iPhone4) {
            btn = objc_getAssociatedObject(btn, @"Button");
        }
    }else{
        if(btn == _btnHelpAM) {
            btn = objc_getAssociatedObject(btn, @"Button");
        }
    }

    Day *day = objc_getAssociatedObject(btn, @"Day");

    if ([[[NSDate date]dateDayStart] isLessDate:day.date]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgDateGreater image:kErrorImage];
    }else{
        [btn setSelected:![btn isSelected]];
        day.isAM = [btn isSelected];
        [self setImageInset:btn];
    }
    [Helper addCustomObjectToUserDefaults:app.arrOfWeeks key:@"WeekArray"];
}

- (IBAction)btnPMTapped:(UIButton *)sender {
    [_viewHelpContainer setHidden:YES];
    app.showHelpView = NO;
    [Helper addBoolToUserDefaults:YES forKey:kHistoryGuide];
    UIButton *btn = sender;
    if (IPHONE4) {
        if(btn == _btnHelpPM_iPhone4) {
            btn = objc_getAssociatedObject(btn, @"Button");
        }
    }else{
        if(btn == _btnHelpPM) {
            btn = objc_getAssociatedObject(btn, @"Button");
        }
    }

    Day *day = objc_getAssociatedObject(btn, @"Day");
    if ([[[NSDate date]dateDayStart] isLessDate:day.date]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgDateGreater image:kErrorImage];
    }else{
        [btn setSelected:![btn isSelected]];
        day.isPM = [btn isSelected];
        [self setImageInset:btn];
    }
    [Helper addCustomObjectToUserDefaults:app.arrOfWeeks key:@"WeekArray"];
}

- (IBAction)btnHelpAMTapped:(id)sender{
    app.showHelpView = NO;
    [_viewHelpContainer setHidden:YES];
    [Helper addBoolToUserDefaults:YES forKey:kHistoryGuide];
    [Helper addCustomObjectToUserDefaults:app.arrOfWeeks key:@"WeekArray"];

}

- (IBAction)btnHelpPMTapped:(id)sender{
    app.showHelpView = NO;
    [_viewHelpContainer setHidden:YES];
    [Helper addBoolToUserDefaults:YES forKey:kHistoryGuide];
    [Helper addCustomObjectToUserDefaults:app.arrOfWeeks key:@"WeekArray"];

}

@end
