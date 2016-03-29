//
//  ViewController.m
//  HairForSure
//
//  Created by Manish on 25/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "ViewController.h"
#import "HelpViewController.h"
#import "Helper.h"
#import "Common.h"
#import "ReminderViewController.h"
#import "REFrostedViewController.h"
#import "HomeViewController.h"
#import "TrackedDateViewController.h"
#import "NSObject+Extras.h"
#import "UtilityManager.h"
#import "SIAlertView.h"
#import "WebClient.h"
#import "AppDelegate.h"

#define SELECT_BG_MINY_IPHONE4      20.0
#define SETTING_BG_MINY_IPHONE4     40.0


@interface ViewController ()
{
    AppDelegate *app;
}

@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (strong, nonatomic) IBOutlet UIButton *btnAccept;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UIImageView *imgHairText;
@property (strong, nonatomic) IBOutlet UIImageView *imgForText;
@property (strong, nonatomic) IBOutlet UIImageView *imgSureText;
@property (strong, nonatomic) IBOutlet UIImageView *imgRippleText;
@property (strong, nonatomic) IBOutlet UIImageView *imgTagLineText;
@property (strong, nonatomic) IBOutlet UIImageView *selectBgImage;
@property (strong, nonatomic) IBOutlet UIView *viewRipleHair;
@property (assign, nonatomic) NSInteger selectBgMinY;
@property (strong, nonatomic) IBOutlet UIView *viewTag;
@property (strong, nonatomic) IBOutlet UILabel *lblResultCoach;
@property (strong, nonatomic) IBOutlet UILabel *lblMaxMsg;
@property (strong, nonatomic) IBOutlet UIView *loaderView;
@property (strong, nonatomic) IBOutlet UIImageView *imgBack;

@property (strong, nonatomic) IBOutlet UIButton *btnSkip;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imgHeader;

@end

@implementation ViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(IPHONE6){
        _selectBgMinY = 150;
    } else if(IPHONE6PLUS){
        _selectBgMinY = 170;
    } else{
        _selectBgMinY = 70;
    }
    _loaderView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(setDeviceID) withObject:nil afterDelay:1.0];
}

-(void)setDeviceID
{
    [self commonInit];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    [self allImagesOutAnimations];
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"disclaimer-2" ofType:@"html"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlFile]]];
    [self runSpinAnimationOnView:self.imgBack duration:0.06 rotations:2.0 repeat:CGFLOAT_MAX];
    _loaderView.hidden = NO;
}

#pragma mark - WebView Delegate Method

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _loaderView.hidden = YES;
    [self.imgBack.layer removeAllAnimations];
}

- (void)allImagesOutAnimations{
    _lblResultCoach.text = @"RESULTS COACH";
    _lblMaxMsg.text = @"\" Maximize your Potential \"";
    _imgRippleText.image = [UIImage imageNamed:@"rippal_hair"];
    _imgTagLineText.image = [UIImage imageNamed:@"Tag_line"];
    _imgSureText.image = [UIImage imageNamed:@"sure_text"];
    _imgHairText.image = [UIImage imageNamed:@"hair_text"];
    _imgForText.image = [UIImage imageNamed:@"for_text"];
    
    _viewTag.alpha=0;
    _lblResultCoach.alpha = 0;
    CGFloat duration = 0.3;
    CGPoint hairCenter = _imgHairText.center;
    CGPoint sureCenter = _imgSureText.center;
    
    [_imgHairText setHidden:YES];
    [_imgSureText setHidden:YES];
    _imgHairText.center = CGPointMake(hairCenter.x -100, hairCenter.y);
    _imgSureText.center = CGPointMake(sureCenter.x +100, sureCenter.y);
    
    _imgForText.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [self animateWithDuration:duration animation:^{
        _imgForText.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
        _imgForText.transform = CGAffineTransformRotate(_imgForText.transform, DegreesToRadians(180));
        
    } completion:^(BOOL finished) {
        [self animateWithDuration:duration animation:^{
            [_imgHairText setHidden:NO];
            [_imgSureText setHidden:NO];
            
            _imgForText.transform = CGAffineTransformIdentity;
            
            _imgHairText.center = hairCenter;
            _imgSureText.center = sureCenter;
            
        } completion:^(BOOL finished) {
            [self animateWithDuration:duration animation:^{
                _imgForText.transform = CGAffineTransformRotate(_imgForText.transform, DegreesToRadians(-45));
                
                _imgHairText.center = CGPointMake(hairCenter.x -20, hairCenter.y);
                _imgSureText.center = CGPointMake(sureCenter.x +20, sureCenter.y);
                
            } completion:^(BOOL finished) {
                [self animateWithDuration:duration animation:^{
                    _imgForText.transform = CGAffineTransformIdentity;
                    
                    _imgHairText.center = hairCenter;
                    _imgSureText.center = sureCenter;
                    
                } completion:^(BOOL finished) {
                    [self animateWithDuration:duration animation:^{
                        _imgForText.transform = CGAffineTransformRotate(_imgForText.transform, DegreesToRadians(-20));
                        
                        _imgHairText.center = CGPointMake(hairCenter.x -10, hairCenter.y);
                        _imgSureText.center = CGPointMake(sureCenter.x +10, sureCenter.y);
                        
                        _imgForText.transform = CGAffineTransformIdentity;
                        
                        _imgHairText.center = hairCenter;
                        _imgSureText.center = sureCenter;
                        
                        [UIView animateWithDuration:0.5 animations:^{
                            _viewTag.alpha = 1;
                            _lblResultCoach.alpha =1;
                        }];
                    } completion:^(BOOL finished) {

                    }];
                }];
            }];
        }];
    }];
    
    CGRect oldframe  = _imgRippleText.frame;
    CGRect newframe  = _imgRippleText.frame;
    newframe.size.height = 0;
    [_imgRippleText setFrame:newframe];
    [UIView animateWithDuration:1.5 animations:^{
        [_imgRippleText setFrame:oldframe];
    } completion:^(BOOL finished) {
        [self performBlock:^{
            _menuView.hidden = YES;
            if ([Helper getIntFromNSUserDefaults:kGuideViewDisplay] == 0) {
                
            }else{
                if ([Helper getIntFromNSUserDefaults:kRemiderVisited] == 1) {
                    TrackedDateViewController *trackedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TrackedDateViewController"];
                    [self.navigationController pushViewController:trackedViewController animated:NO];
                }else{
                    HomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                    [self.navigationController pushViewController:homeViewController animated:NO];
                }
            }
        } afterDelay:1.5];
        
        [[WebClient sharedClient]addUserInfo:@{@"udid":app.strApplicationUUID,@"device_id":kdeviceToken,@"device_type":@2,@"start_date":[NSDate date]} success:^(NSDictionary *dictionary) {
            NSLog(@"%@",dictionary);
            if (dictionary!=nil) {
                if([dictionary[@"success"] boolValue] == YES){
                    //[[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
                }else {
                    //[[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
                }
            }
        } failure:^(NSError *error) {
            //[[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
        }];
    }];
}

- (void)animateWithDuration:(CGFloat)duration animation:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if(animations) {
            animations();
        }
    } completion:^(BOOL finished) {
        if(completion) {
            completion(finished);
        }
    }];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CABasicAnimation *rotate;
    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    rotate.toValue = [NSNumber numberWithFloat:-0.5];
    rotate.duration = 1.5;
    rotate.repeatCount = 1;
    [self.imgForText.layer addAnimation:rotate forKey:@"10"];
}

#pragma mark - Button Click Event

- (IBAction)btnAcceptTapped:(id)sender{
    [[WebClient sharedClient]addUserInfo:@{@"udid":app.strApplicationUUID,@"device_id":kdeviceToken,@"device_type":@2,@"start_date":[NSDate date]} success:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        if (dictionary!=nil) {
            if([dictionary[@"success"] boolValue] == YES){
                //[[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
            }else {
                //[[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
            }
        }
    } failure:^(NSError *error) {
        //[[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
    }];
    
    HelpViewController *helpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpViewController"];
    [self.navigationController pushViewController:helpViewController animated:YES];
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
