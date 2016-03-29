//
//  AlertViewController.m
//  HairForSure
//
//  Created by Manish on 25/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "AlertViewController.h"
#import "REFrostedViewController.h"
#import "WebClient.h"
#import "TKAlertCenter.h"
#import "Alerts.h"
#import "Common.h"
#import "AlertCell.h"

@interface AlertViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tblList;
@property (strong, nonatomic) NSMutableArray *arrAlertList;
@property (strong, nonatomic) IBOutlet UILabel *lblNoRecordFound;
@property (strong, nonatomic) IBOutlet UIView *loaderView;
@property (strong, nonatomic) IBOutlet UIImageView *imgBack;

@end

@implementation AlertViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    _arrAlertList = [[NSMutableArray alloc]init];
    _tblList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _loaderView.hidden = YES;
    [self getAlerts];
}

#pragma mark - Get Information

- (void)getAlerts{
    [self runSpinAnimationOnView:self.imgBack duration:0.06 rotations:2.0 repeat:CGFLOAT_MAX];
    _loaderView.hidden = NO;
    [[WebClient sharedClient]getAlerts:nil success:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
       _loaderView.hidden = YES;
       [self.imgBack.layer removeAllAnimations];
        if (dictionary!=nil) {
            [_arrAlertList removeAllObjects];
            if([dictionary[@"success"] boolValue] == YES){
                NSArray *data = dictionary[@"alerts"];
                if(data.count!=0){
                    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        Alerts *alerts = [Alerts dataWithInfo:obj];
                        [_arrAlertList addObject:alerts];
                    }];
                }
                [_tblList reloadData];
            }else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
                _loaderView.hidden = YES;
                [self.imgBack.layer removeAllAnimations];
            }
        }
        _lblNoRecordFound.hidden = _arrAlertList.count!=0;
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
        _lblNoRecordFound.hidden = _arrAlertList.count!=0;
        _loaderView.hidden = YES;
        [self.imgBack.layer removeAllAnimations];
    }];
}

#pragma mark - UITableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrAlertList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"AlertCell";
    AlertCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AlertCell" owner:self options:nil] objectAtIndex:0];
    
    Alerts *alert = _arrAlertList[indexPath.row];
    cell.alerts = alert;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    GenInfo *genInfo = _arrInfo[indexPath.row];
//    InfoDetailViewController *infoDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoDetailViewController"];
//    infoDetailViewController.genInfo = genInfo;
//    [self.navigationController pushViewController:infoDetailViewController animated:YES];
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
