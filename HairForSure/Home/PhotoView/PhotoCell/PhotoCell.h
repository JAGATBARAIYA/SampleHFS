//
//  PhotoCell.h
//  HairForSure
//
//  Created by Manish on 26/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCellView.h"

@interface PhotoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property (strong, nonatomic) IBOutlet UILabel *lblBefore;
@property (strong, nonatomic) IBOutlet UILabel *lblWeekNo;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) PhotoCellView *collectionView;


//- (void)setCollectionData:(NSArray *)collectionData;

@end
