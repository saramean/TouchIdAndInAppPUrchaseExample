//
//  FunctionChoiceViewController.m
//  TouchIdAndInAppPurchaseExample
//
//  Created by Park on 2016. 11. 1..
//  Copyright © 2016년 Parkfantagram /inc. All rights reserved.
//

#import "FunctionChoiceViewController.h"

@interface FunctionChoiceViewController ()

@end

@implementation FunctionChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Lock for thread safe code
    self.lock = NO;
    //Notification for checking internet connection
    self.reach = [Reachability reachabilityWithHostName:@"www.google.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged) name:kReachabilityChangedNotification object:nil];
    [self.reach startNotifier];
    //allocate arrays
    if(!self.productIDs){
        self.productIDs = [[NSMutableArray alloc] init];
    }
    if(!self.productPriceArray){
        self.productPriceArray = [[NSMutableArray alloc] init];
    }
    if(!self.productArray){
        self.productArray = [[NSMutableArray alloc] init];
    }
    //add productIDs to array
    //[self.productIDs addObject:@"com.newwith.fastWithOne.consumableTest"];
    [self.productIDs addObject:@"secret_function_4"];
    [self.productIDs addObject:@"secret_function_6"];
    [self.productIDs addObject:@"secret_function_set_3"];
    //Add transaction observer
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Check Reachability
- (void) reachabilityChanged{
    if(self.reach.isReachable){
        NSLog(@"Internet available");
        self.internetConnection = YES;
        //if internet is available and didn't fetch product yet, fetch products.
        if(self.productArray.count == 0 && self.lock == NO){
            self.lock = YES;
            if([SKPaymentQueue canMakePayments]){
                //Fetch products
                NSLog(@"start shop");
                NSSet *productIdentifiers = [NSSet setWithArray:self.productIDs];
                SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
                
                productRequest.delegate = self;
                [productRequest start];
            }
            else{
                NSLog(@"shop is not available");
            }
        }
    }
    else{
        NSLog(@"Internet unavailable");
        self.internetConnection = NO;
    }
}

#pragma mark - Back to Authentication
- (IBAction)functionChoiceBackBtnTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Secret functions touched
- (IBAction)secretFunction1Touched:(id)sender {
    //user purchased the product
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"secretFunction1"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SecretFunction1ViewController *secretFucntion1ViewController = [storyboard instantiateViewControllerWithIdentifier:@"secretFunction1ViewController"];
        [self.navigationController pushViewController:secretFucntion1ViewController animated:YES];
    }
    else{
        //user didn't purchase this feature
        if([SKPaymentQueue canMakePayments] && self.internetConnection){
            self.buySecretFunction1View.frame = self.view.frame;
            //check user already purchased secret function 2
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"secretFunction2"]){
                //don't show special offer if user already purchased secret function 2
                [self.specialOfferViewSecretFunc1 removeFromSuperview];
            }
            [self.view addSubview:self.buySecretFunction1View];
        }
        //cannot use app store
        else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Fail to connect to the App Store" message:@"To use this feature, you need to buy this feature through App Store. But you are restricted to buy in app store or you are not connected to internet. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            
            [alertController addAction:OKAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (IBAction)secretFunction2Touched:(id)sender {
    //user purchased the product
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"secretFunction2"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SecretFunction2ViewController *secretFucntion2ViewController = [storyboard instantiateViewControllerWithIdentifier:@"secretFunction2ViewController"];
        [self.navigationController pushViewController:secretFucntion2ViewController animated:YES];
    }
    else{
        //user didn't purchase this feature
        if([SKPaymentQueue canMakePayments] && self.internetConnection){
            //check user already purchased secret function 1
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"secretFunction1"]){
                //don't show special offer if user already purchased secret function 1
                [self.specialOfferViewSecretFunc2 removeFromSuperview];
            }
            self.buySecretFunction2View.frame = self.view.frame;
            [self.view addSubview:self.buySecretFunction2View];
        }
        //cannot use app store
        else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Fail to connect to the App Store" message:@"To use this feature, you need to buy this feature through App Store. But you are restricted to buy in app store or you are not connected to internet. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            
            [alertController addAction:OKAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

#pragma mark - Methods in buying secret function views
- (IBAction)dismissSecretFucntionViewsCancelBtnTouched:(id)sender {
    [[[[sender superview] superview] superview] removeFromSuperview];
}

- (IBAction)buySecretFunction1OnlyTouched:(id)sender {
    //change message by the status of user purchased products
    NSString *alertControllerMessage;
    NSString *alertActionMessage;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"secretFunction2"]){
        alertControllerMessage = self.buySecretFunction1Purchase2Message;
        alertActionMessage = self.proceedMessage;
    }
    else{
        alertControllerMessage = self.buySecretFunction1PurchaseNothingMessage;
        alertActionMessage = self.buyOnlyThisMessage;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Purchase Secret Function 1" message:alertControllerMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *buyBothAction = [UIAlertAction actionWithTitle:@"Buy Both Features" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //purchase secret function set
        SKPayment *payment = [SKPayment paymentWithProduct:self.productArray[2]];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }];
    UIAlertAction *buyOnlythisAction = [UIAlertAction actionWithTitle:alertActionMessage style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //purchase secret function 1 only
        SKPayment *payment = [SKPayment paymentWithProduct:self.productArray[0]];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }];
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"secretFunction2"]){
        [alertController addAction:buyOnlythisAction];
        [alertController addAction:buyBothAction];
        [alertController addAction:cancelAction];
    }
    else{
        [alertController addAction:cancelAction];
        [alertController addAction:buyOnlythisAction];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)buySecretFunction2OnlyTouched:(id)sender {
    //change message by the status of user purchased products
    NSString *alertControllerMessage;
    NSString *alertActionMessage;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"secretFunction1"]){
        alertControllerMessage = self.buySecretFunction2Purchase1Message;
        alertActionMessage = self.proceedMessage;
    }
    else{
        alertControllerMessage = self.buySecretFunction2PurchaseNothingMessage;
        alertActionMessage = self.buyOnlyThisMessage;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Purchase Secret Function 2" message:alertControllerMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *buyBothAction = [UIAlertAction actionWithTitle:@"Buy Both Features" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //purchase secret function set
        SKPayment *payment = [SKPayment paymentWithProduct:self.productArray[2]];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }];
    UIAlertAction *buyOnlythisAction = [UIAlertAction actionWithTitle:alertActionMessage style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //purchase secret function 2 only
        SKPayment *payment = [SKPayment paymentWithProduct:self.productArray[1]];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }];
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"secretFunction1"]){
        [alertController addAction:buyOnlythisAction];
        [alertController addAction:buyBothAction];
        [alertController addAction:cancelAction];
    }
    else{
        [alertController addAction:cancelAction];
        [alertController addAction:buyOnlythisAction];
    }
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)buySecretFunctionSetTouched:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Purchase Secret Function Set" message:[NSString stringWithFormat:@"We are offering special discount for buying Secret Function 1 and 2 together. The discounted price is %@. If you press Proceed, transaction will proceed.", self.productPriceArray[2]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *proceedAction = [UIAlertAction actionWithTitle:@"Proceed" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //purchase secret function set
        SKPayment *payment = [SKPayment paymentWithProduct:self.productArray[2]];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:proceedAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Product request delegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    if(response.products.count != 0){
        //set price array by localized price
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        for(SKProduct *product in response.products){
            [self.productArray addObject:product];
            [numberFormatter setLocale:product.priceLocale];
            [self.productPriceArray addObject:[numberFormatter stringFromNumber:product.price]];
            NSLog(@"%@", [numberFormatter stringFromNumber:product.price]);
            NSLog(@"%@", self.productPriceArray);
        }
        //AlertController Message Configure with price
        self.buySecretFunction1PurchaseNothingMessage = [NSString stringWithFormat:@"The price of this feature is %@. If you buy Secret Function 1 and 2 together, we offet them at %@ not %@. Do you really want to purchase only Secret Function 1?", self.productPriceArray[0], self.productPriceArray[2], self.productPriceArray[0]];
        self.buySecretFunction2PurchaseNothingMessage = [NSString stringWithFormat:@"The price of this feature is %@. If you buy Secret Function 1 and 2 together, we offet them at %@ not %@. Do you really want to purchase only Secret Function 2?", self.productPriceArray[1], self.productPriceArray[2], self.productPriceArray[1]];
        self.buySecretFunction1Purchase2Message = [NSString stringWithFormat:@"The price of this feature is %@. If you press Proceed, transaction will proceed", self.productPriceArray[0]];
        self.buySecretFunction2Purchase1Message = [NSString stringWithFormat:@"The price of this feature is %@. If you press Proceed, transaction will proceed", self.productPriceArray[1]];
        self.proceedMessage = @"Proceed";
        self.buyOnlyThisMessage = @"Buy Only this";
        //TextView Message Configure
        self.buySecretFunction1TextView.text = [self.buySecretFunction1TextView.text stringByReplacingOccurrencesOfString:@"PRICE1" withString:self.productPriceArray[0]];
        self.buySecretFunction2TextView.text = [self.buySecretFunction2TextView.text stringByReplacingOccurrencesOfString:@"PRICE2" withString:self.productPriceArray[1]];
        self.buySecretFunction1SpecialOffer.text = [self.buySecretFunction1SpecialOffer.text stringByReplacingOccurrencesOfString:@"PRICE3" withString:self.productPriceArray[2]];
        self.buySecretFunction2SpecialOffer.text = [self.buySecretFunction2SpecialOffer.text stringByReplacingOccurrencesOfString:@"PRICE3" withString:self.productPriceArray[2]];
    }
    else{
        NSLog(@"no product");
    }
    //To handle invalid products
    if(response.invalidProductIdentifiers.count != 0){
        NSLog(@"%@", response.invalidProductIdentifiers.description);
    }
    SKProduct *firstItem = [self.productArray firstObject];
    NSLog(@"%@, count %d, first %@", self.productArray, (int) self.productArray.count, firstItem.localizedTitle);
    self.lock = NO;
}

#pragma mark - Payment Queue delegate
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    //to show secret functino view controller when transaction is suceeded.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SecretFunction1ViewController *secretFucntion1ViewController = [storyboard instantiateViewControllerWithIdentifier:@"secretFunction1ViewController"];
    SecretFunction2ViewController *secretFucntion2ViewController = [storyboard instantiateViewControllerWithIdentifier:@"secretFunction2ViewController"];
    //NSDefault to save receipt
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"purchasing");
                break;
                
            case SKPaymentTransactionStatePurchased:
                NSLog(@"transaction successed");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                if([transaction.payment.productIdentifier isEqualToString:@"secret_function_4"]){
                    [storage setBool:YES forKey:@"secretFunction1"];
                    [self.buySecretFunction1View removeFromSuperview];
                    [self.navigationController pushViewController:secretFucntion1ViewController animated:YES];
                }
                else if([transaction.payment.productIdentifier isEqualToString:@"secret_function_6"]){
                    [storage setBool:YES forKey:@"secretFunction2"];
                    [self.buySecretFunction2View removeFromSuperview];
                    [self.navigationController pushViewController:secretFucntion2ViewController animated:YES];
                }
                else if([transaction.payment.productIdentifier isEqualToString:@"secret_function_set_3"]){
                    [storage setBool:YES forKey:@"secretFunction1"];
                    [storage setBool:YES forKey:@"secretFunction2"];
                    [storage setBool:YES forKey:@"secretFunctionSet"];
                    for(UIView *view in self.view.subviews){
                        if(view == self.buySecretFunction1View){
                            [self.buySecretFunction1View removeFromSuperview];
                            [self.navigationController pushViewController:secretFucntion1ViewController animated:YES];
                        }
                        else if(view == self.buySecretFunction2View){
                            [self.buySecretFunction2View removeFromSuperview];
                            [self.navigationController pushViewController:secretFucntion2ViewController animated:YES];
                        }
                    }
                }
                break;
            case SKPaymentTransactionStateDeferred:
                NSLog(@"deffered");
                break;
            
            case SKPaymentTransactionStateRestored:
                NSLog(@"restored");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"restored %@", transaction.payment.productIdentifier);
                if([transaction.payment.productIdentifier isEqualToString:@"secret_function_4"]){
                    [storage setBool:YES forKey:@"secretFunction1"];
                }
                else if([transaction.payment.productIdentifier isEqualToString:@"secret_function_6"]){
                    [storage setBool:YES forKey:@"secretFunction2"];
                }
                else if([transaction.payment.productIdentifier isEqualToString:@"secret_function_set_3"]){
                    [storage setBool:YES forKey:@"secretFunction1"];
                    [storage setBool:YES forKey:@"secretFunction2"];
                    [storage setBool:YES forKey:@"secretFunctionSet"];
                }
                break;
            //purchase failed
            default:
                NSLog(@"transaction failed");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

#pragma mark - Purchasement restore
- (IBAction)restorePurchasementBtnTouched:(id)sender {
    //restore purchasement
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


//restore transaction
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    //to show secret functino view controller when transaction is suceeded.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SecretFunction1ViewController *secretFucntion1ViewController = [storyboard instantiateViewControllerWithIdentifier:@"secretFunction1ViewController"];
    SecretFunction2ViewController *secretFucntion2ViewController = [storyboard instantiateViewControllerWithIdentifier:@"secretFunction2ViewController"];
    NSString *restoreAlertMessage;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"secretFunction1"]){
        restoreAlertMessage = [NSString stringWithFormat:@"Secret Function1 "];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"secretFunction2"]){
        restoreAlertMessage = [NSString stringWithFormat:@"%@Secret Function2 ", restoreAlertMessage];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"secretFunctionSet"]){
        restoreAlertMessage = @"Secret Function Set ";
    }
    if(restoreAlertMessage){
        restoreAlertMessage = [NSString stringWithFormat:@"%@ is(are) restored. now you can use this features", restoreAlertMessage];
    }
    else{
        restoreAlertMessage = @"Couldn't find your Purchasement record. You didn't purchase any products";
    }
    //alert to show when purchasements are restored
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Purchasement restored" message:restoreAlertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        for(UIView *view in self.view.subviews){
            if(view == self.buySecretFunction1View && [[NSUserDefaults standardUserDefaults] objectForKey:@"secretFunction1"]){
                [self.buySecretFunction1View removeFromSuperview];
                [self.navigationController pushViewController:secretFucntion1ViewController animated:YES];
            }
            else if(view == self.buySecretFunction2View && [[NSUserDefaults standardUserDefaults] objectForKey:@"secretFunction2"]){
                [self.buySecretFunction2View removeFromSuperview];
                [self.navigationController pushViewController:secretFucntion2ViewController animated:YES];
            }
            else if(view == self.buySecretFunction1View){
                [self.buySecretFunction1View removeFromSuperview];
            }
            else if(view == self.buySecretFunction2View){
                [self.buySecretFunction2View removeFromSuperview];
            }
        }
    }];
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
