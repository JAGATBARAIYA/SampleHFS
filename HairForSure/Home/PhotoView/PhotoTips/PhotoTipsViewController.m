//
//  PhotoTipsViewController.m
//  HairForSure
//
//  Created by Manish on 07/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "PhotoTipsViewController.h"
#import "HomeViewController.h"
#import "Helper.h"
#import "Common.h"
#import "NSString+HTML.h"

@interface PhotoTipsViewController ()

@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UILabel *lbl1;
@property (strong, nonatomic) IBOutlet UILabel *lbl2;
@property (strong, nonatomic) IBOutlet UILabel *lbl3;
@property (strong, nonatomic) IBOutlet UILabel *lbl4;
@property (strong, nonatomic) IBOutlet UILabel *lbl5;
@property (strong, nonatomic) IBOutlet UILabel *lbl6;
@property (strong, nonatomic) IBOutlet UILabel *lbl7;
@property (strong, nonatomic) IBOutlet UILabel *lbl8;
@property (strong, nonatomic) IBOutlet UILabel *lbl9;
@property (strong, nonatomic) IBOutlet UILabel *lbl10;
@property (strong, nonatomic) IBOutlet UILabel *lbl11;
@property (strong, nonatomic) IBOutlet UILabel *lbl12;
@property (strong, nonatomic) IBOutlet UILabel *lbl13;

@property (strong, nonatomic) NSAttributedString *attributedString1;

@end

@implementation PhotoTipsViewController

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
    if (_isFirstTime) {
        _btnBack.hidden = YES;
        _btnNext.hidden = NO;
    }else{
        _btnBack.hidden = NO;
        _btnNext.hidden = YES;
    }
    
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:_lbl1.text];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [_lbl1.text length])];
    _lbl1.attributedText = attributedString1 ;
    [_lbl1 sizeToFit];
    
    if (IPHONE4 || IPHONE5) {
        _lbl2.frame = CGRectMake(8, _lbl1.frame.size.height+65, 304, 0);
    }else if (IPHONE6){
        _lbl2.frame = CGRectMake(8, _lbl1.frame.size.height+65, 359, 0);
    }else if (IPHONE6PLUS){
        _lbl2.frame = CGRectMake(8, _lbl1.frame.size.height+65, 398, 0);
    }
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:_lbl2.text];
    NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle2 setLineSpacing:8];
    [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [_lbl2.text length])];
    _lbl2.attributedText = attributedString2 ;
    [_lbl2 sizeToFit];

    if (IPHONE4 || IPHONE5) {
        _lbl3.frame = CGRectMake(8, _lbl2.frame.size.height+270, 304, 0);
    }else if (IPHONE6){
        _lbl3.frame = CGRectMake(8, _lbl2.frame.size.height+240, 359, 0);
    }else if (IPHONE6PLUS){
        _lbl3.frame = CGRectMake(8, _lbl2.frame.size.height+215, 398, 0);
    }
    NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc] initWithString:_lbl3.text];
    NSMutableParagraphStyle *paragraphStyle3 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle3 setLineSpacing:8];
    [attributedString3 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle3 range:NSMakeRange(0, [_lbl3.text length])];
    _lbl3.attributedText = attributedString3 ;
    [_lbl3 sizeToFit];

    if (IPHONE4 || IPHONE5) {
        _lbl4.frame = CGRectMake(8, _lbl3.frame.size.height+560, 304, 0);
    }else if (IPHONE6){
        _lbl4.frame = CGRectMake(8, _lbl3.frame.size.height+470, 359, 0);
    }else if (IPHONE6PLUS){
        _lbl4.frame = CGRectMake(8, _lbl3.frame.size.height+415, 398, 0);
    }
    NSMutableAttributedString *attributedString4 = [[NSMutableAttributedString alloc] initWithString:_lbl4.text];
    NSMutableParagraphStyle *paragraphStyle4 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle4 setLineSpacing:8];
    [attributedString4 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle4 range:NSMakeRange(0, [_lbl4.text length])];
    _lbl4.attributedText = attributedString4 ;
    [_lbl4 sizeToFit];

    if (IPHONE4 || IPHONE5) {
        _lbl5.frame = CGRectMake(8, _lbl4.frame.size.height+600, 304, 0);
    }else if (IPHONE6){
        _lbl5.frame = CGRectMake(8, _lbl4.frame.size.height+505, 359, 0);
    }else if (IPHONE6PLUS){
        _lbl5.frame = CGRectMake(8, _lbl4.frame.size.height+450, 398, 0);
    }
    NSMutableAttributedString *attributedString5 = [[NSMutableAttributedString alloc] initWithString:_lbl5.text];
    NSMutableParagraphStyle *paragraphStyle5 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle5 setLineSpacing:8];
    [attributedString5 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle5 range:NSMakeRange(0, [_lbl5.text length])];
    _lbl5.attributedText = attributedString5 ;
    [_lbl5 sizeToFit];

    if (IPHONE4 || IPHONE5) {
        _lbl6.frame = CGRectMake(8, _lbl5.frame.size.height+660, 304, 0);
    }else if (IPHONE6){
        _lbl6.frame = CGRectMake(8, _lbl5.frame.size.height+565, 359, 0);
    }else if (IPHONE6PLUS){
        _lbl6.frame = CGRectMake(8, _lbl5.frame.size.height+510, 398, 0);
    }
    NSMutableAttributedString *attributedString6 = [[NSMutableAttributedString alloc] initWithString:_lbl6.text];
    NSMutableParagraphStyle *paragraphStyle6 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle6 setLineSpacing:8];
    [attributedString6 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle6 range:NSMakeRange(0, [_lbl6.text length])];
    _lbl6.attributedText = attributedString6 ;
    [_lbl6 sizeToFit];

    if (IPHONE4 || IPHONE5) {
        _lbl7.frame = CGRectMake(8, _lbl6.frame.size.height+700, 304, 0);
    }else if (IPHONE6){
        _lbl7.frame = CGRectMake(8, _lbl6.frame.size.height+600, 359, 0);
    }else if (IPHONE6PLUS){
        _lbl7.frame = CGRectMake(8, _lbl6.frame.size.height+545, 398, 0);
    }
    NSMutableAttributedString *attributedString7 = [[NSMutableAttributedString alloc] initWithString:_lbl7.text];
    NSMutableParagraphStyle *paragraphStyle7 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle7 setLineSpacing:8];
    [attributedString7 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle7 range:NSMakeRange(0, [_lbl7.text length])];
    _lbl7.attributedText = attributedString7 ;
    [_lbl7 sizeToFit];

    if (IPHONE4 || IPHONE5) {
        _lbl8.frame = CGRectMake(8, _lbl7.frame.size.height+760, 304, 0);
    }else if (IPHONE6){
        _lbl8.frame = CGRectMake(8, _lbl7.frame.size.height+660, 359, 0);
    }else if (IPHONE6PLUS){
        _lbl8.frame = CGRectMake(8, _lbl7.frame.size.height+605, 398, 0);
    }
    NSMutableAttributedString *attributedString8 = [[NSMutableAttributedString alloc] initWithString:_lbl8.text];
    NSMutableParagraphStyle *paragraphStyle8 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle8 setLineSpacing:8];
    [attributedString8 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle8 range:NSMakeRange(0, [_lbl8.text length])];
    _lbl8.attributedText = attributedString8 ;
    [_lbl8 sizeToFit];

    if (IPHONE4 || IPHONE5) {
        _lbl9.frame = CGRectMake(8, _lbl8.frame.size.height+800, 304, 0);
    }else if (IPHONE6){
        _lbl9.frame = CGRectMake(8, _lbl8.frame.size.height+695, 359, 0);
    }else if (IPHONE6PLUS){
        _lbl9.frame = CGRectMake(8, _lbl8.frame.size.height+645, 398, 0);
    }
    NSMutableAttributedString *attributedString9 = [[NSMutableAttributedString alloc] initWithString:_lbl9.text];
    NSMutableParagraphStyle *paragraphStyle9 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle9 setLineSpacing:8];
    [attributedString9 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle9 range:NSMakeRange(0, [_lbl9.text length])];
    _lbl9.attributedText = attributedString9 ;
    [_lbl9 sizeToFit];

    if (IPHONE4 || IPHONE5) {
        _lbl10.frame = CGRectMake(8, _lbl9.frame.size.height+890, 304, 0);
    }else if (IPHONE6){
        _lbl10.frame = CGRectMake(8, _lbl9.frame.size.height+785, 359, 0);
    }else if (IPHONE6PLUS){
        _lbl10.frame = CGRectMake(8, _lbl9.frame.size.height+710, 398, 0);
    }
    NSMutableAttributedString *attributedString10 = [[NSMutableAttributedString alloc] initWithString:_lbl10.text];
    NSMutableParagraphStyle *paragraphStyle10 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle10 setLineSpacing:8];
    [attributedString10 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle10 range:NSMakeRange(0, [_lbl10.text length])];
    _lbl10.attributedText = attributedString10 ;
    [_lbl10 sizeToFit];

    if (IPHONE4 || IPHONE5) {
        _lbl11.frame = CGRectMake(8, _lbl10.frame.size.height+930, 304, 0);
    }else if (IPHONE6){
        _lbl11.frame = CGRectMake(8, _lbl10.frame.size.height+820, 359, 0);
    }else if (IPHONE6PLUS){
        _lbl11.frame = CGRectMake(8, _lbl10.frame.size.height+750, 398, 0);
    }
    NSMutableAttributedString *attributedString11 = [[NSMutableAttributedString alloc] initWithString:_lbl11.text];
    NSMutableParagraphStyle *paragraphStyle11 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle11 setLineSpacing:8];
    [attributedString11 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle11 range:NSMakeRange(0, [_lbl11.text length])];
    _lbl11.attributedText = attributedString11 ;
    [_lbl11 sizeToFit];

    if (IPHONE4 || IPHONE5) {
        _lbl12.frame = CGRectMake(8, _lbl11.frame.size.height+1050, 304, 0);
    }else if (IPHONE6){
        _lbl12.frame = CGRectMake(8, _lbl11.frame.size.height+910, 359, 0);
    }else if (IPHONE6PLUS){
        _lbl12.frame = CGRectMake(8, _lbl11.frame.size.height+845, 398, 0);
    }
    NSMutableAttributedString *attributedString12 = [[NSMutableAttributedString alloc] initWithString:_lbl12.text];
    NSMutableParagraphStyle *paragraphStyle12 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle12 setLineSpacing:8];
    [attributedString12 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle12 range:NSMakeRange(0, [_lbl12.text length])];
    _lbl12.attributedText = attributedString12 ;
    [_lbl12 sizeToFit];

    if (IPHONE4 || IPHONE5) {
        _lbl13.frame = CGRectMake(8, _lbl12.frame.size.height+1090, 304, 0);
    }else if (IPHONE6){
        _lbl13.frame = CGRectMake(8, _lbl12.frame.size.height+950, 359, 0);
    }else if (IPHONE6PLUS){
        _lbl13.frame = CGRectMake(8, _lbl12.frame.size.height+890, 398, 0);
    }
    NSMutableAttributedString *attributedString13 = [[NSMutableAttributedString alloc] initWithString:_lbl13.text];
    NSMutableParagraphStyle *paragraphStyle13 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle13 setLineSpacing:8];
    [attributedString13 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle13 range:NSMakeRange(0, [_lbl13.text length])];
    _lbl13.attributedText = attributedString13 ;
    [_lbl13 sizeToFit];

    if (IPHONE4 || IPHONE5) {
        _scrollview.contentSize = CGSizeMake(0, 1300);
    }else if (IPHONE6){
        _scrollview.contentSize = CGSizeMake(0, 1120);
    }else if (IPHONE6PLUS){
        _scrollview.contentSize = CGSizeMake(0, 1030);
    }
}

#pragma mark - Button Click Event

- (IBAction)btnBackTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnNextTapped:(id)sender{
    HomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [Helper addIntToUserDefaults:1 forKey:kScrollIndex];
    [self.navigationController pushViewController:homeViewController animated:YES];
}

- (NSMutableAttributedString*)getString:(NSString*)data fontSize:(CGFloat)size{
    NSDictionary *dictAttrib = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,  NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc]initWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:dictAttrib documentAttributes:nil error:nil];
    [attrib beginEditing];
    [attrib enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attrib.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value) {
            UIFont *oldFont = (UIFont *)value;
            [attrib removeAttribute:NSFontAttributeName range:range];
            if ([oldFont.fontName isEqualToString:@"TimesNewRomanPSMT"])
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:size] range:range];
            else if([oldFont.fontName isEqualToString:@"TimesNewRomanPS-BoldMT"])
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:size] range:range];
            else if([oldFont.fontName isEqualToString:@"TimesNewRomanPS-ItalicMT"])
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Italic" size:size] range:range];
            else if([oldFont.fontName isEqualToString:@"TimesNewRomanPS-BoldItalicMT"])
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Italic" size:size] range:range];
            else
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:size] range:range];
        }
    }];
    [attrib endEditing];
    return attrib;
}

@end
