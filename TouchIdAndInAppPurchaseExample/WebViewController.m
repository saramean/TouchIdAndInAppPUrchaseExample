//
//  WebViewController.m
//  TouchIdAndInAppPurchaseExample
//
//  Created by Park on 2016. 10. 31..
//  Copyright © 2016년 Parkfantagram /inc. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.authWebViewAddressField.delegate = self;
    self.authWebView.delegate = self;
    self.activityIndicatorView.hidden = YES;
    self.authWebViewHidden = NO;
    [self.authWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideWebView) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authForWebView) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) hideWebView {
    self.viewForHideAuthWebView.frame = self.view.frame;
    [self.view addSubview:self.viewForHideAuthWebView];
    self.authWebViewHidden = YES;
}

- (void) authForWebView {
    if(self.authWebViewHidden == YES){
        LAContext *contextForAuth = [[LAContext alloc] init];
        NSError *authError = nil;
        NSString *reasonForTouchID = @"To see web browser, please authenticate yourself";
        
        if([contextForAuth canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]){
            [contextForAuth evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reasonForTouchID reply:^(BOOL success, NSError * _Nullable error) {
                if(success){
                    NSLog(@"success");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.authWebViewHidden = NO;
                        [self.viewForHideAuthWebView removeFromSuperview];
                    });
                }
                else{
                    NSLog(@"failed error is %@",error);
                }
            }];
        }
        else{
            [self.authWebViewPasswordField becomeFirstResponder];
        }
    }
}

- (IBAction)authWebViewConfirmBtnTouched:(id)sender {
    if([self.authWebViewPasswordField.text isEqualToString:[self.keychainWrapperForPassword myObjectForKey:(__bridge id)kSecValueData]]){
        self.authWebViewHidden = NO;
        self.authWebViewPasswordField.text = nil;
        [self.viewForHideAuthWebView removeFromSuperview];
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Incorrect Password" message:@"Check your password again" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:OKAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.text.length == 0){
        return NO;
    }
    NSString *prefix = @"http://";
    NSString *addressText = textField.text;
    if(!([addressText hasPrefix:prefix])){
        addressText = [prefix stringByAppendingString:addressText];
    }
    NSURL *url = [NSURL URLWithString:addressText];
    [self.authWebView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.authWebViewAddressField resignFirstResponder];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.activityIndicatorView.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.activityIndicatorView.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField selectAll:textField.text];
}

//if a page is not found, search it from google
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSString *googleSearch = @"http://www.google.com/search?q=";
    self.authWebViewAddressField.text = [self.authWebViewAddressField.text substringFromIndex:7];
    self.authWebViewAddressField.text = [self.authWebViewAddressField.text substringToIndex:self.authWebViewAddressField.text.length -1];
    googleSearch = [googleSearch stringByAppendingString:self.authWebViewAddressField.text];
    NSURL *searchUrl = [NSURL URLWithString:[googleSearch stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [self.authWebView loadRequest:[NSURLRequest requestWithURL:searchUrl]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    self.authWebViewAddressField.text = request.URL.absoluteString;
    return YES;
}

- (IBAction)prevBtnTouched:(id)sender {
    [self.authWebView goBack];
}

- (IBAction)nextBtnTouched:(id)sender {
    [self.authWebView goForward];
}

- (IBAction)stopBtnTouched:(id)sender {
    [self.authWebView stopLoading];
}

- (IBAction)refreshBtnTouched:(id)sender {
    [self.authWebView reload];
}

- (IBAction)addressFieldResignWhenWebViewTapped:(id)sender {
    [self.authWebViewAddressField resignFirstResponder];
}

- (IBAction)backToAuthBtnTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
