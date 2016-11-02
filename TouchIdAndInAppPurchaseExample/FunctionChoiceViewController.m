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
    if(!self.productIDs){
        self.productIDs = [[NSMutableArray alloc] init];
    }
    if(!self.productArray){
        self.productArray = [[NSMutableArray alloc] init];
    }
    //[self.productIDs addObject:@"com.newwith.fastWithOne.consumableTest"];
    [self.productIDs addObject:@"secret_function_1"];
    [self.productIDs addObject:@"secret_function_2"];
    [self.productIDs addObject:@"secret_function_set"];
    
    if([SKPaymentQueue canMakePayments]) {
        NSLog(@"start shop");
        [[SKPaymentQueue defaultQueue] addTransactionObserver:(id)self];
        NSSet *productIdentifiers = [NSSet setWithArray:self.productIDs];
        SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
        
        productRequest.delegate = self;
        [productRequest start];
    }
    else{
        NSLog(@"shop is not available");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
    //user didn't purchase this feature
    else if([SKPaymentQueue canMakePayments]){
        self.buySecretFunction1View.frame = self.view.frame;
        //check user already purchased secret function 2
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"secretFunction2"]){
            //don't show special offer if user already purchased secret function 2
            [self.specialOfferViewSecretFunc1 removeFromSuperview];
        }
        [self.view addSubview:self.buySecretFunction1View];
    }
    //cannot user app store
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Fail to connect to the App Store" message:@"To use this feature, you need to buy this feature through App Store. But the system failed to connect to the App Store. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:OKAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)secretFunction2Touched:(id)sender {
    //user purchased the product
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"secretFunction1"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SecretFunction2ViewController *secretFucntion2ViewController = [storyboard instantiateViewControllerWithIdentifier:@"secretFunction2ViewController"];
        [self.navigationController pushViewController:secretFucntion2ViewController animated:YES];
    }
    //user didn't purchase this feature
    else if([SKPaymentQueue canMakePayments]){
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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Fail to connect to the App Store" message:@"To use this feature, you need to buy this feature through App Store. But the system failed to connect to the App Store. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:OKAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - Methods in buying secret function views
- (IBAction)dismissSecretFucntionViewsCancelBtnTouched:(id)sender {
    [[[sender superview] superview] removeFromSuperview];
}

- (IBAction)buySecretFunction1OnlyTouched:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Purchase Secret Function 1" message:@"The price of this feature is 1.99 US dollar. If you buy Secret Function 1 and 2 together, we offet them at 2.99 US dollar not 3.98 US dollar. Do you really want to purchase only Secret Function 1?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *buyBothAction = [UIAlertAction actionWithTitle:@"Buy Both Features" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //purchase secret function set
        SKPayment *payment = [SKPayment paymentWithProduct:self.productArray[2]];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }];
    UIAlertAction *buyOnlythisAction = [UIAlertAction actionWithTitle:@"Buy Only this" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //purchase secret function 1 only
        SKPayment *payment = [SKPayment paymentWithProduct:self.productArray[0]];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }];
    [alertController addAction:buyOnlythisAction];
    [alertController addAction:buyBothAction];
    [alertController addAction:cancelAction];

    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)buySecretFunction2OnlyTouched:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Purchase Secret Function 2" message:@"The price of this feature is 1.99 US dollar. If you buy Secret Function 1 and 2 together, we offet them at 2.99 US dollar not 3.98 US dollar. Do you really want to purchase only Secret Function 2?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *buyBothAction = [UIAlertAction actionWithTitle:@"Buy Both Features" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //purchase secret function set
        SKPayment *payment = [SKPayment paymentWithProduct:self.productArray[2]];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }];
    UIAlertAction *buyOnlythisAction = [UIAlertAction actionWithTitle:@"Buy Only this" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //purchase secret function 2 only
        SKPayment *payment = [SKPayment paymentWithProduct:self.productArray[1]];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }];
    [alertController addAction:buyOnlythisAction];
    [alertController addAction:buyBothAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)buySecretFunctionSetTouched:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Purchase Secret Function Set" message:@"We are offering special discount for buying Secret Function 1 and 2 together. The discounted price is 2.99 US dollar. If you press OK, transaction will proceed." preferredStyle:UIAlertControllerStyleAlert];
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
        self.productArray = response.products;
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
                if([transaction.payment.productIdentifier isEqualToString:@"secret_function_1"]){
                    [storage setBool:YES forKey:@"secretFunction1"];
                    [self.buySecretFunction1View removeFromSuperview];
                    [self.navigationController pushViewController:secretFucntion1ViewController animated:YES];
                }
                else if([transaction.payment.productIdentifier isEqualToString:@"secret_function_2"]){
                    [storage setBool:YES forKey:@"secretFunction2"];
                    [self.buySecretFunction2View removeFromSuperview];
                    [self.navigationController pushViewController:secretFucntion2ViewController animated:YES];
                }
                else{
                    [storage setBool:YES forKey:@"secretFunction1"];
                    [storage setBool:YES forKey:@"secretFunction2"];
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
                break;
            //purchase failed
            default:
                NSLog(@"transaction failed");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}


@end
