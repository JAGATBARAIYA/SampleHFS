//
//  ProgressViewController.h
//  HairForSure
//
//  Created by Manish on 30/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"

@interface ProgressViewController : UIViewController<PNChartDelegate>
{
    NSMutableArray *arrData;
}

- (void)viewUp;

@end
