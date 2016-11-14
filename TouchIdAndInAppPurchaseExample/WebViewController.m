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
    [self.authWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Field delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField selectAll:textField.text];
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

#pragma mark - Activity Indicator setting
- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.activityIndicatorView.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.activityIndicatorView.hidden = YES;
}

#pragma mark - Web view delegate
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
    self.authWebViewAddressField.text =[NSString stringWithFormat:@"%@", request.URL.absoluteURL];
    return YES;
}

#pragma mark - Button Actions
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

- (IBAction)backToFunctionChoiceBtnTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Keyboard dismiss
- (IBAction)addressFieldResignWhenWebViewTapped:(id)sender {
    [self.authWebViewAddressField resignFirstResponder];
}




@end
