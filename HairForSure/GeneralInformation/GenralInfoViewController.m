//
//  GenralInfoViewController.m
//  HairForSure
//
//  Created by Manish on 25/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "GenralInfoViewController.h"
#import "REFrostedViewController.h"
#import "InfoDetailViewController.h"
#import "GenInfoCell.h"
#import "GenInfo.h"
#import "WebClient.h"
#import "TKAlertCenter.h"
#import "Common.h"

@interface GenralInfoViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tblList;

@end

@implementation GenralInfoViewController

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
    _tblList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"GenInfoCell";
    GenInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GenInfoCell" owner:self options:nil] objectAtIndex:0];
    
    if (indexPath.row == 0) {
        cell.lblTitle.text = @"The Hair Facts";
        cell.imgView.image = [UIImage imageNamed:@"1"];
    }else if (indexPath.row == 1){
        cell.lblTitle.text = @"Understanding Androgenetic Alopecia (AGA)";
        cell.imgView.image = [UIImage imageNamed:@"2"];
    }else if (indexPath.row == 2){
        cell.lblTitle.text = @"The Science Behind Rutexil";
        cell.imgView.image = [UIImage imageNamed:@"3"];
    }else if (indexPath.row == 3){
        cell.lblTitle.text = @"How to Apply";
        cell.imgView.image = [UIImage imageNamed:@"4"];
    }else if (indexPath.row == 4){
        cell.lblTitle.text = @"What to Expect";
        cell.imgView.image = [UIImage imageNamed:@"5"];
    }else if (indexPath.row == 5){
        cell.lblTitle.text = @"Seal Of Approval";
        cell.imgView.image = [UIImage imageNamed:@"6"];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InfoDetailViewController *infoDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoDetailViewController"];
    infoDetailViewController.intIndex = indexPath.row;
    [self.navigationController pushViewController:infoDetailViewController animated:YES];
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
