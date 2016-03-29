//
//  BuyProductViewController.m
//  HairForSure
//
//  Created by Manish on 03/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "BuyProductViewController.h"
#import "REFrostedViewController.h"
#import "Common.h"

@interface BuyProductViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIView *loaderView;
@property (strong, nonatomic) IBOutlet UIImageView *imgBack;

@end

@implementation BuyProductViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    _loaderView.hidden = YES;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.athenalife.com/shop/hair-for-sure-hair-tonic.html"]];
    [self runSpinAnimationOnView:self.imgBack duration:0.06 rotations:2.0 repeat:CGFLOAT_MAX];
    _loaderView.hidden = NO;
}

#pragma mark - WebView Delegate Method

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _loaderView.hidden = YES;
    [self.imgBack.layer removeAllAnimations];
}

#pragma mark - Button Click Event

- (IBAction)btnMenuTapped:(id)sender{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * rotations * duration];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
