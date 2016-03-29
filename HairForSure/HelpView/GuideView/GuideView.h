//
//  GuideViewController.h
//  eWeather
//
//  Created by Manish on 08/01/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GuideView;

@protocol GuideViewDelegate <NSObject>
- (void)guideView:(GuideView *)view;
- (void)menuTapped:(GuideView *)view;

@end

@interface GuideView : UIView

@property (strong, nonatomic)IBOutlet UIView *viewRound;

@property (assign, nonatomic) id<GuideViewDelegate> delegate;

@end
