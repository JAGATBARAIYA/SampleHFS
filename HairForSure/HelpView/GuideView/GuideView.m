//
//  GuideViewController.m
//  eWeather
//
//  Created by Manish on 08/01/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "GuideView.h"
#import "common.h"

@interface GuideView ()

@end

@implementation GuideView

- (void)awakeFromNib{

}

- (IBAction)btnMenuTapped:(id)sender{
      if([_delegate respondsToSelector:@selector(menuTapped:)]){
          [_delegate menuTapped:self];
      };
}

- (IBAction)btnTrackTapped:(id)sender{
     if([_delegate respondsToSelector:@selector(guideView:)]){
         [_delegate guideView:self];
     }
}

@end
