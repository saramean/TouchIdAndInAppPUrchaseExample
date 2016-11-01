//
//  WebViewController.h
//  TouchIdAndInAppPurchaseExample
//
//  Created by Park on 2016. 10. 31..
//  Copyright © 2016년 Parkfantagram /inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController<UITextFieldDelegate, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *authWebView;
@property (weak, nonatomic) IBOutlet UITextField *authWebViewAddressField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

- (IBAction)prevBtnTouched:(id)sender;
- (IBAction)nextBtnTouched:(id)sender;
- (IBAction)stopBtnTouched:(id)sender;
- (IBAction)refreshBtnTouched:(id)sender;
- (IBAction)addressFieldResignWhenWebViewTapped:(id)sender;
- (IBAction)backToFunctionChoiceBtnTouched:(id)sender;
- (IBAction)authWebViewConfirmBtnTouched:(id)sender;
@end
