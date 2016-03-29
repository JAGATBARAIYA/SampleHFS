//
//  ShareView.m
//  HairForSure
//
//  Created by Manish on 05/08/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "ShareView.h"
#import "SIAlertView.h"
#import "Common.h"
#import "SocialMedia.h"
#import "Helper.h"

@interface ShareView ()

@end

@implementation ShareView

- (void)awakeFromNib {
    
}

#pragma mark - Common Init

- (void)commonInit{
    CGRect newframe=_shareView.frame;
    newframe.origin.y = [UIScreen mainScreen].bounds.size.height;
    _shareView.frame=newframe;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self.blackView addGestureRecognizer:tapGestureRecognizer];
    [self shareImage];
}

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    [self btnCancelActionTapped:nil];
}

#pragma mark - Button Click Event

- (void)shareImage{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect newframe=_shareView.frame;
        newframe.origin.y =[UIScreen mainScreen].bounds.size.height - _shareView.frame.size.height;
        _shareView.frame=newframe;
    } completion:^(BOOL finished) {
        
    }];
    _blackView.hidden = NO;
    _blackView.alpha = 0;
    [UIView animateWithDuration:0.6
                     animations:^{
                         _blackView.alpha = 0.8;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (IBAction)btnFacebookTapped:(id)sender{
    [[SocialMedia sharedInstance] shareViaFacebook:self params:@{@"Message":@""} callback:^(BOOL success, NSError *error) {
        if(error){
            [Helper siAlertView:titleFail msg:error.localizedDescription];
        }else {
            [self displaySuccessAlertView:kFacebookPostSuccessMsg];
        }
    }];
}

- (IBAction)btnTwitterTapped:(id)sender{
    [[SocialMedia sharedInstance] shareViaTwitter:self params:@{@"Message":@""} callback:^(BOOL success, NSError *error) {
        if(error){
            [Helper siAlertView:titleFail msg:error.localizedDescription];
        }else {
            [self displaySuccessAlertView:kTwitterPostSuccessMsg];
        }
    }];
}

- (IBAction)btnCancelActionTapped:(id)sender{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect newframe=_shareView.frame;
        newframe.origin.y = [UIScreen mainScreen].bounds.size.height;
        _shareView.frame=newframe;
    } completion:^(BOOL finished) {
        
    }];
    _blackView.alpha = 0.8;
    [UIView animateWithDuration:0.6
                     animations:^{
                         _blackView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         _blackView.hidden = YES;
                     }];
}

- (void)displaySuccessAlertView:(NSString *)msgSuccess{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:titleSuccess andMessage:[@"Product saved successfully!"stringByAppendingString:msgSuccess]];
    alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows;
    [alertView addButtonWithTitle:@"Ok"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

@end
