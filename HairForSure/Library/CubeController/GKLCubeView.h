//
//  GKLViewController.h
//  CubeViewController
//
//  Created by Joseph Pintozzi on 11/28/12.
//  Copyright (c) 2012 GoKart Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/* Delegate protocol for GKLCubViewController to inform child controllers that they have been hidden or unhidden */

@protocol GKLCubeViewDelegate <NSObject>

@optional

/** Notification that view was unhidden (or was presented first time) */

- (void)cubeViewDidShowAtIndex:(NSInteger)index;

@end

/** Custom container class for rotating cube of four view controllers. */

@interface GKLCubeView : UIView

- (instancetype)initWithFrame:(CGRect)frame views:(NSArray *)arrView;

@property (nonatomic, retain) NSMutableArray *arrViews;
@property (nonatomic, retain) id <GKLCubeViewDelegate> delegate;

@property (nonatomic, retain) UIView *visibleView;
@end
