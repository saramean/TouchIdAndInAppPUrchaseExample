//
//  FunctionChoiceViewController.h
//  TouchIdAndInAppPurchaseExample
//
//  Created by Park on 2016. 11. 1..
//  Copyright © 2016년 Parkfantagram /inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
#import "SecretFunction1ViewController.h"
#import "SecretFunction2ViewController.h"
@import StoreKit;

@interface FunctionChoiceViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (strong, nonatomic) NSMutableArray *productIDs;
@property (strong, nonatomic) NSArray<SKProduct *> *productArray;
@property (strong, nonatomic) IBOutlet UIView *buySecretFunction1View;
@property (strong, nonatomic) IBOutlet UIView *buySecretFunction2View;
@property (weak, nonatomic) IBOutlet UIView *specialOfferViewSecretFunc1;
@property (weak, nonatomic) IBOutlet UIView *specialOfferViewSecretFunc2;


- (IBAction)functionChoiceBackBtnTouched:(id)sender;
- (IBAction)secretFunction1Touched:(id)sender;
- (IBAction)secretFunction2Touched:(id)sender;
- (IBAction)dismissSecretFucntionViewsCancelBtnTouched:(id)sender;
- (IBAction)buySecretFunction1OnlyTouched:(id)sender;
- (IBAction)buySecretFunction2OnlyTouched:(id)sender;
- (IBAction)buySecretFunctionSetTouched:(id)sender;

@end
