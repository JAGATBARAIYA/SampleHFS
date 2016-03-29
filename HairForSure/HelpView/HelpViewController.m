//
//  HelpViewController.m
//  HairForSure
//
//  Created by Manish on 25/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "HelpViewController.h"
#import "ReminderViewController.h"
#import "REFrostedViewController.h"
#import "HelpCell.h"
#import "Helper.h"
#import "Common.h"
#import "TrackedDateViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Origami.h"

#import "GKLCubeView.h"

@interface HelpViewController ()<UITextViewDelegate,NSLayoutManagerDelegate,GKLCubeViewDelegate>

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *arrView;
@property (strong, nonatomic) IBOutlet UIButton *btnSkip;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imgHeader;
@property (strong, nonatomic) IBOutlet UIView *helpView;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ViewController *controller1 = [[ViewController alloc] initWithNibName:@"HelpView1" bundle:nil];
    [controller1.view setFrame:_helpView.bounds];
    
    if (!IPHONE6PLUS) {
        for (UIView *aView in controller1.view.subviews)
        {
            if ([aView isKindOfClass:[UIScrollView class]])
            {
                CGRect aRect = [[UIScreen mainScreen] bounds];
                UIScrollView *aScrollView = (UIScrollView *)aView;
                [aScrollView setContentSize:(CGSize){aRect.size.width, aRect.size.height}];
            }
        }
    }

    ViewController *controller2 = [[ViewController alloc] initWithNibName:@"HelpView2" bundle:nil];
    [controller2.view setFrame:_helpView.bounds];
    ViewController *controller3 = [[ViewController alloc] initWithNibName:@"HelpView3" bundle:nil];
    [controller3.view setFrame:_helpView.bounds];
    ViewController *controller4 = [[ViewController alloc] initWithNibName:@"HelpView4" bundle:nil];
    [controller4.view setFrame:_helpView.bounds];

    if (IPHONE4) {
        for (UIView *aView in controller1.view.subviews)
        {
            if ([aView isKindOfClass:[UIScrollView class]])
            {
                CGRect aRect = [[UIScreen mainScreen] bounds];
                UIScrollView *aScrollView = (UIScrollView *)aView;
                [aScrollView setContentSize:(CGSize){aRect.size.width, aRect.size.height+10}];
            }
        }
        for (UIView *aView in controller3.view.subviews)
        {
            if ([aView isKindOfClass:[UIScrollView class]])
            {
                CGRect aRect = [[UIScreen mainScreen] bounds];
                UIScrollView *aScrollView = (UIScrollView *)aView;
                [aScrollView setContentSize:(CGSize){aRect.size.width, aRect.size.height-50}];
            }
        }
    }

    GKLCubeView *cubeView = [[GKLCubeView alloc] initWithFrame:_helpView.bounds views:@[controller1.view,controller2.view,controller3.view,controller4.view]];

    [cubeView setDelegate:self];
    [_helpView addSubview:cubeView];
    [self commonInit];
}

- (void)cubeViewDidShowAtIndex:(NSInteger)index {
    [_pageControl setCurrentPage:index];
    if (index == 3) {
        [_btnSkip setTitle:@"DONE" forState:UIControlStateNormal];
    }else{
        [_btnSkip setTitle:@"SKIP" forState:UIControlStateNormal];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    if ([Helper getIntFromNSUserDefaults:kVisited] == 1) {
        _btnMenu.hidden = NO;
        _btnSkip.hidden = YES;
        _lblTitle.hidden = NO;
        _imgHeader.hidden = YES;
    }else{
        _btnMenu.hidden = YES;
        _btnSkip.hidden = NO;
        _lblTitle.hidden = YES;
        _imgHeader.hidden = NO;
    }
}

#pragma mark - Button Click Event

- (IBAction)btnMenuTapped:(id)sender{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)btnSkipTapped:(id)sender{
    [Helper addIntToUserDefaults:1 forKey:kGuideViewDisplay];
    [Helper addIntToUserDefaults:1 forKey:kVisited];
    [Helper addIntToUserDefaults:1 forKey:kRemiderVisited];

    TrackedDateViewController *trackedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TrackedDateViewController"];
    [self.navigationController pushViewController:trackedViewController animated:YES];
}

@end
