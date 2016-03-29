//
//  MenuViewController.m
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 20/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"
#import "Helper.h"
#import "ViewController.h"
#import "DEMONavigationController.h"
#import "AppDelegate.h"
#import "WebClient.h"
#import "HomeViewController.h"
#import "ContactUsViewController.h"
#import "HelpViewController.h"
#import "GenralInfoViewController.h"
#import "AlertViewController.h"
#import "SettingViewController.h"
#import "BuyProductViewController.h"
#import "TrackedDateViewController.h"
#import "ShareViewController.h"

@interface MenuViewController ()
{
    AppDelegate *app;
}

@property (strong, nonatomic) IBOutlet UITableView *tblList;
@property (strong, nonatomic) NSArray *arrMenuItems;

@end

@implementation MenuViewController

#pragma mark - View life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{
    [_tblList reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _arrMenuItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"]];
    _tblList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IPHONE6PLUS) {
        return 70;
    }else {
        return 60;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrMenuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MenuCell";
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil] objectAtIndex:0];
    
    NSDictionary *dict = _arrMenuItems[indexPath.row];
    cell.lblMenuName.text = dict[@"name"];
    cell.imgMenu.image = [UIImage imageNamed:dict[@"ImgName"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DEMONavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    switch (indexPath.row) {
        case 0:
        {
            NSLog(@"%ld",(long)[Helper getIntFromNSUserDefaults:kGuideViewDisplay]);
            if ([Helper getIntFromNSUserDefaults:kGuideViewDisplay] == 1) {
                TrackedDateViewController *trackedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TrackedDateViewController"];
                navigationController.viewControllers = @[trackedViewController];
            }else{
                HomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                navigationController.viewControllers = @[homeViewController];
            }
        }
            break;
        case 1:
        {
            GenralInfoViewController *genInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GenralInfoViewController"];
            navigationController.viewControllers = @[genInfoViewController];
        }
            break;
        case 2:
        {
            AlertViewController *alertViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
            navigationController.viewControllers = @[alertViewController];
        }
            break;
        case 3:
        {
//            BuyProductViewController *buyProductViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BuyProductViewController"];
//            navigationController.viewControllers = @[buyProductViewController];
//            _strController = @"BuyProductViewController";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.athenalife.com/shop/hair-for-sure-hair-tonic.html"]];
        }
            break;
        case 4:
        {
            SettingViewController *settingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
            navigationController.viewControllers = @[settingViewController];
        }
            break;
        case 5:
        {
            HelpViewController *helpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpViewController"];
            navigationController.viewControllers = @[helpViewController];
        }
            break;
        case 6:
        {
            ContactUsViewController *contactUsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
            navigationController.viewControllers = @[contactUsViewController];
        }
            break;

        default:
            break;
    }
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

@end
