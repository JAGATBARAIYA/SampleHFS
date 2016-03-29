//
//  ReminderViewController.m
//  HairForSure
//
//  Created by Manish on 26/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "ReminderViewController.h"
#import "ReminderCell.h"
#import "TimeView.h"
#import "CustomTimePicker.h"
#import "Remindar.h"
#import "SQLiteManager.h"
#import "NSDate+Calendar.h"
#import "Helper.h"
#import "HomeViewController.h"
#import "PhotoTipsViewController.h"
#import <objc/runtime.h>

#define kTableName                @"tblRemindar"

@interface ReminderViewController ()<TimeViewDelegate>
{
    NSInteger remindarID;
    NSDate *alermDate;
    BOOL isAll;
}

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) IBOutlet UIView *helpView;
@property (strong, nonatomic) NSMutableArray *arrDay;
@property (strong, nonatomic) TimeView *timeView;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UIButton *btnSkip;

@property (assign, nonatomic) BOOL isAM;

@end

@implementation ReminderViewController

CustomTimePicker *clockView;
UIButton *initiateClock = nil;
UILabel * hourLabel = nil;

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
    _arrDay = [[NSMutableArray alloc]init];
    [_arrDay removeAllObjects];
    NSArray *data  = [[SQLiteManager singleton]findAllFrom:kTableName];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Remindar *photo = [Remindar dataWithInfo:obj];
        [_arrDay addObject:photo];
    }];
    _tblView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_tblView reloadData];
    if (_isShow) {
        _btnSkip.hidden = _btnNext.hidden = _lblTitle.hidden = NO;
    }else{
        _btnSkip.hidden = _btnNext.hidden = _lblTitle.hidden = YES;
        _tblView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    }
    
    if ([Helper getIntFromNSUserDefaults:kReminderHand] == 1) {
        _helpView.hidden = YES;
    }else{
        _helpView.hidden = NO;
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

#pragma mark - UITableView Delegate Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IPHONE6PLUS) {
        return 76.0;
    }else {
        return 74.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrDay.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ReminderCell";
    ReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReminderCell" owner:self options:nil] objectAtIndex:0];
    
    Remindar *remindar = _arrDay[indexPath.row];
    cell.lblDay.text = remindar.strDayName;
    cell.lblTimeAM.text = remindar.strAM;
    cell.lblTimePM.text = remindar.strPM;
    cell.btnAM.tag = indexPath.row;
    cell.btnPM.tag = indexPath.row;
    
    if (indexPath.row == _arrDay.count-1)
        cell.isOn.tag = 1;
    else
        cell.isOn.tag = indexPath.row+2;
    
    if (remindar.isSwitchOn)
        [cell.isOn setOn:YES];
    else
        [cell.isOn setOn:NO];
    
    [cell.btnAM addTarget:self action:@selector(btnAMTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnPM addTarget:self action:@selector(btnPMTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.isOn addTarget:self action:@selector(setNotificationOnOff:) forControlEvents:UIControlEventValueChanged];
    
    objc_setAssociatedObject(cell.btnAM, @"Remindar", remindar, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(cell.btnPM, @"Remindar", remindar, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(cell.isOn, @"Remindar", remindar, OBJC_ASSOCIATION_RETAIN);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

-(void)showClockView:(NSString *)str{
    _timeView = [[NSBundle mainBundle] loadNibNamed:@"TimeView" owner:self options:nil][0];
    _timeView.delegate = self;
    _timeView.lblAMPM.text = str;
    [self.view addSubview:_timeView];
    _timeView.frame = self.view.bounds;
}

#pragma mark - Button Click Event

- (IBAction)btnBackTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSkipTapped:(id)sender{
    PhotoTipsViewController *photoTipsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoTipsViewController"];
    photoTipsViewController.isFirstTime = YES;
    [Helper addIntToUserDefaults:0 forKey:kRemiderVisited];
    [Helper addIntToUserDefaults:2 forKey:kGuideViewDisplay];
    [Helper addIntToUserDefaults:1 forKey:kScrollIndex];

    [self.navigationController pushViewController:photoTipsViewController animated:YES];
}

- (IBAction)btnNextTapped:(id)sender{
    PhotoTipsViewController *photoTipsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoTipsViewController"];
    photoTipsViewController.isFirstTime = YES;
    [Helper addIntToUserDefaults:0 forKey:kRemiderVisited];
    [Helper addIntToUserDefaults:2 forKey:kGuideViewDisplay];
    [Helper addIntToUserDefaults:1 forKey:kScrollIndex];

    [self.navigationController pushViewController:photoTipsViewController animated:YES];
}

- (void)btnAMTapped:(UIButton *)sender{
    UIButton *btn = sender;
    Remindar *rem = objc_getAssociatedObject(btn, @"Remindar");
    [Helper addToNSUserDefaults:rem.strAM forKey:@"AM"];
    [Helper addToNSUserDefaults:rem.strPM forKey:@"PM"];
    _isAM = YES;
    remindarID = sender.tag + 1;
    [self nextDay:sender.tag dayName:rem.strDayName];
    [self showClockView:@"AM"];
}

- (void)btnPMTapped:(UIButton *)sender{
    UIButton *btn = sender;
    Remindar *rem = objc_getAssociatedObject(btn, @"Remindar");

    [Helper addToNSUserDefaults:rem.strAM forKey:@"AM"];
    [Helper addToNSUserDefaults:rem.strPM forKey:@"PM"];
    _isAM = NO;
    remindarID = sender.tag + 1;
    [self nextDay:sender.tag dayName:rem.strDayName];
    [self showClockView:@"PM"];
}

- (void)nextDay:(NSInteger)tag dayName:(NSString *)dayName{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *dayname = [[dateFormatter stringFromDate:now]uppercaseString];
    
    if ([dayname isEqualToString:dayName]) {
        alermDate = now;
    }else{
        NSDate *weekStart = [now dateWeekStart];
        if ([weekStart day] > [now day]) {
        }
        NSInteger daysToMonday = (9 - [now weekday]) % 7;
        NSDate *mondayDate = [now dateByAddingDays:daysToMonday];
        NSDate *thisWeekMondayDate = [mondayDate dateByAddingDays:-7];
        alermDate = [thisWeekMondayDate dateByAddingDays:tag];
        if([alermDate isLessDate:[NSDate date]]) {
            alermDate = [alermDate dateByAddingDays:7];
        }        
    }
}

#pragma mark - Delegate Method

- (void)timeView:(TimeView *)view{
    [view removeFromSuperview];
    _helpView.hidden = YES;
    [Helper addIntToUserDefaults:1 forKey:kReminderHand];
    NSString *strAM, *strPM;
    NSArray *arr = [view.lblCurrentTime.text componentsSeparatedByString:@":"];
    
    NSDate *currentDate = alermDate;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:[currentDate day]];
    [comps setMonth:[currentDate month]];
    [comps setYear:[currentDate year]];
    NSInteger dd = [arr[0] integerValue];
    
    if (!_isAM) {
        if (dd < 12) {
            dd = dd + 12;
        }
    }
    
    [comps setHour:dd];
    [comps setMinute:[arr[1] integerValue]];
    [comps setSecond:00];

    if (_isAM) {
        strAM = [NSString stringWithFormat:@"AM %@",view.lblCurrentTime.text];
        strPM = [Helper getFromNSUserDefaults:@"PM"];
    }else{
        strPM = [NSString stringWithFormat:@"PM %@",view.lblCurrentTime.text];
        strAM = [Helper getFromNSUserDefaults:@"AM"];
    }
    
    if (view.btnApply.selected) {
        isAll = YES;
        NSString *updateSQL;
        if (_isAM) {
            updateSQL = [NSString stringWithFormat:@"UPDATE tblRemindar set am = '%@'",strAM];
        }else{
            updateSQL = [NSString stringWithFormat:@"UPDATE tblRemindar set pm = '%@'",strPM];
        }
        [[SQLiteManager singleton] executeSql:updateSQL];
    }else if (view.btnDone.selected){
        isAll = NO;
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE tblRemindar set am = '%@',pm = '%@'  WHERE remID = %ld",strAM,strPM,(long)remindarID];
        [[SQLiteManager singleton] executeSql:updateSQL];
    }
    
    [self commonInit];
    [_tblView reloadData];

    [self setLocalNotificationWithDate:[[NSCalendar currentCalendar] dateFromComponents:comps] withNotificationTitle:[NSString stringWithFormat:@"%ld",(long)remindarID]];
}

#pragma mark - Remindar Delegate Method

-(void)setLocalNotificationWithDate:(NSDate *)pDateTime withNotificationTitle:(NSString *)pStrNotificationTitle
{
    Class cls = NSClassFromString(@"UILocalNotification");
    
    if (pDateTime != nil) {
        if (cls != nil)
        {
            UILocalNotification *aLocalNotification = [[cls alloc] init];
            
            NSMutableArray *aMutNotifArray = [[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication] scheduledLocalNotifications]];
            
            if (isAll)
            {
                NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
                [dtFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
                NSString *strDate = [dtFormat stringFromDate:pDateTime];
                strDate = [[strDate componentsSeparatedByString:@" "] lastObject];
                [dtFormat setDateFormat:@"dd/MM/yyyy"];
                strDate = [[dtFormat stringFromDate:[NSDate date]] stringByAppendingFormat:@" %@", strDate];
                [dtFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
                pDateTime = [dtFormat dateFromString:strDate];
                
                for (int aIndex = 0; aIndex < 7; aIndex++)
                {
                    [aLocalNotification setRepeatInterval: NSWeekCalendarUnit];
                    [aLocalNotification setTimeZone:[NSTimeZone systemTimeZone]];
                    [aLocalNotification setFireDate:pDateTime];
                    [aLocalNotification setAlertBody:@"Reminder Call"];
                    [aLocalNotification setAlertAction:@"Show me"];
                    [aLocalNotification setSoundName:UILocalNotificationDefaultSoundName];
                    
                    NSInteger weekday = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:pDateTime] weekday];
                    
                    [aLocalNotification setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[@(weekday) stringValue], @"Day", _isAM?@"AM":@"PM", @"Meridiem", nil]];
                    
                    for (UILocalNotification *aNotification in aMutNotifArray)
                    {
                        if ([aNotification.userInfo[@"Day"] isEqualToString:[@(weekday) stringValue]])
                        {
                            if ([aNotification.userInfo[@"Meridiem"] isEqualToString:_isAM?@"AM":@"PM"])
                                [[UIApplication sharedApplication] cancelLocalNotification:aNotification];
                        }
                    }
                    
                    Remindar *remindar;
                    
                    if (weekday == 1)
                        remindar = _arrDay[6];
                    else if (weekday == 2)
                        remindar = _arrDay[0];
                    else if (weekday == 3)
                        remindar = _arrDay[1];
                    else if (weekday == 4)
                        remindar = _arrDay[2];
                    else if (weekday == 5)
                        remindar = _arrDay[3];
                    else if (weekday == 6)
                        remindar = _arrDay[4];
                    else if (weekday == 7)
                        remindar = _arrDay[5];
                    
                    if (remindar.isSwitchOn)
                    {
                        if ([Helper getBoolFromUserDefaults:kLocalNotification])
                        {
                            [[UIApplication sharedApplication] scheduleLocalNotification:aLocalNotification];
                        }
                    }
                    pDateTime = [pDateTime dateByAddingDays:1];
                }
            }
            else
            {
                [aLocalNotification setRepeatInterval: NSWeekCalendarUnit];
                [aLocalNotification setTimeZone:[NSTimeZone systemTimeZone]];
                [aLocalNotification setFireDate:pDateTime];
                [aLocalNotification setAlertBody:@"Reminder Call"];
                [aLocalNotification setAlertAction:@"Show me"];
                [aLocalNotification setSoundName:UILocalNotificationDefaultSoundName];
                
                NSInteger weekday = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:pDateTime] weekday];
                
                [aLocalNotification setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[@(weekday) stringValue], @"Day",_isAM?@"AM":@"PM", @"Meridiem", nil]];
                
                for (UILocalNotification *aNotification in aMutNotifArray)
                {
                    if ([aNotification.userInfo[@"Day"] isEqualToString:[@(weekday) stringValue]])
                    {
                        if ([aNotification.userInfo[@"Meridiem"] isEqualToString:_isAM?@"AM":@"PM"])
                            [[UIApplication sharedApplication] cancelLocalNotification:aNotification];
                    }
                }
                
                ReminderCell *aCell = (ReminderCell *)[_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:remindarID-1 inSection:0]];
                
                if (aCell.isOn.isOn)
                {
                    if ([Helper getBoolFromUserDefaults:kLocalNotification])
                    {
                        [[UIApplication sharedApplication] scheduleLocalNotification:aLocalNotification];
                    }
                }
            }
        }
    }
    
    NSLog(@"%@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
}

#pragma mark - Set Local Notification

- (void)setNotificationOnOff:(UISwitch *)sender
{
    BOOL state = [sender isOn];
    
    ReminderCell *aCell;
    
    if (isIOS8)
        aCell = (ReminderCell *)sender.superview.superview;
    else
        aCell = (ReminderCell *)sender.superview.superview.superview;
    
    NSString *strTag = [NSString stringWithFormat:@"%ld", (long)aCell.btnAM.tag+1];
    
    if (state)
    {
        NSArray *aMutArray  = [[SQLiteManager singleton]find:@"*" from:kTableName where:[NSString stringWithFormat:@"remID=%@", strTag]];
        isAll = NO;
        
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE tblRemindar set isOn = '%@' WHERE remID = '%@'", @"1", strTag];
        [[SQLiteManager singleton] executeSql:updateSQL];
        
        
        if ([Helper getBoolFromUserDefaults:kLocalNotification])
        {
            if ([[[aMutArray lastObject] valueForKey:@"am"] length] > 2)
            {
                NSString *strTime = [[[[aMutArray lastObject] valueForKey:@"am"] componentsSeparatedByString:@" "] lastObject];
                NSDate *aDate = [self getDateFromWeekDay:sender.tag];
                NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
                [dtFormat setDateFormat:@"dd/MM/yyyy"];
                NSString *aString = [[dtFormat stringFromDate:aDate] stringByAppendingFormat:@" %@ AM",strTime];
                [dtFormat setDateFormat:@"dd/MM/yyyy hh:mm a"];
                NSDate *aFinalDate = [dtFormat dateFromString:aString];
                
                [self setLocalNotificationWithDate:aFinalDate withNotificationTitle:strTag];
            }
            
            if ([[[aMutArray lastObject] valueForKey:@"pm"] length] > 2)
            {
                NSString *strTime = [[[[aMutArray lastObject] valueForKey:@"pm"] componentsSeparatedByString:@" "] lastObject];
                NSDate *aDate = [self getDateFromWeekDay:sender.tag];
                NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
                [dtFormat setDateFormat:@"dd/MM/yyyy"];
                NSString *aString = [[dtFormat stringFromDate:aDate] stringByAppendingFormat:@" %@ PM",strTime];
                [dtFormat setDateFormat:@"dd/MM/yyyy hh:mm a"];
                NSDate *aFinalDate = [dtFormat dateFromString:aString];
                
                [self setLocalNotificationWithDate:aFinalDate withNotificationTitle:strTag];
            }
        }
    }
    else
    {
        NSMutableArray *aMutNotificationArray = [[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication] scheduledLocalNotifications]];
        
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE tblRemindar set isOn = '%@' WHERE remID = '%@'", @"0", strTag];
        [[SQLiteManager singleton] executeSql:updateSQL];
        
        strTag = [@([strTag integerValue]+1) stringValue];
        
        for (UILocalNotification *aNotification in aMutNotificationArray)
        {
            if ([[aNotification.userInfo valueForKey:@"Day"] isEqualToString:strTag])
            {
                [[UIApplication sharedApplication] cancelLocalNotification:aNotification];
            }
        }
    }
    
    [self commonInit];
}

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

@end
