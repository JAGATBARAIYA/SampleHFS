
//
//  HistoryViewController.m
//  HairForSure
//
//  Created by Manish on 30/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "HistoryViewController.h"
#import "CollectionCell.h"
#import "NSDate+Calendar.h"
#import "Day.h"
#import "Common.h"
#import "Helper.h"
#import "AppDelegate.h"
#import "WebClient.h"
#import "UtilityManager.h"
#import "NSString+extras.h"

@interface HistoryViewController ()
{
    AppDelegate *app;
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentDate;
@property (strong, nonatomic) IBOutlet UILabel *lblWeekNo;
@property (strong, nonatomic) NSDate *date;

@end

@implementation HistoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [Helper addBoolToUserDefaults:YES forKey:@"PageViewFirstTime"];
    [self commonInit];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)commonInit{
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.arrOfWeeks = [Helper getCustomObjectToUserDefaults:@"WeekArray"];
    _collectionView.userInteractionEnabled = YES;
    _collectionView.scrollEnabled = YES;

    if (app.arrOfWeeks.count == 0) {
        [self showUser];
    }
    [self setDefaultData];

    if ([UtilityManager isConnectedToNetwork] == NO || [UtilityManager isDataSourceAvailable] == NO) {
        [Helper addCustomObjectToUserDefaults:app.arrOfWeeks key:@"WeekArray"];
    }else {
        if ([self isCallOnceInADay])
            [self callWS];
    }
}

- (void)setDefaultData {
    _date = [[NSDate date] dateDayStart];
//    _date = [_date dateByAddingDays:25];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = kDateFormat;
    NSString *string = [formatter stringFromDate:_date];
    _lblCurrentDate.text = string;
    
    NSDate *trackedDate = [[Helper getFromNSUserDefaults:kTrackedDate] dateDayStart];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:trackedDate toDate:_date options:0];
    NSInteger numberOfDaysInWeek = 7;
    NSInteger numberOfWeek = ceil(components.weekday / (CGFloat)numberOfDaysInWeek);
    if([[trackedDate dateByAddingWeek:numberOfWeek] isEqualToDate:_date]) {
        numberOfWeek += 1;
    }
    NSInteger weekCount = 0;
    
    app.arrOfWeeks = [Helper getCustomObjectToUserDefaults:@"WeekArray"];
    if (!app.arrOfWeeks) {
        app.arrOfWeeks = [[NSMutableArray alloc] init];
    }
    if([app.arrOfWeeks count]) {
        weekCount = [app.arrOfWeeks count];
    }
    if (numberOfWeek!=0) {
        for (NSInteger i = weekCount; i<numberOfWeek; i++) {
            NSMutableArray *arrDays = [[NSMutableArray alloc] init];
            for (NSInteger j=0; j<numberOfDaysInWeek; j++) {
                Day *day = [[Day alloc] init];
                day.date = [trackedDate dateByAddingDays:j + (i*numberOfDaysInWeek)];
                day.dayName = [day.date dayName];
                day.dayNumber = [day.date day];
                day.weekNumber = [day.date weekOfMonth];
                day.isAM = FALSE;
                day.isPM = FALSE;
                [arrDays addObject:day];
            }
            [app.arrOfWeeks addObject:arrDays];
        }
    }
    if ([UtilityManager isConnectedToNetwork] == NO || [UtilityManager isDataSourceAvailable] == NO) {
        [Helper addCustomObjectToUserDefaults:app.arrOfWeeks key:@"WeekArray"];
    }
    else
    {
        if ([self isCallOnceInADay])
            [self callWS];
    }
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
    
    [[WebClient sharedClient]addUser:@{@"udid":app.strApplicationUUID,@"reportData":jsonString,@"device_id":kdeviceToken,@"device_type":@2,@"start_date":trackedDate} success:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        if (dictionary!=nil) {
            if([dictionary[@"success"] boolValue] == YES){
                //[[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
            }else {
                //[[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
            }
        }
        [_collectionView reloadData];
    } failure:^(NSError *error) {
        //[[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
    }];
}

- (void)showUser{
    _date = [[NSDate date] dateDayStart];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = kDateFormat;
    NSString *string = [formatter stringFromDate:_date];
    _lblCurrentDate.text = string;

    [[WebClient sharedClient]showUser:@{@"udid":app.strApplicationUUID, @"isReset":@1} success:^(NSDictionary *dictionary) {
        NSDictionary *dictUserData = dictionary[@"user_data"];
        NSString *savedDate = [NSString stringWithFormat:@"%@",dictUserData[@"start_date"]];
        if([savedDate length] > 0 &&
           ![savedDate isEqual:[NSNull null]] &&
           ![savedDate isEqualToString:@"<null>"]) {
            NSDate *trackedDate =[[Helper getDateFromString:savedDate withFormat:@"yyyy-MM-dd HH:mm:ss"]dateDayStart];
            [Helper addToNSUserDefaults:trackedDate forKey:kTrackedDate];
            NSInteger numberOfDaysInWeek = 7;

            NSDictionary *dictWeeks = dictUserData[@"week"];
            if ([dictWeeks count]) {
                [app.arrOfWeeks removeAllObjects];
                for (NSInteger i = 0; i < [dictWeeks count]; i++){
                    NSDictionary *dictAMPM = dictWeeks[[@(i+1) stringValue]];
                    NSMutableArray *arrDays = [[NSMutableArray alloc] init];
                    for (NSInteger j=0; j<numberOfDaysInWeek; j++) {
                        Day *day = [[Day alloc] init];
                        day.date = [trackedDate dateByAddingDays:j + (i*numberOfDaysInWeek)];
                        day.dayName = [day.date dayName];
                        day.dayNumber = [day.date day];
                        day.weekNumber = [day.date weekOfMonth];
                        day.isAM = [[[dictAMPM valueForKey:@"am_data"] valueForKey:[NSString stringWithFormat:@"day%ld",(long)j]]boolValue];
                        day.isPM = [[[dictAMPM valueForKey:@"pm_data"] valueForKey:[NSString stringWithFormat:@"day%ld",(long)j]]boolValue];
                        
                        [arrDays addObject:day];
                    }
                    [app.arrOfWeeks addObject:arrDays];
                }
                [self addWeek];
            }else{
                [Helper addToNSUserDefaults:[NSDate date] forKey:kTrackedDate];
                [self setDefaultData];
            }
            [_collectionView reloadData];
        }
        else {
            [self setDefaultData];
        }
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

- (void)addWeek{
    NSDate *trackedDate = [[Helper getFromNSUserDefaults:kTrackedDate] dateDayStart];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:trackedDate toDate:_date options:0];
    NSInteger numberOfDaysInWeek = 7;
    NSInteger numberOfWeek = ceil(components.weekday / (CGFloat)numberOfDaysInWeek);
    if([[trackedDate dateByAddingWeek:numberOfWeek] isEqualToDate:_date]) {
        numberOfWeek += 1;
    }
    NSInteger weekCount = 0;
    
    app.arrOfWeeks = [Helper getCustomObjectToUserDefaults:@"WeekArray"];
    if (!app.arrOfWeeks) {
        app.arrOfWeeks = [[NSMutableArray alloc] init];
    }
    if([app.arrOfWeeks count]) {
        weekCount = [app.arrOfWeeks count];
    }
    if (numberOfWeek!=0) {
        for (NSInteger i = weekCount; i<numberOfWeek; i++) {
            NSMutableArray *arrDays = [[NSMutableArray alloc] init];
            for (NSInteger j=0; j<numberOfDaysInWeek; j++) {
                Day *day = [[Day alloc] init];
                day.date = [trackedDate dateByAddingDays:j + (i*numberOfDaysInWeek)];
                day.dayName = [day.date dayName];
                day.dayNumber = [day.date day];
                day.weekNumber = [day.date weekOfMonth];
                day.isAM = FALSE;
                day.isPM = FALSE;
                [arrDays addObject:day];
            }
            [app.arrOfWeeks addObject:arrDays];
        }
    }
}

#pragma mark - CollectionView Delegate Method

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    _pageControl.numberOfPages = [app.arrOfWeeks count];
    return [app.arrOfWeeks count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    [cell setData:[app.arrOfWeeks objectAtIndex:indexPath.row]];

    if ([Helper getBoolFromUserDefaults:@"PageViewFirstTime"]) {
        [cell setData:[app.arrOfWeeks objectAtIndex:app.arrOfWeeks.count - 1]];
        _pageControl.currentPage = app.arrOfWeeks.count - 1;
        
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:app.arrOfWeeks.count - 1 inSection:0];
        [_collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:NO];
        
        CGFloat pageNo = self.collectionView.contentOffset.x / _collectionView.frame.size.width;
        _pageControl.currentPage = pageNo;
        NSString *str;
        if (pageNo == 0) {
            str = @"ST";
        }else if (pageNo == 1){
            str = @"ND";
        }else if (pageNo == 2){
            str = @"RD";
        }else{
            str = @"TH";
        }
        _lblWeekNo.text = [NSString stringWithFormat:@"%ld%@ WEEK",(long)pageNo + 1,str];

    }else{
        
    }
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {

}

#pragma mark - Scroll View delegate methods

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [Helper addBoolToUserDefaults:NO forKey:@"PageViewFirstTime"];
    
    CGFloat pageNo = self.collectionView.contentOffset.x / _collectionView.frame.size.width;
    _pageControl.currentPage = pageNo;
    NSString *str;
    if (pageNo == 0) {
        str = @"ST";
    }else if (pageNo == 1){
        str = @"ND";
    }else if (pageNo == 2){
        str = @"RD";
    }else{
        str = @"TH";
    }
    _lblWeekNo.text = [NSString stringWithFormat:@"%ld%@ WEEK",(long)pageNo + 1,str];
}


//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    [Helper addBoolToUserDefaults:NO forKey:@"PageViewFirstTime"];
//
//    CGFloat pageNo = self.collectionView.contentOffset.x / _collectionView.frame.size.width;
//    _pageControl.currentPage = pageNo;
//    NSString *str;
//    if (pageNo == 0) {
//        str = @"ST";
//    }else if (pageNo == 1){
//        str = @"ND";
//    }else if (pageNo == 2){
//        str = @"RD";
//    }else{
//        str = @"TH";
//    }
//    _lblWeekNo.text = [NSString stringWithFormat:@"%ld%@ WEEK",(long)pageNo + 1,str];
//}

@end
