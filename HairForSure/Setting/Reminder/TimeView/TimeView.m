//
//  GuideViewController.m
//  eWeather
//
//  Created by Manish on 08/01/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "TimeView.h"
#import "common.h"
#import "NSDate+Calendar.h"

@interface TimeView ()

@end

@implementation TimeView

- (void)awakeFromNib{
/*    self.alpha = 0;
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         
                     }];*/
    [self commonInit];
    [self addPopUpView];
}

- (void)commonInit{
    _btnApply.selected = _btnDone.selected = NO;
    _lblCurrentTime.text = @"00:00";
    _btnDone.layer.cornerRadius = 10.0;
    _btnApply.layer.cornerRadius = 10.0;
    _btnApply.layer.borderWidth = 2;
    _btnApply.layer.borderColor = [UIColor colorWithRed:170.0/255.0 green:147.0/255.0 blue:98.0/255.0 alpha:1.0].CGColor;
    
    [_circularSilder addTarget:self action:@selector(circularSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)addPopUpView{
    [UIView animateWithDuration:0.7 animations:^{
        CGRect newframe=_popupView.frame;
        newframe.origin.y=0;
        _popupView.frame=newframe;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)circularSliderValueChanged:(UICircularSlider *)slider {
    NSDate *date = [[NSDate date] dateDayStart];
    NSDate *newDate = [date dateByAddingMinute:slider.value];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    NSString *strDate = [dateFormatter stringFromDate:newDate];
    _lblCurrentTime.text = strDate;
}

- (IBAction)btnDoneTapped:(id)sender{
    self.alpha = 1;
    _btnDone.selected = YES;
    [UIView animateWithDuration:0.7 animations:^{
        CGRect newframe=_popupView.frame;
        newframe.origin.y = -[UIScreen mainScreen].bounds.size.height;
        _popupView.frame=newframe;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if([_delegate respondsToSelector:@selector(timeView:)]){
            [_delegate timeView:self];
        };
    }];
}

- (IBAction)btnApplyTapped:(id)sender{
    self.alpha = 1;
    _btnApply.selected = YES;
    [UIView animateWithDuration:0.7 animations:^{
        CGRect newframe=_popupView.frame;
        newframe.origin.y = -[UIScreen mainScreen].bounds.size.height;
        _popupView.frame=newframe;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if([_delegate respondsToSelector:@selector(timeView:)]){
            [_delegate timeView:self];
        };
    }];
}

- (IBAction)btnCancelTapped:(id)sender{
    self.alpha = 1;
    [UIView animateWithDuration:0.7 animations:^{
        CGRect newframe=_popupView.frame;
        newframe.origin.y = -[UIScreen mainScreen].bounds.size.height;
        _popupView.frame=newframe;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
