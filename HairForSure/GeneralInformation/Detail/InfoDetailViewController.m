//
//  InfoDetailViewController.m
//  HairForSure
//
//  Created by Manish on 25/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "InfoDetailViewController.h"
#import "UILabel+extras.h"
#import "AFBlockAttributedLabel.h"
#import "Common.h"

@interface InfoDetailViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation InfoDetailViewController

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
    _webView.delegate = self;
    if (_intIndex == 0) {        
        _lblTitle.text = @"THE HAIR FACTS";
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"The Hair Facts" ofType:@"htm"];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlFile]]];
    }else if (_intIndex == 1){
        _lblTitle.text = @"UNDERSTANDING ANDROGENETIC ALOPECIA (AGA)";
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"Understanding Androgenetic Alopecia (AGA)" ofType:@"htm"];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlFile]]];
    }else if (_intIndex == 2){
        _lblTitle.text = @"THE SCIENCE BEHIND RUTEXIL";
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"The Science Behind Rutexil" ofType:@"htm"];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlFile]]];
    }else if (_intIndex == 3){
        _lblTitle.text = @"HOW TO APPLY";
         NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"How to Apply" ofType:@"htm"];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlFile]]];
    }else if (_intIndex == 4){
        _lblTitle.text = @"WHAT TO EXPECT";
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"What to Expect" ofType:@"htm"];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlFile]]];
    }else if (_intIndex == 5){
        _lblTitle.text = @"SEAL OF APPROVAL";
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"Seal Of Approval" ofType:@"htm"];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlFile]]];
    }
}

#pragma mark - WebView Delegate Method

- (void)webViewDidFinishLoad:(UIWebView *)webView {

}

#pragma mark - Button Click Event

- (IBAction)btnBackTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
