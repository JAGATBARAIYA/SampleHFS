//
//  HelpCell.h
//  HairForSure
//
//  Created by Manish on 25/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextView *txtDesc;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
