//
//  PriceManager.swift
//  LocationNotes
//
//  Created by Галина Збитнева on 05.05.2021.
//

import UIKit
import StoreKit

var fullVersionProduct: SKProduct?

let idFullVersion = "LocationNotes.FullVersion"

class PriceManager: NSObject {

    func getPriceForProduct(idProduct: String){
        if !SKPaymentQueue.canMakePayments(){
            print("невозможно совершить покупку") // возможно например есть родительский контроль
            return
        }
        let request = SKProductsRequest(productIdentifiers: [idProduct])
        request.delegate = self
        request.start()
    }
}

extension PriceManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse){
        if response.invalidProductIdentifiers.count != 0 {
            print("Есть неактуальные продукты: \(response.invalidProductIdentifiers)")
        }
        if response.products.count > 0 {
            fullVersionProduct = response.products[0]
            print("Получили продукт")
        }
    }
}
