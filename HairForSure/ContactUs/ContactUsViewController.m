//
//  ContactUsViewController.m
//  HairForSure
//
//  Created by Manish on 25/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "ContactUsViewController.h"
#import "REFrostedViewController.h"
#import "MSTextField.h"
#import "TKAlertCenter.h"
#import "Common.h"
#import "WebClient.h"
#import "UIViewController+Additions.h"
#import "Helper.h"
#import "SocialMedia.h"
#import "SIAlertView.h"
#import "LPlaceholderTextView.h"

@interface ContactUsViewController ()

@property (strong, nonatomic) IBOutlet MSTextField *txtName;
@property (strong, nonatomic) IBOutlet MSTextField *txtEmail;
@property (strong, nonatomic) IBOutlet MSTextField *txtPhoneno;
@property (strong, nonatomic) IBOutlet LPlaceholderTextView *txtRemark;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIView *blackView;
@property (strong, nonatomic) IBOutlet UIView *shareView;
@property (strong, nonatomic) IBOutlet UIView *loaderView;
@property (strong, nonatomic) IBOutlet UIImageView *imgBack;

@end

@implementation ContactUsViewController

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
    if ([Helper getIntFromNSUserDefaults:kShareViewShow] == 1) {
        [self shareViewInit];
    }else{
        CGRect newframe=_shareView.frame;
        newframe.origin.y = [UIScreen mainScreen].bounds.size.height;
        _shareView.frame=newframe;
    }
    _loaderView.hidden = YES;
    _txtRemark.placeholderText = @"REMARKS";
    _txtRemark.placeholderColor = [UIColor lightGrayColor];

}

#pragma mark - Button Click Event

- (IBAction)btnMenuTapped:(id)sender{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)btnDoneTapped:(id)sender{
    [_txtRemark resignFirstResponder];
}

-(IBAction)doneClicked:(id)sender{
    [self hideKeyboard];
    [self.view endEditing:YES];
}

- (IBAction)btnSubmitTapped:(id)sender {
    [self resignFields];
    if([self isValidLoginDetails]){
        [self runSpinAnimationOnView:self.imgBack duration:0.06 rotations:2.0 repeat:CGFLOAT_MAX];
        _loaderView.hidden = NO;
        [[WebClient sharedClient] addContact:@{@"name":_txtName.text,@"email":_txtEmail.text,@"phone":_txtPhoneno.text,@"comments":_txtRemark.text} success:^(NSDictionary *dictionary) {
            [self clearFields];
            _loaderView.hidden = YES;
            [self.imgBack.layer removeAllAnimations];
            [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
        } failure:^(NSError *error) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:error.localizedDescription image:kErrorImage];
            _loaderView.hidden = YES;
            [self.imgBack.layer removeAllAnimations];
        }];
    }
}

#pragma mark - UITextView Delegate Methods

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView{
    UIToolbar *toolbar = [[UIToolbar alloc]init];
    [toolbar sizeToFit];
    UIBarButtonItem *btnDone=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:btnDone, nil]];
    textView.inputAccessoryView=toolbar;
    
    CGRect frame = _detailView.frame;
    if (IPHONE4) {
        frame.origin.y = -15;
    }
    [UIView animateWithDuration:0.4 animations:^{
        _detailView.frame = frame;
    }];
    [UIView commitAnimations];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self hideKeyboard];
    return YES;
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _detailView.frame;
        frame.origin.y = 64;
        _detailView.frame = frame;
    }];
    [UIView commitAnimations];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    UIToolbar *toolbar = [[UIToolbar alloc]init];
    [toolbar sizeToFit];
    UIBarButtonItem *btnDone=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)];

    [toolbar setItems:[NSArray arrayWithObjects:btnDone, nil]];
    textField.inputAccessoryView=toolbar;
    
    CGRect frame = _detailView.frame;
    if (IPHONE4) {
        if (textField == _txtPhoneno) {
            frame.origin.y = -15;
        }
    }
    [UIView animateWithDuration:0.4 animations:^{
        _detailView.frame = frame;
    }];
    [UIView commitAnimations];
}

#pragma mark - Keyboard Notifications

- (void)sfkeyboardWillHide:(NSNotification*)notification{
    [self hideKeyboard];
}

- (void)sfkeyboardWillShow:(NSNotification*)notification{
    
}

- (void)hideKeyboard{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _detailView.frame;
        frame.origin.y = 64;
        _detailView.frame = frame;
    }];
    [UIView commitAnimations];
}

- (void)resignFields{
    [self hideKeyboard];
    [_txtName resignFirstResponder];
    [_txtEmail resignFirstResponder];
    [_txtPhoneno resignFirstResponder];
    [_txtRemark resignFirstResponder];
}

- (void)clearFields{
    _txtName.text = _txtEmail.text = _txtRemark.text = _txtPhoneno.text = @"";
    [self commonInit];
}

#pragma mark - Validate login Information

- (BOOL)isValidLoginDetails{
    if ([_txtName.text isEmptyString]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterName image:kErrorImage];
        return NO;
    }else if ([_txtEmail.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterEmail image:kErrorImage];
        return NO;
    }else if ([_txtPhoneno.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterPhoneNo image:kErrorImage];
        return NO;
    }else if ([_txtRemark.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterRemark image:kErrorImage];
        return NO;
    }
    if(![_txtEmail.text isValidEmail]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidEmail image:kErrorImage];
        return NO;
    }
    return YES;
}

#pragma mark - Common Init

- (void)shareViewInit{
    CGRect newframe=_shareView.frame;
    newframe.origin.y = [UIScreen mainScreen].bounds.size.height;
    _shareView.frame=newframe;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self.blackView addGestureRecognizer:tapGestureRecognizer];
    
    [self shareImage];
}

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    [self btnCancelActionTapped:nil];
}

#pragma mark - Button Click Event

- (void)shareImage{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect newframe=_shareView.frame;
        newframe.origin.y =[UIScreen mainScreen].bounds.size.height - _shareView.frame.size.height;
        _shareView.frame=newframe;
    } completion:^(BOOL finished) {
        
    }];
    _blackView.hidden = NO;
    _blackView.alpha = 0;
    [UIView animateWithDuration:0.6
                     animations:^{
                         _blackView.alpha = 0.8;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (IBAction)btnFacebookTapped:(id)sender{
    [[SocialMedia sharedInstance] shareViaFacebook:self params:@{@"Message":@""} callback:^(BOOL success, NSError *error) {
        if(error){
            [Helper siAlertView:titleFail msg:error.localizedDescription];
        }else {
            [self displaySuccessAlertView:kFacebookPostSuccessMsg];
        }
    }];
}

- (IBAction)btnTwitterTapped:(id)sender{
    [[SocialMedia sharedInstance] shareViaTwitter:self params:@{@"Message":@""} callback:^(BOOL success, NSError *error) {
        if(error){
            [Helper siAlertView:titleFail msg:error.localizedDescription];
        }else {
            [self displaySuccessAlertView:kTwitterPostSuccessMsg];
        }
    }];
}

- (IBAction)btnCancelActionTapped:(id)sender{
    [Helper addIntToUserDefaults:0 forKey:kShareViewShow];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect newframe=_shareView.frame;
        newframe.origin.y = [UIScreen mainScreen].bounds.size.height;
        _shareView.frame=newframe;
    } completion:^(BOOL finished) {
        
    }];
    _blackView.alpha = 0.8;
    [UIView animateWithDuration:0.6
                     animations:^{
                         _blackView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         _blackView.hidden = YES;
                     }];
}

- (void)displaySuccessAlertView:(NSString *)msgSuccess{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:titleSuccess andMessage:[@"Product saved successfully!"stringByAppendingString:msgSuccess]];
    alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows;
    [alertView addButtonWithTitle:@"Ok"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
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
