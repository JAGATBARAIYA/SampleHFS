//
//  TrackedDateViewController.m
//  HairForSure
//
//  Created by Manish on 09/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "TrackedDateViewController.h"
#import "ReminderViewController.h"
#import "REFrostedViewController.h"
#import "Helper.h"
#import "NSObject+Extras.h"

@interface TrackedDateViewController ()

@property (strong, nonatomic) IBOutlet UIButton *btnTracked;

@end

@implementation TrackedDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)btnTrackedTapped:(id)sender{
     _btnTracked.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    [UIView animateWithDuration:0.1 animations:^{
         _btnTracked.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [self performBlock:^{
            _btnTracked.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            ReminderViewController *reminderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReminderViewController"];
            reminderViewController.isShow = YES;
            [self.navigationController pushViewController:reminderViewController animated:YES];
            [Helper addToNSUserDefaults:[NSDate date] forKey:kTrackedDate];
        } afterDelay:0.5];
    }];
}

- (IBAction)btnMenuTapped:(id)sender{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

@end
