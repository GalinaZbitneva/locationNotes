//
//  StoreManager.swift
//  LocationNotes
//
//  Created by Галина Збитнева on 05.05.2021.
//

import UIKit
import StoreKit

class StoreManager: NSObject {
   static var isFullVersion: Bool {
        set{
            UserDefaults.standard.set(newValue, forKey: "isFull")
            UserDefaults.standard.synchronize()
        }
        get{
            return UserDefaults.standard.bool(forKey: "isFull")
        }
    }
    
    func buyFullVersion(){
        if let fullVersionProduct = fullVersionProduct{
            let payment = SKPayment(product: fullVersionProduct)
            SKPaymentQueue.default().add(self) // необходимо написать расширение для класса иначе будет высвечтваться ошибка
            SKPaymentQueue.default().add(payment)
        } else {
            if !SKPaymentQueue.canMakePayments(){
                print("You can't buy a product")
                return
            }
            let request = SKProductsRequest(productIdentifiers: [idFullVersion])
            request.delegate = self
            request.start()
        }
    }
    
    
    func restoreFullVersion(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    

}

extension StoreManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse){
        if response.invalidProductIdentifiers.count != 0 {
            print("Есть неактуальные продукты: \(response.invalidProductIdentifiers)")
        }
        if response.products.count > 0 {
            fullVersionProduct = response.products[0]
            print("Получили продукт")
            self.buyFullVersion()
        }
    }
}




extension StoreManager: SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]){
        //здесь будут 5 варинтов исхода транзакции
        for transaction in transactions {
            if transaction.transactionState == .deferred{
                print ("transsaction is deferred")
            }
            if transaction.transactionState == .failed{
                print ("transsaction is failed")
                queue.finishTransaction(transaction)
                queue.remove(self) // self is store manager
        }
            if transaction.transactionState == .purchased{
                print ("transsaction is purchased")
                if transaction.payment.productIdentifier == idFullVersion{
                    StoreManager.isFullVersion = true
                }
                queue.finishTransaction(transaction)
                queue.remove(self)
    }
            if transaction.transactionState == .purchasing {
                print ("transsaction is purchasing")
            }
            if transaction.transactionState == .restored{
                print ("transsaction is restored")
                    
                if transaction.payment.productIdentifier == idFullVersion{
                StoreManager.isFullVersion = true
                }
                queue.finishTransaction(transaction)
                queue.remove(self)
                
            }
            
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        //эта функция без кода, но нужна чтобы приложение не рухнуло
    }

}

class BuyingForm {
    
    var isNeedToShow: Bool {
        if StoreManager.isFullVersion{
            return false
        }
        if notes.count <= 3{
            return false
        }
        return true
    }
    
    var storeManager = StoreManager()
    
    func showForm (inController: UIViewController){
        //if let fullVersionProduct = fullVersionProduct {
            let alertController = UIAlertController(title: "Full Version", message: "Do you want to buy full version of app?", preferredStyle: UIAlertController.Style.alert)
            
            let actionBuy = UIAlertAction(title: "Buy", style: UIAlertAction.Style.default, handler: {(alert) in
                self.storeManager.buyFullVersion() //self is buying form
            })
            let actionRestore = UIAlertAction(title: "Restore", style: UIAlertAction.Style.default, handler: {(alert) in
                self.storeManager.restoreFullVersion()
            })
            let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {(alert) in
                
            })
            alertController.addAction(actionBuy)
            alertController.addAction(actionRestore)
            alertController.addAction(actionCancel)
            
            inController.present(alertController, animated: true, completion: nil)
            
        //}
    }
    
    
}
