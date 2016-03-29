//
//  PhotoDetailViewController.h
//  HairForSure
//
//  Created by Manish on 10/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photos.h"

@interface PhotoDetailViewController : UIViewController<UIPageViewControllerDataSource>

@property (strong, nonatomic) NSIndexPath *index;

@property (strong, nonatomic) Photos *photos;

@end
