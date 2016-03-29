//
//  HomeViewController.m
//  HairForSure
//
//  Created by Manish on 26/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "HomeViewController.h"
#import "REFrostedViewController.h"
#import "YSLContainerViewController.h"
#import "HistoryViewController.h"
#import "ProgressViewController.h"
#import "PhotoViewController.h"
#import "AppDelegate.h"
#import "Helper.h"
#import "SQLiteManager.h"
#import "WebClient.h"
#import "Day.h"
#import "NSDate+Calendar.h"
#import "Helper.h"
#import "NSString+extras.h"
#import "UIViewController+Additions.h"
#import "UtilityManager.h"

#define HOURS_CHANGE_WEATHER        1

@interface HomeViewController ()<YSLContainerViewControllerDelegate>
{
    AppDelegate *app;
}

@property (strong, nonatomic) IBOutlet UIView *mainView;

@end

@implementation HomeViewController

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
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    HistoryViewController *historyView = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
    historyView.title = @"TRACKING";
    ProgressViewController *progressView = [self.storyboard instantiateViewControllerWithIdentifier:@"ProgressViewController"];
    progressView.title = @"PROGRESS";
    PhotoViewController *photoView = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoViewController"];
    photoView.title = @"PHOTOS";
    
    self.containerVC = [[YSLContainerViewController alloc]initWithControllers:@[historyView,progressView,photoView]topBarHeight:0.0 parentViewController:self];
    self.containerVC.menuItemFont = [UIFont fontWithName:@"Roboto-Regular" size:14];
    self.containerVC.menuItemTitleColor = [UIColor darkGrayColor];
    self.containerVC.menuItemSelectedTitleColor = [UIColor colorWithRed:170.0/255.0 green:147.0/255.0 blue:98.0/255.0 alpha:1.0];
    self.containerVC.delegate = self;
    [self.mainView addSubview:self.containerVC.view];
    if ([Helper getIntFromNSUserDefaults:kScrollIndex] == 1) {
        [self.containerVC scrollToViewAtIndex:2];
        [Helper addIntToUserDefaults:0 forKey:kScrollIndex];
    }    
}

#pragma mark - Button Click Event

- (IBAction)btnMenuTapped:(id)sender{
    if ([UtilityManager isConnectedToNetwork] == NO || [UtilityManager isDataSourceAvailable] == NO) {
        [Helper addCustomObjectToUserDefaults:app.arrOfWeeks key:@"WeekArray"];
    }
    else
    {
        if ([self isCallOnceInADay])
            [self callWS];
    }
    
    [Helper addCustomObjectToUserDefaults:app.arrOfWeeks key:@"WeekArray"];
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

- (NSInteger)differenceOfWeather{
    Day *day = [[Day alloc]init];

    NSDate *date1 = [Helper getDateFromString:day.strUpdatedDate withFormat:@"yyyy-MM-dd hh:mm:ss a"];
    NSDate *date2 = [NSDate date];
    NSTimeInterval dateDiff = [date1 timeIntervalSinceDate:date2];
    NSInteger hours = dateDiff/3600;
    return ABS(hours);
}

#pragma mark -- YSLContainerViewControllerDelegate

- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller{
    [controller viewWillAppear:YES];
    if ([UtilityManager isConnectedToNetwork] == NO || [UtilityManager isDataSourceAvailable] == NO) {
        [Helper addCustomObjectToUserDefaults:app.arrOfWeeks key:@"WeekArray"];
    }
    else
    {
        if ([self isCallOnceInADay])
            [self callWS];
    }
    [Helper addCustomObjectToUserDefaults:app.arrOfWeeks key:@"WeekArray"];
}

- (BOOL)isCallOnceInADay
{
    if (![[Helper getFromNSUserDefaults:@"CallOnceInADay"] isEqualToString:[self getDate]])
        return YES;
    else
        return NO;
}

- (NSString *)getDate
{
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"MM-dd-yyyy"];
    return [dtFormat stringFromDate:[NSDate date]];
}

- (void)callWS{
    [Helper addCustomObjectToUserDefaults:app.arrOfWeeks key:@"WeekArray"];
    [Helper addToNSUserDefaults:[self getDate] forKey:@"CallOnceInADay"];
    
    NSDate *trackedDate = [Helper getFromNSUserDefaults:kTrackedDate];
    NSArray *arrJson = [[NSArray arrayWithObject:app.arrOfWeeks] firstObject];
    NSMutableArray *arrayMain = [[NSMutableArray alloc]init];
    NSMutableArray *arrFinal = [[NSMutableArray alloc]init];
    
    for (int i=0; i<arrJson.count; i++) {
        arrFinal= arrJson[i];
        NSMutableArray *array_am =[[NSMutableArray alloc]init];
        [arrFinal enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Day *day = [[Day alloc]init];
            day = arrFinal[idx];
            day.strUpdatedDate = [NSString stringWithFormat:@"%@",[NSDate date]];
            NSDictionary *dictTemp = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:day.isAM],[NSString stringWithFormat:@"day%lu",(unsigned long)idx], nil];
            [array_am addObject:dictTemp];
        }];
        
        NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:array_am options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString2 = [[[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding]trimWhiteSpace];
        jsonString2 = [[jsonString2 stringByReplacingOccurrencesOfString:@"\n" withString:@""] trimWhiteSpace];
        
        NSMutableArray *array_pm =[[NSMutableArray alloc]init];
        [arrFinal enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Day *day = [[Day alloc]init];
            day = arrFinal[idx];
            NSDictionary *dictTemppm = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:day.isPM],[NSString stringWithFormat:@"day%lu",(unsigned long)idx], nil];
            [array_pm addObject:dictTemppm];
        }];
        
        NSData *jsonData3 = [NSJSONSerialization dataWithJSONObject:array_pm options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString3 = [[[NSString alloc] initWithData:jsonData3 encoding:NSUTF8StringEncoding]trimWhiteSpace];
        jsonString3 = [[jsonString3 stringByReplacingOccurrencesOfString:@"\n" withString:@""] trimWhiteSpace];
        
        NSDictionary *dictmain = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:i+1],@"week",jsonString2,@"am_data",jsonString3,@"pm_data", nil];
        [arrayMain addObject:dictmain];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrayMain options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]trimWhiteSpace];
    jsonString = [[jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""] trimWhiteSpace];
    jsonString = [[jsonString stringByReplacingOccurrencesOfString:@"true" withString:@"1"] trimWhiteSpace];
    jsonString = [[jsonString stringByReplacingOccurrencesOfString:@"false" withString:@"0"]trimWhiteSpace];
    
    [[WebClient sharedClient]addUser:@{@"udid":app.strApplicationUUID,@"reportData":jsonString,@"device_id":kdeviceToken,@"device_type":@2,@"start_date":trackedDate, @"isReset":@0} success:^(NSDictionary *dictionary) {
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
}

@end
