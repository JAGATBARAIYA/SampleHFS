//
//  IAPHelper.m
//  In App Rage
//
//  Created by Ray Wenderlich on 9/5/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

// 1
#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "Helper.h"
#import "Common.h"

#define msgInAppRestoreSuccess          @"All In app purchases has been restored successfully."

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";
NSString *const IAPHelperRestoreTransactionNotification = @"IAPHelperRestoreTransactionNotification";

// 2
@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

// 3
@implementation IAPHelper {
    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}

+ (IAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static IAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet *productIdentifiers = [NSSet setWithObjects:REMOVE_ADS,UNLOCK_ALL_FEATURES,nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {    
    if ((self = [super init])) {
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        // Add self as transaction observer
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
    
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    // 1
    _completionHandler = [completionHandler copy];
    
    // 2
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}

- (void)requestProductWithProductIdentifier:(NSString *)productIdentifier WithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    // 1
    _completionHandler = [completionHandler copy];
    
    // 2
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productIdentifier]];
    _productsRequest.delegate = self;
    [_productsRequest start];
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
}

#pragma mark SKPaymentTransactionOBserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"failedTransaction...");
                if (transaction.error.code != SKErrorPaymentCancelled){
                    NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:nil userInfo:nil];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
            default:
                break;
        }
        
    };
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    [_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];

}

#pragma mark - Restore Transctions

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperRestoreTransactionNotification object:nil userInfo:nil];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    
    NSMutableArray *restoredProducts = [[NSMutableArray alloc] init];
    for(SKPaymentTransaction *tansaction in queue.transactions){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:tansaction.payment.productIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [restoredProducts addObject:tansaction.payment.productIdentifier];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperRestoreTransactionNotification object:restoredProducts userInfo:nil];
}

@end