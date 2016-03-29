//
//  CustomCell.h
//  HairForSure
//
//  Created by Manish on 06/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UICollectionViewCell

@property (weak) IBOutlet UIImageView *articleImage;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;

@end
