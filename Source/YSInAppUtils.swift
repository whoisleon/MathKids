//
//  YSInAppUtils.swift
//  NoFear
//
//  Created by Gururaj Tallur on 30/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation


import StoreKit

enum MyInApID
{
    case kInAp_Buy_KidsMode
    case kInAp_Buy_ExpertMode
}

let kInApPurchaseKidsModeBuyTag = 14142
let kInApPurchaseExpertModeBuyTag = 13434


private let _sharedInAppUtils = YSInAppUtils()
let IAUtilsProductPurchasedNotification:NSString = "IAUtilsProductPurchasedNotification"

let IAUtilsPurchased_Kids:NSString = "IAUtilsPurchased_Kids"
let IAUtilsPurchased_Expert:NSString = "IAUtilsPurchased_Expert"


//self.mCurrentId = MyInApID.kInAp_Buy_KidsMode

let IAUtilsFailedProductPurchasedNotification:NSString = "IAUtilsFailedProductPurchasedNotification"
class YSInAppUtils : NSObject,SKProductsRequestDelegate,SKPaymentTransactionObserver,UIAlertViewDelegate {
    
    var mCurrentId:MyInApID!
    var _transactionGoing:Bool!
    //MARK:- Initialization -
    class var sharedInAppUtils : YSInAppUtils{
        return _sharedInAppUtils
    }
    override init() {
        super.init()
        _transactionGoing = false
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    func buyKidsmode()
    {
        let alert = UIAlertView(title: "Kids Mode", message: "Would you like to unlock Kids Mode ?.", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles:"Buy","Restore")
        alert.tag = kInApPurchaseKidsModeBuyTag
        alert.show()

    }
    func buyExpertmode()
    {
        let alert = UIAlertView(title: "Expert Mode", message: "Would you like to unlock Expert Mode ?.", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles:"Buy","Restore")
        alert.tag = kInApPurchaseExpertModeBuyTag
        alert.show()
    }
    
    
    //MARK:- Requests -
    func removeAds(inAppID:NSString) {
        if (!_transactionGoing) {
            let request = SKProductsRequest(productIdentifiers: NSSet(object: inAppID) as! Set<String>)
            request.delegate = self
            request.start()
            _transactionGoing = true
        }
    }
    func restorePurchase() {
        if (!_transactionGoing) {
            SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
            _transactionGoing = true
        }
    }
    //MARK:- StoreKit Methods -
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        let myProduct = response.products as NSArray
        if (myProduct.count > 0) {
            if (SKPaymentQueue.canMakePayments()) {
                let newPayment = SKPayment(product: myProduct.objectAtIndex(0) as! SKProduct)
                SKPaymentQueue.defaultQueue().addPayment(newPayment)
            }
            else {
                let alertView = UIAlertView(title: "Your Device is Limited", message: "We have noticed that you device restrictions setting are currently limited. you can change it by going to Settings -> General -> Restrictions and turn it off", delegate: nil, cancelButtonTitle: "Ok")
                alertView.show()
            }
        }
        else {
            let alertView = UIAlertView(title: "Notification", message: "In app purchases comming soon!", delegate: nil, cancelButtonTitle: "Ok")
            alertView.show()
            NSNotificationCenter.defaultCenter().postNotificationName(IAUtilsFailedProductPurchasedNotification as String, object: nil)
        }
    }
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions{
            
            let skTransaction:SKPaymentTransaction = transaction 
            switch (skTransaction.transactionState) {
            case SKPaymentTransactionState.Purchased:
                self.completeTransaction(skTransaction)
            case SKPaymentTransactionState.Failed:
                self.failedTransaction(skTransaction)
            case SKPaymentTransactionState.Restored:
                self.restoreTransaction(skTransaction)
            default:
                break
            }
            
        }
    }
    func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError) {
        _transactionGoing = false
        NSNotificationCenter.defaultCenter().postNotificationName(IAUtilsFailedProductPurchasedNotification as String, object: nil)
    }
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        if (queue.transactions.count > 0) {
            return
        }
        else {
            let alertView = UIAlertView(title: "Notification", message: "There are no previous purchases to be restored!", delegate: nil, cancelButtonTitle: "Ok")
            alertView.show()
            NSNotificationCenter.defaultCenter().postNotificationName(IAUtilsFailedProductPurchasedNotification as String, object: nil)
            _transactionGoing = false
        }
    }
    //MARK:- Transaction State Handlers -
    func completeTransaction(transaction:SKPaymentTransaction){
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        _transactionGoing = false
        
        if self.mCurrentId == MyInApID.kInAp_Buy_KidsMode
        {
            NSNotificationCenter.defaultCenter().postNotificationName(IAUtilsPurchased_Kids as String, object: nil)
        }
        else if self.mCurrentId == MyInApID.kInAp_Buy_ExpertMode
        {
            NSNotificationCenter.defaultCenter().postNotificationName(IAUtilsPurchased_Expert as String, object: nil)
        }
        
        
    }
    func restoreTransaction(transaction:SKPaymentTransaction){
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        _transactionGoing = false
        
        
        if self.mCurrentId == MyInApID.kInAp_Buy_KidsMode
        {
            NSNotificationCenter.defaultCenter().postNotificationName(IAUtilsPurchased_Kids as String, object: nil)
        }
        else if self.mCurrentId == MyInApID.kInAp_Buy_ExpertMode
        {
            NSNotificationCenter.defaultCenter().postNotificationName(IAUtilsPurchased_Expert as String, object: nil)
        }
        
    }
    func failedTransaction(transaction:SKPaymentTransaction){
        if (transaction.error!.code != SKErrorPaymentCancelled) {
            var alertView = UIAlertView(title: "Purchase Unsuccessful", message: "Your purchase failed. Please try again", delegate: nil, cancelButtonTitle: "Ok")
            alertView.show()
        }
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        _transactionGoing = false
        NSNotificationCenter.defaultCenter().postNotificationName(IAUtilsFailedProductPurchasedNotification as String, object: nil)
    }
    
    func buyKids_inAp()
    {
        if (!_transactionGoing)
        {
            self.mCurrentId = MyInApID.kInAp_Buy_KidsMode
            let request = SKProductsRequest(productIdentifiers: NSSet(object: kInAppID_KidsMode) as! Set<String>)
            request.delegate = self
            request.start()
            _transactionGoing = true
        }
    }
    
    func restore_KidsMode()
    {
        if (!_transactionGoing) {
            self.mCurrentId = MyInApID.kInAp_Buy_KidsMode
            SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
            _transactionGoing = true
        }
    }
    
    func buyExpert_inAp()
    {
        self.mCurrentId = MyInApID.kInAp_Buy_ExpertMode
        let request = SKProductsRequest(productIdentifiers: NSSet(object: kInAppID_ExpertMode) as! Set<String>)
        request.delegate = self
        request.start()
        _transactionGoing = true
    }
    
    func restore_ExpertMode()
    {
        if (!_transactionGoing) {
            self.mCurrentId = MyInApID.kInAp_Buy_ExpertMode
            SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
            _transactionGoing = true
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        if( alertView.tag == kInApPurchaseKidsModeBuyTag)
        {
            if (buttonIndex==1)
            {
                self.buyKids_inAp()
            }
            else if (buttonIndex==2)
            {
                self.restore_KidsMode()
            }
            return;
        }
        else if( alertView.tag == kInApPurchaseExpertModeBuyTag)
        {
            if (buttonIndex==1)
            {
                self.buyExpert_inAp()
            }
            else if (buttonIndex==2)
            {
                self.restore_ExpertMode()
            }
            return;
        }
    }
}