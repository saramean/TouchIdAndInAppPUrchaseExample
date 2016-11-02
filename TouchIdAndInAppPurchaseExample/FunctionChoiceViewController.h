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
#import "Reachability.h"
@import StoreKit;

@interface FunctionChoiceViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (strong, nonatomic) NSMutableArray *productIDs;
@property (strong, nonatomic) NSMutableArray<SKProduct *> *productArray;
@property (strong, nonatomic) NSMutableArray<NSString *> *productPriceArray;
@property (strong, nonatomic) IBOutlet UIView *buySecretFunction1View;
@property (strong, nonatomic) IBOutlet UIView *buySecretFunction2View;
@property (weak, nonatomic) IBOutlet UIView *specialOfferViewSecretFunc1;
@property (weak, nonatomic) IBOutlet UIView *specialOfferViewSecretFunc2;
@property (strong, nonatomic) Reachability *reach;
@property (assign, nonatomic) BOOL internetConnection;
@property (strong, nonatomic) NSString *buySecretFunction1PurchaseNothingMessage;
@property (strong, nonatomic) NSString *buySecretFunction2PurchaseNothingMessage;
@property (strong, nonatomic) NSString *buySecretFunction1Purchase2Message;
@property (strong, nonatomic) NSString *buySecretFunction2Purchase1Message;
@property (strong, nonatomic) NSString *proceedMessage;
@property (strong, nonatomic) NSString *buyOnlyThisMessage;
@property (assign, nonatomic) BOOL lock;
@property (weak, nonatomic) IBOutlet UITextView *buySecretFunction1TextView;
@property (weak, nonatomic) IBOutlet UITextView *buySecretFunction2TextView;
@property (weak, nonatomic) IBOutlet UITextView *buySecretFunction1SpecialOffer;
@property (weak, nonatomic) IBOutlet UITextView *buySecretFunction2SpecialOffer;




- (IBAction)functionChoiceBackBtnTouched:(id)sender;
- (IBAction)secretFunction1Touched:(id)sender;
- (IBAction)secretFunction2Touched:(id)sender;
- (IBAction)dismissSecretFucntionViewsCancelBtnTouched:(id)sender;
- (IBAction)buySecretFunction1OnlyTouched:(id)sender;
- (IBAction)buySecretFunction2OnlyTouched:(id)sender;
- (IBAction)buySecretFunctionSetTouched:(id)sender;
- (IBAction)restorePurchasementBtnTouched:(id)sender;


@end
