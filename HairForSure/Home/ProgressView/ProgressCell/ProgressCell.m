//
//  ProgressCell.m
//  HairForSure
//
//  Created by Manish on 08/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "ProgressCell.h"
#import "ProgressDayCell.h"
#import "NSDate+Calendar.h"
#import "Day.h"
#import "Helper.h"
#import <objc/runtime.h>
#import "NSString+extras.h"

@implementation ProgressCell

- (void)awakeFromNib {
    [self.collectionViewDays registerNib:[UINib nibWithNibName:@"ProgressDayCell" bundle:nil] forCellWithReuseIdentifier:@"ProgressDayCell"];
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
    ProgressDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProgressDayCell" forIndexPath:indexPath];
    Day *day = [arrDays objectAtIndex:indexPath.item];
    [cell.lblDay setText:day.dayName];
    
    [cell.btnAM setSelected:day.isAM];
    [cell.btnPM setSelected:day.isPM];

    [cell.lblDate setText:[NSString stringWithFormat:@"%ld",(long)day.dayNumber]];
    
    return cell;
}

@end
