//
//  ProgressViewController.m
//  HairForSure
//
//  Created by Manish on 30/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "ProgressViewController.h"
#import "ProgressCell.h"
#import "NSDate+Calendar.h"
#import "Day.h"
#import "Common.h"
#import "Helper.h"
#import "AppDelegate.h"

#define kYMaxValue 14

@interface ProgressViewController ()<UIGestureRecognizerDelegate>
{
    NSMutableArray *arrSelectedWeekDays;
    BOOL isOpenClose;
    AppDelegate *app;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *lblNoRecordFound;
@property (strong, nonatomic) IBOutlet UIView *helpView;
@property (strong, nonatomic) IBOutlet UILabel *imgWeekly;
@property (strong, nonatomic) IBOutlet UILabel *lblWeekly;

@property (strong, nonatomic) NSDate *date;

@property (nonatomic) PNBarChart * barChart;

@property (strong, nonatomic) IBOutlet UIView *chartView;
@property (strong, nonatomic) IBOutlet UIView *historyView;

@end

@implementation ProgressViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    arrData = [[NSMutableArray alloc] init];
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;

    if (IPHONE4) {
        self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 380)];
        _imgWeekly.frame = CGRectMake(20, 315, 10, 10);
        _lblWeekly.frame = CGRectMake(38, 310, 43, 21);
        
        _historyView.frame = CGRectMake(0, -300, 320, 300);
    }else if (IPHONE5) {
        self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 450)];
        _historyView.frame = CGRectMake(0, -300, 320, 300);
    }else if (IPHONE6){
        self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 550)];
        _historyView.frame = CGRectMake(0, -400, 320, 400);
    }else if (IPHONE6PLUS){
        self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 620)];
        _historyView.frame = CGRectMake(0, -500, 320, 500);
    }
    
    self.barChart.delegate = self;
    self.barChart.backgroundColor = [UIColor clearColor];
    self.barChart.labelMarginTop = 5.0;
    self.barChart.showChartBorder = YES;
    [self.barChart setStrokeColor:PNGGolden];
    self.barChart.isGradientShow = NO;
    self.barChart.isShowNumbers = NO;
    self.barChart.yLabelFormatter = ^(CGFloat yValue){
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%0.f",yValueParsed];
        return labelText;
    };
    
    NSMutableArray *arrYLabels = [NSMutableArray array];
    for (NSInteger i=0; i<= kYMaxValue; i++) {
        [arrYLabels addObject:@(i)];
    }
    [self.barChart setYLabels:arrYLabels];
    
    [_chartView addSubview:self.barChart];
    [self.barChart strokeChart];
    
    UISwipeGestureRecognizer *recognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
    recognizer1.direction = UISwipeGestureRecognizerDirectionUp;
    recognizer1.delegate = self;
    [_chartView addGestureRecognizer:recognizer1];
    
    UISwipeGestureRecognizer *recognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
    recognizer2.direction = UISwipeGestureRecognizerDirectionDown;
    recognizer2.delegate = self;
    [_chartView addGestureRecognizer:recognizer2];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizer:)];
    tapGesture.delegate = self;
    [_helpView addGestureRecognizer:tapGesture];
    
    if ([Helper getIntFromNSUserDefaults:kProgressHand] == 1) {
        _helpView.hidden = YES;
        [_helpView removeGestureRecognizer:recognizer2];
    }else{
        _helpView.hidden = NO;
        [_helpView addGestureRecognizer:recognizer2];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidDisappear:(BOOL)animated{
    arrSelectedWeekDays = nil;
    [UIView animateWithDuration:.5 animations:^{
        [UIView animateWithDuration:0.5 animations:^{
            if (IPHONE4 || IPHONE5) {
                _historyView.frame = CGRectMake(0, -300, [UIScreen mainScreen].bounds.size.width, 260);
                _chartView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 460);
            }else if (IPHONE6){
                _historyView.frame = CGRectMake(0, -400, [UIScreen mainScreen].bounds.size.width, 330);
                _chartView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 565);
            }else if (IPHONE6PLUS){
                _historyView.frame = CGRectMake(0, -500, [UIScreen mainScreen].bounds.size.width, 400);
                _chartView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 620);
            }
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    isOpenClose = NO;
    if (IPHONE4 || IPHONE5) {
        _historyView.frame = CGRectMake(0, -300, [UIScreen mainScreen].bounds.size.width, 260);
        _chartView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 460);
    }else if (IPHONE6){
        _historyView.frame = CGRectMake(0, -400, [UIScreen mainScreen].bounds.size.width, 330);
        _chartView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 565);
    }else if (IPHONE6PLUS){
        _historyView.frame = CGRectMake(0, -500, [UIScreen mainScreen].bounds.size.width, 400);
        _chartView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 620);
    }
    [self setBarChart];
}

#pragma mark - Common Init

- (void)setBarChart{
    [arrData removeAllObjects];
    
    [app.arrOfWeeks enumerateObjectsUsingBlock:^(NSMutableArray *arrDays, NSUInteger idx, BOOL *stop) {
        NSMutableArray *arrTemp = [NSMutableArray array];
        NSPredicate *predicateAM = [NSPredicate predicateWithFormat:@"isAM = 1"];
        NSArray *arrSelectedDataAM = [[arrDays mutableCopy] filteredArrayUsingPredicate:predicateAM];
        if([arrSelectedDataAM count]) {
            [arrTemp addObjectsFromArray:arrSelectedDataAM];
        }
        
        NSPredicate *predicatePM = [NSPredicate predicateWithFormat:@"isPM = 1"];
        NSArray *arrSelectedDataPM = [[arrDays mutableCopy] filteredArrayUsingPredicate:predicatePM];
        if([arrSelectedDataPM count]) {
            [arrTemp addObjectsFromArray:arrSelectedDataPM];
        }
        [arrData addObject:arrTemp];
    }];
    
    NSMutableArray *arrXValues = [[NSMutableArray alloc] initWithCapacity:[arrData count]];
    NSMutableArray *arrYValues = [[NSMutableArray alloc] initWithCapacity:[arrData count]];
    [arrData enumerateObjectsUsingBlock:^(NSArray *arrDayData, NSUInteger idx, BOOL *stop) {
        NSString *xValue = [NSString stringWithFormat:@"%lu week", idx+1];
        [arrXValues addObject:xValue];
        
        NSNumber *yValue = @([arrDayData count]);
        [arrYValues addObject:yValue];
    }];
    [self.barChart setXLabels:arrXValues];
    [self.barChart setYValues:arrYValues];
    [self.barChart strokeChart];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [arrSelectedWeekDays count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProgressCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProgressCell" forIndexPath:indexPath];
    [cell setData:arrSelectedWeekDays];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
}

- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}

- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}

- (void)userClickedOnBarAtIndex:(NSInteger)barIndex
{
    NSLog(@"Click on bar %@", @(barIndex));
    _lblNoRecordFound.hidden = YES;
    arrSelectedWeekDays = [app.arrOfWeeks objectAtIndex:barIndex];
    
    if (isOpenClose) {
        isOpenClose = NO;
        [UIView animateWithDuration:.5 animations:^{
            [UIView animateWithDuration:0.5 animations:^{
                if (IPHONE4 || IPHONE5) {
                    _historyView.frame = CGRectMake(0, -300, [UIScreen mainScreen].bounds.size.width, 260);
                    _chartView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 460);
                }else if (IPHONE6){
                    _historyView.frame = CGRectMake(0, -400, [UIScreen mainScreen].bounds.size.width, 330);
                    _chartView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 565);
                }else if (IPHONE6PLUS){
                    _historyView.frame = CGRectMake(0, -500, [UIScreen mainScreen].bounds.size.width, 400);
                    _chartView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 620);
                }
            } completion:^(BOOL finished) {
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            }];
        }];
    }else{
        isOpenClose = YES;
        [_collectionView reloadData];
        [UIView animateWithDuration:.5 animations:^{
            [UIView animateWithDuration:0.5 animations:^{
                if (IPHONE4 || IPHONE5) {
                    _historyView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 260);
                    _chartView.frame = CGRectMake(0, 265, [UIScreen mainScreen].bounds.size.width, 260);
                }else if (IPHONE6){
                    _historyView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 360);
                    _chartView.frame = CGRectMake(0, 365, [UIScreen mainScreen].bounds.size.width, 360);
                }else if (IPHONE6PLUS){
                    _historyView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 460);
                    _chartView.frame = CGRectMake(0, 465, [UIScreen mainScreen].bounds.size.width, 460);
                }
            } completion:^(BOOL finished) {
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            }];
        }];
    }
}

#pragma mark - Gesture Delegate Method

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Swipe Gesture Recognization

- (void)tapGestureRecognizer: (UITapGestureRecognizer *)sender{
    [Helper addIntToUserDefaults:1 forKey:kProgressHand];
    _helpView.hidden = YES;
}

- (void)swipeRecognizer:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionDown){
        [UIView animateWithDuration:.5 animations:^{
            [UIView animateWithDuration:0.5 animations:^{
                if (IPHONE4 || IPHONE5) {
                    _historyView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 260);
                    _chartView.frame = CGRectMake(0, 265, [UIScreen mainScreen].bounds.size.width, 260);
                }else if (IPHONE6){
                    _historyView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 360);
                    _chartView.frame = CGRectMake(0, 365, [UIScreen mainScreen].bounds.size.width, 360);
                }else if (IPHONE6PLUS){
                    _historyView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 460);
                    _chartView.frame = CGRectMake(0, 465, [UIScreen mainScreen].bounds.size.width, 460);
                }
            } completion:^(BOOL finished) {
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            }];
        }];
        [Helper addIntToUserDefaults:1 forKey:kProgressHand];
        _helpView.hidden = YES;
        
    }else if (sender.direction == UISwipeGestureRecognizerDirectionUp){
        [UIView animateWithDuration:.5 animations:^{
            [UIView animateWithDuration:0.5 animations:^{
                if (IPHONE4 || IPHONE5) {
                    _historyView.frame = CGRectMake(0, -300, [UIScreen mainScreen].bounds.size.width, 260);
                    _chartView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 460);
                }else if (IPHONE6){
                    _historyView.frame = CGRectMake(0, -400, [UIScreen mainScreen].bounds.size.width, 330);
                    _chartView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 565);
                }else if (IPHONE6PLUS){
                    _historyView.frame = CGRectMake(0, -500, [UIScreen mainScreen].bounds.size.width, 400);
                    _chartView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 620);
                }
            } completion:^(BOOL finished) {
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            }];
        }];
    }
}

@end
