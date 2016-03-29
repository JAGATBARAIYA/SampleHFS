//
//  GuideViewController.h
//  eWeather
//
//  Created by Manish on 08/01/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICircularSlider.h"

@class TimeView;

@protocol TimeViewDelegate <NSObject>
- (void)timeView:(TimeView *)view;
@end

@interface TimeView : UIView

@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) IBOutlet UIButton *btnApply;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentTime;
@property (strong, nonatomic) IBOutlet UICircularSlider *circularSilder;
@property (strong, nonatomic) IBOutlet UILabel *lblAMPM;
@property (strong, nonatomic) IBOutlet UIView *popupView;

@property (assign, nonatomic) id<TimeViewDelegate> delegate;

@end
