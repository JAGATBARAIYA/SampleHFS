//
//  SettingViewController.m
//  HairForSure
//
//  Created by Manish on 25/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "SettingViewController.h"
#import "REFrostedViewController.h"
#import "SettingCell.h"
#import "ReminderViewController.h"
#import "Remindar.h"
#import "SIAlertView.h"
#import "Common.h"
#import "SQLiteManager.h"
#import "Helper.h"
#import "TermsConditionsViewController.h"
#import "WebClient.h"
#import "AppDelegate.h"
#import "TrackedDateViewController.h"

#define kTableName                @"tblRemindar"

@interface SettingViewController ()
{
    AppDelegate *app;
}

@property (strong, nonatomic) IBOutlet UITableView *tblList;
@property (strong, nonatomic) NSMutableArray *arrList;
@property (strong, nonatomic) IBOutlet UIView *loaderView;
@property (strong, nonatomic) IBOutlet UIImageView *imgBack;

@end

@implementation SettingViewController

#pragma mark - View Life Cycle

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
    
    _arrList = [[NSMutableArray alloc]initWithObjects:@"Reminder Day Wise",@"Push Notification",@"Terms & Conditions",@"Reset",nil];
    _tblList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _loaderView.hidden = YES;
}

#pragma mark - Button Click Event

- (IBAction)btnMenuTapped:(id)sender{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

#pragma mark - UITableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IPHONE6PLUS) {
        return 64.0;
    }else {
        return 58.0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SettingCell";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingCell" owner:self options:nil] objectAtIndex:0];
    
    if (indexPath.row == 0)
    {
        if ([Helper getBoolFromUserDefaults:kLocalNotification])
            [cell._switch setOn:YES];
        else
            [cell._switch setOn:NO];
    }
    else if (indexPath.row == 1)
    {
        if ([Helper getBoolFromUserDefaults:kPushNotification])
            [cell._switch setOn:YES];
        else
            [cell._switch setOn:NO];
    }
    
    if (indexPath.row == 2 || indexPath.row == 3) {
        cell.imgView.hidden = NO;
        cell._switch.hidden = YES;
    }
    cell.lblName.text = _arrList[indexPath.row];
    cell._switch.tag = indexPath.row;
    [cell._switch addTarget:self action:@selector(setNotification:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ReminderViewController *reminderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReminderViewController"];
        [self.navigationController pushViewController:reminderViewController animated:YES];
    }
    if (indexPath.row == 2) {
        //        TermsConditionsViewController *tcViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsConditionsViewController"];
        //        [self.navigationController pushViewController:tcViewController animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.athenalife.com/terms-conditions/"]];
    }
    if (indexPath.row == 3) {
        [self resetAllData];
    }
}

#pragma mark - Reset All Data

- (void)resetAllData{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:msgResetTitle andMessage:msgResetDetail];
    alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
    [alertView addButtonWithTitle:@"YES"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {

                              [Helper addIntToUserDefaults:1 forKey:kVisited];
                              [Helper addIntToUserDefaults:1 forKey:kGuideViewDisplay];
                              [Helper addIntToUserDefaults:0 forKey:kScrollIndex];
                              [Helper addIntToUserDefaults:0 forKey:kRemiderGuide];
                              [Helper addIntToUserDefaults:1 forKey:kRemiderVisited];
                              [Helper addIntToUserDefaults:0 forKey:kReminderHand];
                              [Helper addIntToUserDefaults:0 forKey:kProgressHand];
                              [Helper addIntToUserDefaults:0 forKey:kIsFirstTime];
                              [Helper addBoolToUserDefaults:NO forKey:kHistoryGuide];
                              [Helper addBoolToUserDefaults:YES forKey:kLocalNotification];
                              [Helper addBoolToUserDefaults:YES forKey:kPushNotification];
                              
                              app.showHelpView = YES;
                              [[UIApplication sharedApplication] cancelAllLocalNotifications];
                              
                              app.arrOfWeeks = [[NSMutableArray alloc]init];
                              [Helper addCustomObjectToUserDefaults:app.arrOfWeeks key:@"WeekArray"];
                              NSString *updateSQL = [NSString stringWithFormat:@"UPDATE tblRemindar set am = 'AM %@',pm = 'PM %@',isOn = '%@'",@"",@"",@"1"];
                              [[SQLiteManager singleton] executeSql:updateSQL];
                              
                              NSString *deleteSQL = [NSString stringWithFormat: @"delete from tblPhotos"];
                              [[SQLiteManager singleton] executeSql:deleteSQL];
                              [_tblList reloadData];
                              
                              [[TKAlertCenter defaultCenter] postAlertWithMessage:@"User data has been reset successfully!" image:kRightImage];
                              TrackedDateViewController *trackedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TrackedDateViewController"];
                              [self.navigationController pushViewController:trackedViewController animated:NO];

//                              [self resetWSCall];
                          }];
    [alertView addButtonWithTitle:@"NO"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                              
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

- (void)resetWSCall{
    [self runSpinAnimationOnView:self.imgBack duration:0.06 rotations:2.0 repeat:CGFLOAT_MAX];
    _loaderView.hidden = NO;
    
    [[WebClient sharedClient]resetData:@{@"udid":app.strApplicationUUID} success:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        _loaderView.hidden = YES;
        [self.imgBack.layer removeAllAnimations];
        if (dictionary!=nil) {
            if([dictionary[@"success"] boolValue] == YES){
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
                TrackedDateViewController *trackedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TrackedDateViewController"];
                [self.navigationController pushViewController:trackedViewController animated:NO];
            }else {
//                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
                TrackedDateViewController *trackedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TrackedDateViewController"];
                [self.navigationController pushViewController:trackedViewController animated:NO];

                _loaderView.hidden = YES;
                [self.imgBack.layer removeAllAnimations];
            }
        }
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
        _loaderView.hidden = YES;
        [self.imgBack.layer removeAllAnimations];
    }];
}

#pragma mark - Set Push Notification

- (void)setNotification:(UISwitch *)sender
{
    BOOL state = [sender isOn];
    if (sender.tag == 0)
    {
        if (state)
        {
            for (NSDictionary *aDict in [[SQLiteManager singleton]findAllFrom:kTableName])
            {
                NSInteger aTag = [aDict[@"dayName"] isEqualToString:[@"sunday" uppercaseString]] ? 1 : [aDict[@"remID"] integerValue]+1;
                
                if ([aDict[@"am"] length] > 2)
                {
                    NSString *strTime = [[aDict[@"am"] componentsSeparatedByString:@" "] lastObject];
                    NSDate *aDate = [self getDateFromWeekDay:aTag];
                    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
                    [dtFormat setDateFormat:@"dd/MM/yyyy"];
                    NSString *aString = [[dtFormat stringFromDate:aDate] stringByAppendingFormat:@" %@ AM",strTime];
                    [dtFormat setDateFormat:@"dd/MM/yyyy hh:mm a"];
                    NSDate *aFinalDate = [dtFormat dateFromString:aString];
                    
                    [self setLocalNotificationWithDate:aFinalDate withNotificationTitle:aDict[@"remID"] Meridiem:@"AM" isOn:aDict[@"isOn"]];
                }
                
                if ([aDict[@"pm"] length] > 2)
                {
                    NSString *strTime = [[aDict[@"pm"]  componentsSeparatedByString:@" "] lastObject];
                    NSDate *aDate = [self getDateFromWeekDay:aTag];
                    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
                    [dtFormat setDateFormat:@"dd/MM/yyyy"];
                    NSString *aString = [[dtFormat stringFromDate:aDate] stringByAppendingFormat:@" %@ PM",strTime];
                    [dtFormat setDateFormat:@"dd/MM/yyyy hh:mm a"];
                    NSDate *aFinalDate = [dtFormat dateFromString:aString];
                    
                    [self setLocalNotificationWithDate:aFinalDate withNotificationTitle:aDict[@"remID"] Meridiem:@"PM" isOn:aDict[@"isOn"]];
                }
            }
            
            [Helper addBoolToUserDefaults:state forKey:kLocalNotification];
            ReminderViewController *reminderViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"ReminderViewController"];
            [self.navigationController pushViewController:reminderViewController animated:YES];
        }
        else
        {
            [Helper addBoolToUserDefaults:state forKey:kLocalNotification];
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }
    }else if (sender.tag == 1){
        [self callPushNotification];
    }
}

- (void)callPushNotification{
    [[WebClient sharedClient]setNotification:@{@"udid":app.strApplicationUUID} success:^(NSDictionary *dictionary) {
        if ([dictionary[@"success"] boolValue] == YES) {
            //                    [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
            if ([dictionary[@"notificationstatus"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                [Helper addBoolToUserDefaults:NO forKey:kPushNotification];
            }else if ([dictionary[@"notificationstatus"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                [Helper addBoolToUserDefaults:YES forKey:kPushNotification];
            }
            [_tblList reloadData];
        }else{
            [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
        }
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
    }];
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

#pragma mark - UserDefine Methods

- (NSDate *)getDateFromWeekDay:(NSInteger)intDay
{
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [NSDate date];
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    NSInteger todayWeekday = [weekdayComponents weekday];
    
    NSInteger moveDays=intDay-todayWeekday;
    if (moveDays<=0)
    {
        moveDays+=7;
    }
    
    NSDateComponents *components = [NSDateComponents new];
    components.day=moveDays;
    
    NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDate* newDate = [calendar dateByAddingComponents:components toDate:date options:0];
    
    return newDate;
}

-(void)setLocalNotificationWithDate:(NSDate *)pDateTime withNotificationTitle:(NSString *)pStrNotificationTitle Meridiem:(NSString *)strMeridiem isOn:(NSString *)strOn
{
    Class cls = NSClassFromString(@"UILocalNotification");
    
    if (pDateTime != nil)
    {
        if (cls != nil)
        {
            UILocalNotification *aLocalNotification = [[cls alloc] init];
            
            NSMutableArray *aMutNotifArray = [[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication] scheduledLocalNotifications]];
            
            [aLocalNotification setRepeatInterval: NSWeekCalendarUnit];
            [aLocalNotification setTimeZone:[NSTimeZone systemTimeZone]];
            [aLocalNotification setFireDate:pDateTime];
            [aLocalNotification setAlertBody:@"Reminder Call"];
            [aLocalNotification setAlertAction:@"Show me"];
            [aLocalNotification setSoundName:UILocalNotificationDefaultSoundName];
            
            NSInteger weekday = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:pDateTime] weekday];
            
            [aLocalNotification setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[@(weekday) stringValue], @"Day", strMeridiem, @"Meridiem", nil]];
            
            for (UILocalNotification *aNotification in aMutNotifArray)
            {
                if ([aNotification.userInfo[@"Day"] isEqualToString:[@(weekday) stringValue]])
                {
                    if ([aNotification.userInfo[@"Meridiem"] isEqualToString:strMeridiem])
                        [[UIApplication sharedApplication] cancelLocalNotification:aNotification];
                }
            }
            
            if ([strOn isEqualToString:@"1"])
            {
                [[UIApplication sharedApplication] scheduleLocalNotification:aLocalNotification];
            }
        }
    }
    
    NSLog(@"%@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
}

@end
