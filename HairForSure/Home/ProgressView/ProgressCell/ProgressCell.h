//
//  ProgressCell.h
//  HairForSure
//
//  Created by Manish on 08/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ProgressCell : UICollectionViewCell
{
    NSMutableArray *arrDays;
    AppDelegate *app;
}

@property (nonatomic, retain) IBOutlet UICollectionView *collectionViewDays;

- (void)setData:(NSMutableArray *)days;


@end
